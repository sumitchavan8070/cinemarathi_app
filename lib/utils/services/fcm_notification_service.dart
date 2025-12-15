import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:school_management/authentication_module/controller/update_fcm_controller.dart';
import 'package:school_management/utils/constants/init_app.dart';

import '../../constants.dart';
import '../constants/core_prep_paths.dart';

final _updateFcmController = Get.put(UpdateFcmController());

class FCMNotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> updateFCMToken() async {
    _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    if (fcmToken == null) {}

    if (corePrefs.read(CorePrepPaths.FCMToken) == null) {
      corePrefs.write(CorePrepPaths.FCMToken, fcmToken);
      _updateFcmController.updateFcm(token: fcmToken);

      return;
    } else {
      if (corePrefs.read(CorePrepPaths.FCMToken) == fcmToken) {
        _updateFcmController.updateFcm(token: fcmToken);
        return;
      }
    }

    debugPrint("FCM TOKEN $fcmToken ");

    if (fcmToken != null) {
      _updateFcmController.updateFcm(token: fcmToken);
    }
  }

  Future<void> clearFCMToken() async {
    _firebaseMessaging.deleteToken();
    _updateFcmController.updateFcm(token: null);
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();

    const initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_notification');
    final initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // ------- Android notification click handler
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        try {
          final Map payload = json.decode(details.payload ?? "");
          onNotificationClicked(payload: payload);
        } catch (e) {
          debugPrint("onDidReceiveNotificationResponse error $e");
        }
      },
    );
  }

  onNotificationClicked({required Map payload}) {
    debugPrint("---------payload::$payload");

    try {
      if (payload.containsKey('path') && payload.containsKey('arguments')) {
        final arguments = json.decode(payload['arguments']);
        if (arguments == null) {
          return;
        }
        globalGoConfig.pushNamed(payload['path'], extra: arguments);
        debugPrint("---------payload false::$payload");
      } else if (payload.containsKey('path') == true) {
        globalGoConfig.pushNamed(payload['path']);
        debugPrint("---------payload true ::${payload['path']}");
      }
    } catch (e) {
      debugPrint("onNotificationClicked error $e");
    }
  }

  // fcmListener({Function()? onTap, }) {
  //   FirebaseMessaging.onMessage.listen(
  //     (RemoteMessage message) async {
  //       debugPrint("Notification Recieved => fcmListener > ${message.notification?.body} ");
  //       createNotification(message);
  //     },
  //   );
  // }

  fcmListener({void Function(RemoteMessage message)? onMessage}) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("Notification Received => fcmListener > ${message.notification?.body}");

      createNotification(message);

      // Call the callback with the message
      onMessage?.call(message);
    });
  }

  void _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    try {
      final Map? payLoadMap = json.decode(payload ?? "");

      if (payLoadMap == null) {
        throw "error";
      }
      onNotificationClicked(payload: payLoadMap);
    } catch (e) {
      debugPrint("onDidReceiveNotificationResponse error $e");
    }
  }

  //----------------------------------------------------------

  static void createNotification(RemoteMessage message) async {
    try {
      final title = message.notification?.title ?? "";
      final body = message.notification?.body ?? "";
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const androidNotificationDetails = AndroidNotificationDetails(
        'pushnotification',
        'pushnotification',
        importance: Importance.max,
        priority: Priority.high,
        // styleInformation: BigPictureStyleInformation(DrawableResourceAndroidBitmap('ic_notification'), largeIcon:  DrawableResourceAndroidBitmap('ic_notification')),
        largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
        icon: '@mipmap/ic_launcher', // ✅ required
      );

      const iosNotificationDetail = DarwinNotificationDetails();

      const notificationDetails = NotificationDetails(
        iOS: iosNotificationDetail,
        android: androidNotificationDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: json.encode(message.data),
      );
    } catch (error) {
      debugPrint("Notification Create Error $error");
    }
  }
}
