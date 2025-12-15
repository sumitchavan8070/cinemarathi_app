import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/utils/dio/api_end_points.dart';
import 'package:school_management/utils/dio/api_request.dart';

class SubmitClientQueryController extends GetxController {
  Future<bool> submitClientQuery(
      String? phone,
      String? priority, {
        required String email,
        required String subject,
        required String query,
      }) async {
    final apiEndPoint = APIEndPoints.sendClientQuery;
    debugPrint("---------- $apiEndPoint submitClientQuery Start ----------");

    final cTime = DateTime.now().toString();

    try {
      final postData = {
        "email": email,
        "phone": phone ?? "+91 90000 00000",
        "subject": subject,
        "priority": priority ?? "Medium",
        "date": cTime,
        "query": query,
      };

      final response = await postRequest(apiEndPoint: apiEndPoint, postData: postData);

      debugPrint("API response: ${response.data}");

      // SAFELY HANDLE RESPONSE
      if (response.statusCode == 200 &&
          response.data is Map &&
          (response.data["status"] == 1 || response.data["success"] == true)) {
        debugPrint("Query submitted successfully!");
        return true;
      }

      // IF STATUS != 1 RETURN FALSE
      debugPrint("API returned failure");
      return false;

    } catch (error) {
      debugPrint("---------- $apiEndPoint submitClientQuery End With Error ----------");
      debugPrint("SubmitClientQueryController => Error $error ");
      return false;
    }
  }
}
