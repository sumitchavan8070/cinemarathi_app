import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:school_management/authentication_module/model/client_login_model.dart';
import 'package:school_management/constants.dart';
import 'package:school_management/utils/components/core_messenger.dart';
import 'package:school_management/utils/constants/core_prep_paths.dart';
import 'package:school_management/utils/dio/api_end_points.dart';
import 'package:school_management/utils/dio/api_request.dart';

class ClientLoginController extends GetxController with StateMixin<ClientLoginModel> {
  /// Returns:
  /// 1 = success
  /// 0 = failed
  ///

  storeUserMap({required String email, required String number, required String name}) {
    final userMap = {"email": email, "number": number, "name": name};
    logger.f("before --> $userMap ");

    corePrefs.write(CorePrepPaths.storeUserMap, userMap);
  }

  Future<num> clientLogin({required String email, required String password}) async {
    num? status = 0;

    final apiEndPoint = APIEndPoints.clientLogin;
    final postData = {"email": email, "password": password};

    try {
      final response = await postRequest(apiEndPoint: apiEndPoint, postData: postData);

      if (response.statusCode != 200) {
        throw 'API ERROR ${response.statusCode} Message ${response.statusMessage}';
      }

      /// Parse login model
      final modal = ClientLoginModel.fromJson(response.data);

      /// Your API returns { "status": 1 } for success
      status = modal.status ?? 0;

      /// Update GetX State
      change(modal, status: RxStatus.success());

      // return 0;

      // To store a user token
      corePrefs.write(CorePrepPaths.token, modal.token);
      corePrefs.write(CorePrepPaths.isLoggedIn, true);

      if (status == 0) {
        coreMessenger("Invalid Credentials", messageType: CoreScaffoldMessengerType.error);
      }

      logger.f("client accessToken --> ${modal.token}");

      debugPrint("LOGIN SUCCESS ✔");
      debugPrint("TOKEN: ${modal.token}");
      debugPrint("USER: ${modal.user?.name} ${modal.user?.email}");
      debugPrint("ROLE: ${modal.user?.role}");
      debugPrint("Res ----> : ${response.data}");
    } catch (error) {
      debugPrint("---------- $apiEndPoint clientLogin Error ----------");
      debugPrint("ClientLoginController => clientLogin > Error: $error");

      change(null, status: RxStatus.error());
      status = 0;
    } finally {
      debugPrint("---------- $apiEndPoint clientLogin End ----------");
    }

    return status;
  }
}
