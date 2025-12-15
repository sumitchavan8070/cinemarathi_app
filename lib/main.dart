import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school_management/utils/constants/app_colors.dart';
import 'package:school_management/utils/constants/get_package_info.dart';
import 'package:school_management/utils/constants/init_app.dart';
import 'package:school_management/utils/constants/smooth_rectangular_border.dart';
import 'package:school_management/utils/dio/api_end_points.dart';
import 'package:school_management/utils/navigation/route_generator.dart';
import 'package:school_management/utils/services/fcm_notification_service.dart';
import 'package:school_management/utils/services/firebase_options.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp()
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GetStorage.init();

  await initGlobalKeys(scaffoldMessengerKey, goRouterConfig);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    try {
      final Map payload = message.data;
      FCMNotificationService().onNotificationClicked(payload: payload);
    } catch (e) {
      debugPrint("onDidReceiveNotificationResponse error $e");
    }
  });
  // await DynamicLinkHandler.instance.initialize(globalContext); // Initialize DynamicLinkHandler

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FCMNotificationService().fcmListener();

    super.initState();
  }

  // $ adb shell 'am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "http://links.gradding.com"

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldMessengerKey,
      builder: (context, child) {
        final boldText = MediaQuery.boldTextOf(context);

        final newMediaQueryData = MediaQuery.of(
          context,
        ).copyWith(boldText: boldText, textScaler: const TextScaler.linear(1.0));

        return MediaQuery(data: newMediaQueryData, child: child!);
      },
      debugShowCheckedModeBanner: APIEndPoints.base != APIEndPoints.live,
      title: CoreAppInfo().appName,
      routerConfig: goRouterConfig,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
        useMaterial3: true,
        primaryColor: AppColors.primaryColor,
        fontFamily: 'Quicksand',
        switchTheme: const SwitchThemeData(splashRadius: 0),
        popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.white,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.vertical(
              top: SmoothRadius(cornerRadius: 16, cornerSmoothing: 1.0),
            ),
          ),
          showDragHandle: true,
          dragHandleSize: Size(60, 4),
          clipBehavior: Clip.hardEdge,
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: SmoothBorderRadius(cornerRadius: 10),
            borderSide: BorderSide.none,
          ),
          border: OutlineInputBorder(
            borderRadius: SmoothBorderRadius(cornerRadius: 10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: SmoothBorderRadius(cornerRadius: 10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.alabaster,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.paleSky),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 1.0),
            ),
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: SmoothBorderRadius(cornerRadius: 10)),
            foregroundColor: Colors.white,
            textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 0.15),
            backgroundColor: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
