import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:school_management/utils/constants/init_app.dart';
import 'package:school_management/utils/dio/api_end_points.dart';


import '../../constants.dart';
import 'api_client.dart';

// logoutUnAuthorisedClient() {
//   core
// }

String addQueryParaToRequest(String path, {Map<String, dynamic>? query}) {
  final uri = Uri.parse(
    APIEndPoints.base + path,
  ).replace(queryParameters: query?.map((key, value) => MapEntry(key, value?.toString())));
  return uri.toString();
}

Future<Response>  getRequest({required String apiEndPoint}) async {
  Dio client = NewClient().init(globalGoConfig);

  try {
    debugPrint("^^^^^^^^^^^^^^^^^^ $apiEndPoint getRequest Start ^^^^^^^^^^^^^^^^^^");

    final response = await client.get(apiEndPoint);

    debugPrint("^^^^^^^^^^^^^^^^^^ $apiEndPoint getRequest End ^^^^^^^^^^^^^^^^^^");

    if (response.statusCode != 200) {
      throw Exception('Failed to load data: ${response.statusCode}');
    }

    return response;
  } catch (e) {
    logger.e("Error in getRequest => apiEndPoint : $apiEndPoint || Error: $e");

    rethrow;
  }
}

Future<Response> postRequest({
  required String apiEndPoint,
  required Map<String, dynamic> postData,
  FormData? formData,
}) async {
  // Dio client = NewClient().init();
  Dio client = NewClient().init(globalGoConfig);

  Response? response;
  try {
    debugPrint("🔄 POST request started: $apiEndPoint");

    if (formData != null) {
      debugPrint("📦 Sending formData to $apiEndPoint");
    } else {
      debugPrint("📤 Sending postData to $apiEndPoint: $postData");
    }

    response = await client.post(
      apiEndPoint,
      data: formData ?? postData,
      queryParameters: formData == null ? postData : null,
    );

    debugPrint("✅ POST request completed: $apiEndPoint");

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load data: ${response.statusCode} \n -sdf----------- ${response.data}');
    }

    return response;
  } catch (e) {
    logger.e("❌ Error in POST request: $apiEndPoint | $e \n ${response?.data}");
    rethrow;
  }
}

Future<Response> deleteRequest({required String apiEndPoint}) async {
  Dio client = NewClient().init(globalGoConfig);

  Response? response;
  try {
    debugPrint("🗑️ DELETE request started: $apiEndPoint");

    response = await client.delete(apiEndPoint);

    debugPrint("✅ DELETE request completed: $apiEndPoint");

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Failed to delete: ${response.statusCode} \n ${response.data}');
    }

    return response;
  } catch (e) {
    logger.e("❌ Error in DELETE request: $apiEndPoint | $e \n ${response?.data}");
    rethrow;
  }
}

Future<Response> putRequest({
  required String apiEndPoint,
  required Map<String, dynamic> putData,
}) async {
  Dio client = NewClient().init(globalGoConfig);

  Response? response;
  try {
    debugPrint("🔄 PUT request started: $apiEndPoint");
    debugPrint("📤 Sending putData to $apiEndPoint: $putData");

    response = await client.put(
      apiEndPoint,
      data: putData,
    );

    debugPrint("✅ PUT request completed: $apiEndPoint");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Failed to update: ${response.statusCode} \n ${response.data}');
    }

    return response;
  } catch (e) {
    logger.e("❌ Error in PUT request: $apiEndPoint | $e \n ${response?.data}");
    rethrow;
  }
}
