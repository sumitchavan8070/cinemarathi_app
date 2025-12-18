import 'package:get/get.dart';
import 'package:school_management/utils/components/core_messenger.dart';
import 'package:school_management/utils/dio/api_end_points.dart';
import 'package:school_management/utils/dio/api_request.dart';

class CastingCallsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<dynamic> castingCalls = [].obs;
  RxList<dynamic> myCastingCalls = [].obs;
  RxList<dynamic> myApplications = [].obs;
  var selectedCastingCall = <String, dynamic>{}.obs;
  RxList<dynamic> castingCallApplications = [].obs;

  // Search and filter parameters
  RxString searchKeyword = ''.obs;
  RxString selectedRole = ''.obs;
  RxString selectedGender = ''.obs;
  RxString selectedLocation = ''.obs;
  RxDouble minBudget = 0.0.obs;
  RxDouble maxBudget = 100000.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCastingCalls();
  }

  // -------------------------------------------------------------
  // FETCH ALL CASTING CALLS
  // -------------------------------------------------------------
  Future<void> fetchCastingCalls() async {
    try {
      isLoading.value = true;
      final res = await getRequest(apiEndPoint: APIEndPoints.getCastingCalls);
      
      if (res.statusCode == 200) {
        final responseData = res.data;
        // API returns direct array for GET /api/casting/calls
        if (responseData is List) {
          castingCalls.value = responseData;
        } else {
          castingCalls.value = [];
        }
        castingCalls.refresh();
      }
    } catch (e) {
      print("FETCH CASTING CALLS ERROR → $e");
      coreMessenger(
        "Failed to load casting calls",
        messageType: CoreScaffoldMessengerType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  // FETCH SINGLE CASTING CALL
  // -------------------------------------------------------------
  Future<void> fetchCastingCallById(int id) async {
    try {
      isLoading.value = true;
      final res = await getRequest(apiEndPoint: '${APIEndPoints.getCastingCallById}/$id');
      
      if (res.statusCode == 200) {
        selectedCastingCall.value = res.data;
        selectedCastingCall.refresh();
      }
    } catch (e) {
      print("FETCH CASTING CALL ERROR → $e");
      coreMessenger(
        "Failed to load casting call details",
        messageType: CoreScaffoldMessengerType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  // FETCH MY CASTING CALLS (Production House)
  // -------------------------------------------------------------
  Future<void> fetchMyCastingCalls() async {
    try {
      isLoading.value = true;
      final res = await getRequest(apiEndPoint: APIEndPoints.getMyCastingCalls);
      
      if (res.statusCode == 200) {
        final responseData = res.data;
        if (responseData is List) {
          myCastingCalls.value = responseData;
        } else {
          myCastingCalls.value = [];
        }
        myCastingCalls.refresh();
      }
    } catch (e) {
      print("FETCH MY CASTING CALLS ERROR → $e");
      coreMessenger(
        "Failed to load your casting calls",
        messageType: CoreScaffoldMessengerType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  // CREATE CASTING CALL
  // -------------------------------------------------------------
  Future<bool> createCastingCall(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final res = await postRequest(
        apiEndPoint: APIEndPoints.createCastingCall,
        postData: data,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final responseData = res.data;
        if (responseData["message"] != null || responseData["castingCallId"] != null) {
          coreMessenger(
            responseData["message"] ?? "Casting call created successfully",
            messageType: CoreScaffoldMessengerType.success,
          );
          await fetchMyCastingCalls();
          await fetchCastingCalls();
          return true;
        }
      }
      return false;
    } catch (e) {
      print("CREATE CASTING CALL ERROR → $e");
      final errorMsg = e.toString().contains("403") 
          ? "Only production houses can create casting calls"
          : "Failed to create casting call";
      coreMessenger(errorMsg, messageType: CoreScaffoldMessengerType.error);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  // UPDATE CASTING CALL
  // -------------------------------------------------------------
  Future<bool> updateCastingCall(int id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final res = await putRequest(
        apiEndPoint: '${APIEndPoints.updateCastingCall}/$id',
        putData: data,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final responseData = res.data;
        if (responseData["message"] != null) {
          coreMessenger(
            responseData["message"] ?? "Casting call updated successfully",
            messageType: CoreScaffoldMessengerType.success,
          );
          await fetchMyCastingCalls();
          await fetchCastingCallById(id);
          return true;
        }
      }
      return false;
    } catch (e) {
      print("UPDATE CASTING CALL ERROR → $e");
      coreMessenger(
        "Failed to update casting call",
        messageType: CoreScaffoldMessengerType.error,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  // DELETE CASTING CALL
  // -------------------------------------------------------------
  Future<bool> deleteCastingCall(int id) async {
    try {
      isLoading.value = true;
      final res = await deleteRequest(
        apiEndPoint: '${APIEndPoints.deleteCastingCall}/$id',
      );

      if (res.statusCode == 200 || res.statusCode == 204) {
        coreMessenger(
          "Casting call deleted successfully",
          messageType: CoreScaffoldMessengerType.success,
        );
        await fetchMyCastingCalls();
        await fetchCastingCalls();
        return true;
      }
      return false;
    } catch (e) {
      print("DELETE CASTING CALL ERROR → $e");
      coreMessenger(
        "Failed to delete casting call",
        messageType: CoreScaffoldMessengerType.error,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  // GET APPLICATIONS FOR CASTING CALL
  // -------------------------------------------------------------
  Future<void> fetchCastingCallApplications(int castingCallId) async {
    try {
      isLoading.value = true;
      final res = await getRequest(
        apiEndPoint: '${APIEndPoints.getCastingCallApplications}/$castingCallId/applications',
      );

      if (res.statusCode == 200) {
        final responseData = res.data;
        if (responseData["applications"] != null) {
          castingCallApplications.value = responseData["applications"] ?? [];
        } else if (responseData is List) {
          castingCallApplications.value = responseData;
        } else {
          castingCallApplications.value = [];
        }
        castingCallApplications.refresh();
      }
    } catch (e) {
      print("FETCH APPLICATIONS ERROR → $e");
      coreMessenger(
        "Failed to load applications",
        messageType: CoreScaffoldMessengerType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  // UPDATE APPLICATION STATUS
  // -------------------------------------------------------------
  Future<bool> updateApplicationStatus(int applicationId, String status) async {
    try {
      isLoading.value = true;
      // Validate status
      final validStatuses = ['applied', 'shortlisted', 'selected', 'rejected'];
      if (!validStatuses.contains(status.toLowerCase())) {
        coreMessenger(
          "Invalid status. Must be one of: applied, shortlisted, selected, rejected",
          messageType: CoreScaffoldMessengerType.error,
        );
        return false;
      }
      
      final res = await putRequest(
        apiEndPoint: '${APIEndPoints.updateApplicationStatus}/$applicationId/status',
        putData: {"status": status.toLowerCase()},
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final responseData = res.data;
        coreMessenger(
          responseData["message"] ?? "Application status updated",
          messageType: CoreScaffoldMessengerType.success,
        );
        // Refresh applications list if we have applications loaded
        if (castingCallApplications.isNotEmpty) {
          final castingCallId = castingCallApplications[0]["casting_call_id"];
          if (castingCallId != null) {
            await fetchCastingCallApplications(castingCallId);
          }
        }
        // Also refresh my applications
        await fetchMyApplications();
        return true;
      }
      return false;
    } catch (e) {
      print("UPDATE APPLICATION STATUS ERROR → $e");
      coreMessenger(
        "Failed to update application status",
        messageType: CoreScaffoldMessengerType.error,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  // APPLY TO CASTING CALL
  // -------------------------------------------------------------
  Future<bool> applyToCastingCall(int castingCallId, {String? auditionLink}) async {
    try {
      isLoading.value = true;
      final data = {
        "casting_call_id": castingCallId,
        if (auditionLink != null && auditionLink.isNotEmpty) "audition_link": auditionLink,
      };

      final res = await postRequest(
        apiEndPoint: APIEndPoints.applyToCastingCall,
        postData: data,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final responseData = res.data;
        coreMessenger(
          responseData["message"] ?? "Application submitted successfully",
          messageType: CoreScaffoldMessengerType.success,
        );
        // Refresh my applications and casting calls list
        await fetchMyApplications();
        await fetchCastingCalls();
        return true;
      }
      return false;
    } catch (e) {
      print("APPLY TO CASTING CALL ERROR → $e");
      final errorMsg = e.toString().contains("400") && e.toString().contains("already")
          ? "You have already applied to this casting call"
          : "Failed to submit application";
      coreMessenger(errorMsg, messageType: CoreScaffoldMessengerType.error);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  // GET MY APPLICATIONS
  // -------------------------------------------------------------
  Future<void> fetchMyApplications() async {
    try {
      isLoading.value = true;
      final res = await getRequest(apiEndPoint: APIEndPoints.getMyApplications);

      if (res.statusCode == 200) {
        final responseData = res.data;
        if (responseData is List) {
          myApplications.value = responseData;
        } else {
          myApplications.value = [];
        }
        myApplications.refresh();
      }
    } catch (e) {
      print("FETCH MY APPLICATIONS ERROR → $e");
      coreMessenger(
        "Failed to load your applications",
        messageType: CoreScaffoldMessengerType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  // SEARCH CASTING CALLS
  // -------------------------------------------------------------
  Future<void> searchCastingCalls({
    String? keyword,
    String? role,
    String? gender,
    String? location,
    double? minBudget,
    double? maxBudget,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      isLoading.value = true;
      
      final queryParams = <String, dynamic>{
        "page": page,
        "limit": limit,
      };
      
      if (keyword != null && keyword.isNotEmpty) queryParams["keyword"] = keyword;
      if (role != null && role.isNotEmpty) queryParams["role"] = role;
      // Ensure gender is lowercase to match API expectations
      if (gender != null && gender.isNotEmpty) {
        queryParams["gender"] = gender.toLowerCase();
      }
      if (location != null && location.isNotEmpty) queryParams["location"] = location;
      if (minBudget != null && minBudget > 0) queryParams["min_budget"] = minBudget;
      if (maxBudget != null && maxBudget > 0) queryParams["max_budget"] = maxBudget;

      // Build query string
      final queryString = queryParams.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
          .join('&');

      // Search endpoint requires authentication
      final res = await getRequest(
        apiEndPoint: '${APIEndPoints.searchCastingCalls}?$queryString',
      );

      if (res.statusCode == 200) {
        final responseData = res.data;
        // API returns { "castingCalls": [...], "total": 25, "page": 1, "limit": 10 }
        if (responseData["castingCalls"] != null) {
          castingCalls.value = responseData["castingCalls"] ?? [];
        } else if (responseData is List) {
          castingCalls.value = responseData;
        } else {
          castingCalls.value = [];
        }
        castingCalls.refresh();
      }
    } catch (e) {
      print("SEARCH CASTING CALLS ERROR → $e");
      coreMessenger(
        "Failed to search casting calls",
        messageType: CoreScaffoldMessengerType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  // CHECK IF USER HAS APPLIED
  // -------------------------------------------------------------
  bool hasApplied(int castingCallId) {
    return myApplications.any((app) => app["casting_call_id"] == castingCallId);
  }

  // -------------------------------------------------------------
  // GET APPLICATION STATUS
  // -------------------------------------------------------------
  String? getApplicationStatus(int castingCallId) {
    try {
      final application = myApplications.firstWhere(
        (app) => app["casting_call_id"] == castingCallId,
      );
      return application["status"] as String?;
    } catch (e) {
      return null;
    }
  }

  // -------------------------------------------------------------
  // CHECK IF CASTING CALL IS ACTIVE
  // -------------------------------------------------------------
  bool isCastingCallActive(Map<String, dynamic> castingCall) {
    try {
      final auditionDate = castingCall["audition_date"];
      if (auditionDate == null) return true; // If no date, consider active
      
      DateTime? parsedDate;
      if (auditionDate is String) {
        parsedDate = DateTime.tryParse(auditionDate);
      } else if (auditionDate is DateTime) {
        parsedDate = auditionDate;
      }
      
      if (parsedDate == null) return true; // If can't parse, consider active
      
      // Casting call is active if audition date is today or in the future
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final auditionDay = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
      
      return auditionDay.isAfter(today) || auditionDay.isAtSameMomentAs(today);
    } catch (e) {
      print("CHECK ACTIVE STATUS ERROR → $e");
      return true; // Default to active if error
    }
  }

  // -------------------------------------------------------------
  // GET ACTIVE CASTING CALLS
  // -------------------------------------------------------------
  List<dynamic> getActiveCastingCalls() {
    return castingCalls.where((call) => isCastingCallActive(call)).toList();
  }

  // -------------------------------------------------------------
  // GET INACTIVE CASTING CALLS
  // -------------------------------------------------------------
  List<dynamic> getInactiveCastingCalls() {
    return castingCalls.where((call) => !isCastingCallActive(call)).toList();
  }
}

