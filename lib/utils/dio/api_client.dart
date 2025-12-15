import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/constants.dart';
import 'package:school_management/utils/constants/core_prep_paths.dart' show CorePrepPaths;
import 'package:school_management/utils/constants/get_package_info.dart';
import 'package:school_management/utils/dio/api_end_points.dart';

class NewClient {
  Dio init(GoRouter router) {
    final osType = Platform.isAndroid ? "Android" : "IOS";
    final appName = CoreAppInfo().coreAppName;

    var authToken = corePrefs.read(CorePrepPaths.token);
    bool isLoggedIn = corePrefs.read(CorePrepPaths.isLoggedIn) == true;

    Dio dio = Dio();
    dio.options.baseUrl = APIEndPoints.base;
    dio.options.headers["Authorization"] = 'Bearer ${authToken ?? ""}';
    dio.options.headers["AppName"] = appName;
    dio.options.headers["source"] = osType;
    dio.options.headers["appBuildNumber"] = CoreAppInfo().buildNumber;
    dio.options.headers["appVersion"] = CoreAppInfo().version;
    dio.options.headers["packageName"] = CoreAppInfo().packageName;

    logger.w("options.headers || ${dio.options.headers}");

    void updateCrashlytics(DioException e, RequestOptions options) {
      final baseUrl = options.baseUrl;
      final apiEndPoint = options.path;
      final requestMethod = options.method;
      final postData = options.queryParameters;

      if (!kDebugMode) {
        final crashlytics = FirebaseCrashlytics.instance;

        crashlytics.recordError("API EXCEPTION DIO: ${options.path}", e.stackTrace, fatal: true);
        crashlytics.setCustomKey("baseUrl", baseUrl);
        crashlytics.setCustomKey("api_end_point", apiEndPoint);
        crashlytics.setCustomKey("request_method", requestMethod);
        crashlytics.setCustomKey("AppName", appName);
        crashlytics.setCustomKey("token", authToken ?? "");
        crashlytics.setCustomKey("isLoggedInStatus", isLoggedIn);

        if (options.method == 'POST') {
          crashlytics.setCustomKey("post_data", postData);
        }

        final crashlyticsMap = {
          "baseUrl": baseUrl,
          "apiEndPoint": apiEndPoint,
          "requestMethod": requestMethod,
          "postData": postData
        };

        logger.e("Crashlytics updated -->  || crashlyticsMap $crashlyticsMap ");
      }
    }

    dio.interceptors.add(AuthInterceptor(router));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onError: (e, handler) {
          // For update the Crashlytics to the Firebase
          updateCrashlytics(e, e.requestOptions);

          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}

class AuthInterceptor extends Interceptor {
  final GoRouter router;

  AuthInterceptor(this.router);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.i("AuthInterceptor ${err.response?.statusCode}");
    if (err.response?.statusCode == 401) {
      corePrefs.erase();

      router.go('/login');
    }

    super.onError(err, handler);
  }
}
