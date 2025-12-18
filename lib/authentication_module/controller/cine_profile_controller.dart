import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:school_management/authentication_module/model/client_profile_model.dart';
import 'package:school_management/constants.dart';
import 'package:school_management/utils/components/core_messenger.dart';
import 'package:school_management/utils/constants/core_prep_paths.dart';
import 'package:school_management/utils/dio/api_end_points.dart';
import 'package:school_management/utils/dio/api_request.dart';

class ProfileController extends GetxController  with StateMixin<ClientProfileModel>{
  // Observables
  RxBool isLoading = true.obs;
  RxBool isUploading = false.obs;

  RxMap profile = {}.obs;
  RxMap stats = {}.obs;
  RxList<dynamic> portfolio = [].obs;
  RxMap plan = {}.obs;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    fetchFullProfile();
    super.onInit();
  }

  // -------------------------------------------------------------
  // FETCH FULL PROFILE (Best API)
  // -------------------------------------------------------------
  Future<void> fetchFullProfile() async {
    try {
      isLoading.value = true;

      final res = await getRequest(apiEndPoint: "users/profile/full");

      if (res.statusCode == 200) {
        final responseData = res.data;

        // Handle different response formats
        final dynamic status = responseData["status"];
        final bool isSuccess = status == true || status == 1 || status == "1";

        if (isSuccess || responseData["profile"] != null) {
          profile.value = responseData["profile"] ?? {};
          stats.value = responseData["stats"] ?? {};
          portfolio.value = responseData["portfolio"] ?? [];
          plan.value = responseData["plan"] ?? {};
        }
      }
    } catch (e) {
      print("PROFILE LOAD ERROR → $e");
      // Optionally show error message to user
      // coreMessenger(
      //   "Failed to load profile: ${e.toString()}",
      //   messageType: CoreScaffoldMessengerType.error,
      // );
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  // SEPARATE API CALLS (IF YOU WANT THEM)
  // -------------------------------------------------------------
  Future<void> fetchProfile() async {
    final res = await getRequest(apiEndPoint: "users/profile");
    profile.value = res.data["profile"] ?? {};
  }

  Future<void> fetchStats() async {
    final res = await getRequest(apiEndPoint: "users/profile/stats");
    stats.value = res.data["stats"] ?? {};
  }

  Future<void> fetchPortfolio() async {
    try {
      final res = await getRequest(apiEndPoint: APIEndPoints.getPortfolioImages);
      if (res.statusCode == 200) {
        final responseData = res.data;
        if (responseData["status"] == true || responseData["portfolio"] != null) {
          // API returns array of objects with id, url, imageUrl, index
          final List<dynamic> portfolioList = responseData["portfolio"] ?? [];
          portfolio.value = portfolioList;
          portfolio.refresh(); // Notify listeners
        }
      }
    } catch (e) {
      print("PORTFOLIO FETCH ERROR → $e");
    }
  }

  Future<void> fetchPlan() async {
    final res = await getRequest(apiEndPoint: "users/plan");
    plan.value = res.data["plan"] ?? {};
  }

  // -------------------------------------------------------------
  // UPLOAD PROFILE IMAGE (with source selection)
  // -------------------------------------------------------------
  Future<void> uploadProfileImage({ImageSource? source}) async {
    try {
      ImageSource? selectedSource = source;

      // If source is not provided, this method will be called after user selects
      // The view will handle showing the selection dialog
      if (selectedSource == null) {
        return; // View should call this method with a source
      }

      // Pick image from selected source (camera or gallery)
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: selectedSource,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile == null) {
        return; // User cancelled
      }

      await _uploadImageFile(pickedFile);
    } catch (e) {
      print("IMAGE UPLOAD ERROR → $e");
      coreMessenger(
        "Failed to upload image: ${e.toString()}",
        messageType: CoreScaffoldMessengerType.error,
      );
    }
  }

  // -------------------------------------------------------------
  // INTERNAL: UPLOAD IMAGE FILE
  // -------------------------------------------------------------
  Future<void> _uploadImageFile(XFile pickedFile) async {
    try {
      isUploading.value = true;

      // Create FormData for file upload
      final file = File(pickedFile.path);
      final fileName = pickedFile.path.split('/').last;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      // Upload to server
      final res = await postRequest(
        apiEndPoint: APIEndPoints.uploadProfileImage,
        postData: {},
        formData: formData,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final responseData = res.data;

        // Handle different success flags: true, 1, "1", or "success": true
        final dynamic status = responseData["status"];
        final bool isSuccessFlag = status == true ||
            status == 1 ||
            status == "1" ||
            responseData["success"] == true ||
            responseData["success"] == 1;

        if (isSuccessFlag) {
          // Update profile with new image URL (if backend returns it)
          final imageUrl = responseData["data"]?["url"] ??
              responseData["data"]?["imageUrl"] ??
              responseData["url"] ??
              responseData["imageUrl"] ??
              responseData["data"]?["fileUrl"];

          if (imageUrl != null && imageUrl.toString().isNotEmpty) {
            profile.value["avatar"] = imageUrl;
            profile.refresh();
          }

          // Always refresh full profile from API so all fields (avatar, stats, etc.) are updated
          await fetchFullProfile();

          coreMessenger(
            responseData["message"] ?? "Profile image updated successfully",
            messageType: CoreScaffoldMessengerType.success,
          );
        } else {
          final errorMsg = responseData["message"] ??
              responseData["error"] ??
              "Failed to upload image";
          coreMessenger(errorMsg, messageType: CoreScaffoldMessengerType.error);
        }
      } else {
        coreMessenger(
          "Upload failed with status code: ${res.statusCode}",
          messageType: CoreScaffoldMessengerType.error,
        );
      }
    } catch (e) {
      print("IMAGE UPLOAD ERROR → $e");
      coreMessenger(
        "Failed to upload image: ${e.toString()}",
        messageType: CoreScaffoldMessengerType.error,
      );
    } finally {
      isUploading.value = false;
    }
  }

  // -------------------------------------------------------------
  // UPLOAD FILE (Generic file upload)
  // -------------------------------------------------------------
  Future<String?> uploadFile({required File file, String? folder}) async {
    try {
      isUploading.value = true;

      final fileName = file.path.split('/').last;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
        if (folder != null) 'folder': folder,
      });

      final res = await postRequest(
        apiEndPoint: APIEndPoints.uploadFile,
        postData: {},
        formData: formData,
      );

      if (res.statusCode == 200) {
        final responseData = res.data;

        if (responseData["status"] == true || responseData["success"] == true) {
          final fileUrl =
              responseData["data"]?["url"] ?? responseData["url"] ?? responseData["fileUrl"];

          return fileUrl;
        } else {
          final errorMsg = responseData["message"] ?? "Failed to upload file";
          coreMessenger(errorMsg, messageType: CoreScaffoldMessengerType.error);
          return null;
        }
      }

      return null;
    } catch (e) {
      print("FILE UPLOAD ERROR → $e");
      coreMessenger(
        "Failed to upload file: ${e.toString()}",
        messageType: CoreScaffoldMessengerType.error,
      );
      return null;
    } finally {
      isUploading.value = false;
    }
  }

  // -------------------------------------------------------------
  // UPLOAD PORTFOLIO IMAGES (Multiple for gallery, Single for camera)
  // -------------------------------------------------------------
  Future<void> uploadPortfolioImages({ImageSource? source}) async {
    try {
      ImageSource? selectedSource = source;

      if (selectedSource == null) {
        return;
      }

      List<XFile> pickedFiles = [];

      if (selectedSource == ImageSource.camera) {
        // Camera - pick single image
        final XFile? pickedFile = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
          maxWidth: 1024,
          maxHeight: 1024,
        );
        if (pickedFile != null) {
          pickedFiles = [pickedFile];
        }
      } else {
        // Gallery - pick multiple images
        pickedFiles = await _imagePicker.pickMultiImage(
          imageQuality: 85,
          maxWidth: 1024,
          maxHeight: 1024,
        );
      }

      if (pickedFiles.isEmpty) {
        return; // User cancelled
      }

      // Check if already at maximum limit
      final currentCount = portfolio.length;
      if (currentCount >= 6) {
        coreMessenger(
          "Maximum 6 portfolio images allowed. You already have 6 images. Please delete one first.",
          messageType: CoreScaffoldMessengerType.error,
        );
        return;
      }

      // Check if adding these images would exceed limit
      if (currentCount + pickedFiles.length > 6) {
        coreMessenger(
          "Cannot upload ${pickedFiles.length} images. You already have $currentCount images. Maximum 6 images allowed.",
          messageType: CoreScaffoldMessengerType.error,
        );
        return;
      }

      await _uploadPortfolioFiles(pickedFiles);
    } catch (e) {
      print("PORTFOLIO UPLOAD ERROR → $e");
      coreMessenger(
        "Failed to upload portfolio images: ${e.toString()}",
        messageType: CoreScaffoldMessengerType.error,
      );
    }
  }

  // -------------------------------------------------------------
  // UPLOAD SINGLE PORTFOLIO IMAGE (for replacing or adding single)
  // -------------------------------------------------------------
  Future<void> uploadSinglePortfolioImage({
    ImageSource? source,
    int? index,
  }) async {
    try {
      ImageSource? selectedSource = source;

      if (selectedSource == null) {
        return;
      }

      // Pick single image
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: selectedSource,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile == null) {
        return; // User cancelled
      }

      // If index is provided, update at that index, otherwise add new
      if (index != null) {
        await _updatePortfolioImageAtIndex(pickedFile, index);
      } else {
        // Check if we can add more
        final currentCount = portfolio.length;
        if (currentCount >= 6) {
          coreMessenger(
            "Maximum 6 portfolio images allowed. Please delete one first.",
            messageType: CoreScaffoldMessengerType.error,
          );
          return;
        }
        // Use single image upload endpoint
        await _uploadSinglePortfolioFile(pickedFile);
      }
    } catch (e) {
      print("SINGLE PORTFOLIO UPLOAD ERROR → $e");
      coreMessenger(
        "Failed to upload portfolio image: ${e.toString()}",
        messageType: CoreScaffoldMessengerType.error,
      );
    }
  }

  // -------------------------------------------------------------
  // INTERNAL: UPLOAD SINGLE PORTFOLIO IMAGE
  // -------------------------------------------------------------
  Future<void> _uploadSinglePortfolioFile(XFile pickedFile) async {
    try {
      isUploading.value = true;

      final file = File(pickedFile.path);
      final fileName = pickedFile.path.split('/').last;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      // Upload single image using POST /api/portfolio/image
      final res = await postRequest(
        apiEndPoint: APIEndPoints.uploadSinglePortfolioImage,
        postData: {},
        formData: formData,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final responseData = res.data;

        // Handle success response - API returns status, message, image, total_images, portfolio
        final dynamic status = responseData["status"];
        final bool isSuccess = status == true ||
            status == 1 ||
            status == "1" ||
            responseData["message"] != null;

        if (isSuccess) {
          // Refresh portfolio from API to get updated list
          await fetchPortfolio();
          // Also refresh full profile to sync
          await fetchFullProfile();

          coreMessenger(
            responseData["message"] ?? "Portfolio image uploaded successfully",
            messageType: CoreScaffoldMessengerType.success,
          );
        } else {
          final errorMsg = responseData["error"] ??
              responseData["message"] ??
              "Failed to upload portfolio image";
          coreMessenger(errorMsg, messageType: CoreScaffoldMessengerType.error);
        }
      } else {
        final responseData = res.data;
        final errorMsg = responseData["error"] ??
            responseData["message"] ??
            "Upload failed with status code: ${res.statusCode}";
        coreMessenger(errorMsg, messageType: CoreScaffoldMessengerType.error);
      }
    } catch (e) {
      print("SINGLE PORTFOLIO UPLOAD ERROR → $e");
      coreMessenger(
        "Failed to upload portfolio image: ${e.toString()}",
        messageType: CoreScaffoldMessengerType.error,
      );
    } finally {
      isUploading.value = false;
    }
  }

  // -------------------------------------------------------------
  // INTERNAL: UPDATE PORTFOLIO IMAGE AT SPECIFIC INDEX
  // -------------------------------------------------------------
  Future<void> _updatePortfolioImageAtIndex(XFile pickedFile, int index) async {
    try {
      isUploading.value = true;

      final file = File(pickedFile.path);
      final fileName = pickedFile.path.split('/').last;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      // Use PUT request to update at specific index
      final dio = Dio();
      dio.options.baseUrl = APIEndPoints.base;
      dio.options.headers["Authorization"] =
          'Bearer ${corePrefs.read(CorePrepPaths.token)}';

      final res = await dio.put(
        '${APIEndPoints.updatePortfolioImage}/$index',
        data: formData,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final responseData = res.data;

        if (responseData["portfolio"] != null || responseData["message"] != null) {
          // Refresh portfolio
          await fetchPortfolio();
          await fetchFullProfile();

          coreMessenger(
            responseData["message"] ?? "Portfolio image updated successfully",
            messageType: CoreScaffoldMessengerType.success,
          );
        } else {
          final errorMsg = responseData["error"] ??
              responseData["message"] ??
              "Failed to update portfolio image";
          coreMessenger(errorMsg, messageType: CoreScaffoldMessengerType.error);
        }
      }
    } catch (e) {
      print("UPDATE PORTFOLIO IMAGE ERROR → $e");
      coreMessenger(
        "Failed to update portfolio image: ${e.toString()}",
        messageType: CoreScaffoldMessengerType.error,
      );
    } finally {
      isUploading.value = false;
    }
  }

  // -------------------------------------------------------------
  // INTERNAL: UPLOAD PORTFOLIO FILES
  // -------------------------------------------------------------
  Future<void> _uploadPortfolioFiles(List<XFile> pickedFiles) async {
    try {
      isUploading.value = true;

      // Create FormData with multiple files
      final formData = FormData();

      for (var pickedFile in pickedFiles) {
        final file = File(pickedFile.path);
        final fileName = pickedFile.path.split('/').last;

        formData.files.add(
          MapEntry(
            'files',
            await MultipartFile.fromFile(file.path, filename: fileName),
          ),
        );
      }

      // Upload to server
      final res = await postRequest(
        apiEndPoint: APIEndPoints.uploadPortfolioImages,
        postData: {},
        formData: formData,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final responseData = res.data;

        // Handle success response
        if (responseData["portfolio"] != null || responseData["uploaded"] != null) {
          // Refresh portfolio from API
          await fetchPortfolio();
          // Also refresh full profile to sync
          await fetchFullProfile();

          coreMessenger(
            responseData["message"] ?? "Portfolio images uploaded successfully",
            messageType: CoreScaffoldMessengerType.success,
          );
        } else {
          final errorMsg = responseData["error"] ??
              responseData["message"] ??
              "Failed to upload portfolio images";
          coreMessenger(errorMsg, messageType: CoreScaffoldMessengerType.error);
        }
      } else {
        coreMessenger(
          "Upload failed with status code: ${res.statusCode}",
          messageType: CoreScaffoldMessengerType.error,
        );
      }
    } catch (e) {
      print("PORTFOLIO UPLOAD ERROR → $e");
      coreMessenger(
        "Failed to upload portfolio images: ${e.toString()}",
        messageType: CoreScaffoldMessengerType.error,
      );
    } finally {
      isUploading.value = false;
    }
  }

  // -------------------------------------------------------------
  // DELETE PORTFOLIO IMAGE AT INDEX
  // -------------------------------------------------------------
  Future<void> deletePortfolioImage(int index) async {
    try {
      isUploading.value = true;

      final res = await deleteRequest(
        apiEndPoint: '${APIEndPoints.deletePortfolioImage}/$index',
      );

      if (res.statusCode == 200 || res.statusCode == 204) {
        // Refresh portfolio
        await fetchPortfolio();
        await fetchFullProfile();

        coreMessenger(
          "Portfolio image deleted successfully",
          messageType: CoreScaffoldMessengerType.success,
        );
      }
    } catch (e) {
      print("DELETE PORTFOLIO ERROR → $e");
      coreMessenger(
        "Failed to delete portfolio image: ${e.toString()}",
        messageType: CoreScaffoldMessengerType.error,
      );
    } finally {
      isUploading.value = false;
    }
  }

  // -------------------------------------------------------------
  // UPDATE PROFILE
  // -------------------------------------------------------------
  Future<void> updateProfile({
    String? name,
    String? contact,
    String? gender,
    String? dob,
    String? location,
    String? bio,
    String? portfolioUrl,
    String? availability,
    List<String>? skills,
    String? profession,
    String? category,
    int? experienceYears,
    String? instagram,
    String? youtube,
    int? heightCm,
    int? weightKg,
    String? auditionLink,
    String? awards,
  }) async {
    try {
      isUploading.value = true;

      // Build request body with only provided fields
      final Map<String, dynamic> updateData = {};

      if (name != null) updateData['name'] = name;
      if (contact != null) updateData['contact'] = contact;
      if (gender != null) updateData['gender'] = gender;
      if (dob != null) updateData['dob'] = dob;
      if (location != null) updateData['location'] = location;
      if (bio != null) updateData['bio'] = bio;
      if (portfolioUrl != null) updateData['portfolio_url'] = portfolioUrl;
      if (availability != null) updateData['availability'] = availability;
      if (skills != null) updateData['skills'] = skills;
      if (profession != null) updateData['profession'] = profession;
      if (category != null) updateData['category'] = category;
      if (experienceYears != null) updateData['experience_years'] = experienceYears;
      if (instagram != null) updateData['instagram'] = instagram;
      if (youtube != null) updateData['youtube'] = youtube;
      if (heightCm != null) updateData['height_cm'] = heightCm;
      if (weightKg != null) updateData['weight_kg'] = weightKg;
      if (auditionLink != null) updateData['audition_link'] = auditionLink;
      if (awards != null) updateData['awards'] = awards;

      if (updateData.isEmpty) {
        coreMessenger(
          "No fields to update",
          messageType: CoreScaffoldMessengerType.error,
        );
        return;
      }

      final res = await putRequest(
        apiEndPoint: APIEndPoints.updateProfile,
        putData: updateData,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final responseData = res.data;

        if (responseData["status"] == true || responseData["message"] != null) {
          // Refresh profile after update
          await fetchFullProfile();

          coreMessenger(
            responseData["message"] ?? "Profile updated successfully",
            messageType: CoreScaffoldMessengerType.success,
          );
        } else {
          final errorMsg = responseData["error"] ??
              responseData["message"] ??
              "Failed to update profile";
          coreMessenger(errorMsg, messageType: CoreScaffoldMessengerType.error);
        }
      }
    } catch (e) {
      print("UPDATE PROFILE ERROR → $e");
      coreMessenger(
        "Failed to update profile: ${e.toString()}",
        messageType: CoreScaffoldMessengerType.error,
      );
    } finally {
      isUploading.value = false;
    }
  }

  // -------------------------------------------------------------
  // CHANGE PASSWORD
  // -------------------------------------------------------------
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isUploading.value = true;

      final res = await postRequest(
        apiEndPoint: APIEndPoints.changePassword,
        postData: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final responseData = res.data;

        final dynamic status = responseData["status"];
        final bool isSuccess = status == true ||
            status == 1 ||
            status == "1" ||
            responseData["success"] == true ||
            responseData["success"] == 1;

        if (isSuccess) {
          coreMessenger(
            responseData["message"] ?? "Password changed successfully",
            messageType: CoreScaffoldMessengerType.success,
          );
        } else {
          final errorMsg = responseData["error"] ??
              responseData["message"] ??
              "Failed to change password";
          coreMessenger(errorMsg, messageType: CoreScaffoldMessengerType.error);
        }
      } else {
        coreMessenger(
          "Failed to change password. Please try again.",
          messageType: CoreScaffoldMessengerType.error,
        );
      }
    } catch (e) {
      print("CHANGE PASSWORD ERROR → $e");
      coreMessenger(
        "Failed to change password: ${e.toString()}",
        messageType: CoreScaffoldMessengerType.error,
      );
    } finally {
      isUploading.value = false;
    }
  }
}
