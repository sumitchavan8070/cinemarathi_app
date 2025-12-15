
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/utils/constants/get_package_info.dart';
// import 'package:utilities/app_change.dart';
// import 'package:utilities/constants/core_prep_paths.dart';
// import 'package:utilities/constants/get_package_info.dart';
// import 'package:utilities/services/crashlytics_service.dart';
// import 'get_storage.dart';

late final GlobalKey<ScaffoldMessengerState> globalScaffoldMessengerKey;
late final GoRouter globalGoConfig;

Future<void> initGlobalKeys(
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
    GoRouter globalRouter,
    ) async {
  globalScaffoldMessengerKey = scaffoldMessengerKey;
  globalGoConfig = globalRouter;

  // await CoreAppInfo().initialize();

  // debugPrint("✅ Core App Name  => ${CoreAppInfo().coreAppName}");

  // if (CoreAppInfo().packageName != "com.gradding.crm") {
  // CrashlyticsService().init();
  // }

  await getPackageInfo();

  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };
}


