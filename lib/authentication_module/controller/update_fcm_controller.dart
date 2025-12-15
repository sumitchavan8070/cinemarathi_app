import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/utils/dio/api_end_points.dart';
import 'package:school_management/utils/dio/api_request.dart';

class UpdateFcmController extends GetxController {
  updateFcm({required String? token}) async {
    final apiEndPoint = APIEndPoints.updateFcmToken;
    debugPrint("---------- $apiEndPoint updateFcm Start ----------");
    // final deviceId = await getDeviceId();
    final cTime = DateTime.now().toString();

    try {
      final postData = {
        "fcm_token": token,
        "currentTime": cTime,
        // "deviceID": deviceId,
      };

      final response = await postRequest(
        apiEndPoint: apiEndPoint,
        postData: postData ?? {"fcm_token": token},
      );

      if (response.statusCode != 200) {
        throw 'API ERROR ${response.statusCode} Message ${response.statusMessage}';
      }
    } catch (error) {
      debugPrint("---------- $apiEndPoint updateFcm End With Error ----------");
      debugPrint("UpdateFcmController => updateFcm > Error $error ");
    } finally {
      debugPrint("---------- $apiEndPoint updateFcm End ----------");
    }
  }
}
