import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/community_controller.dart';
import 'package:qnpick/core/services/amplify_service.dart';
import 'package:qnpick/core/services/user_api_service.dart';

class AppController extends GetxController {
  static AppController get to => Get.find<AppController>();
  final GlobalKey scaffoldKey = GlobalKey();
  final ThemeData theme = ThemeData();

  bool initial = true;
  final Rxn<RemoteMessage> message = Rxn<RemoteMessage>();
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AmplifyService.configureAmplify();
      configLoading();
      initialize();
    });
  }

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1200)
      ..indicatorType = EasyLoadingIndicatorType.chasingDots
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 42
      ..radius = 15
      ..contentPadding = const EdgeInsets.all(26)
      ..progressColor = brightPrimaryColor
      ..backgroundColor = darkPrimaryColor
      ..indicatorColor = brightPrimaryColor
      ..textColor = brightPrimaryColor
      ..maskColor = brightPrimaryColor.withOpacity(0.5)
      ..userInteractions = false
      ..dismissOnTap = false;
  }

  Future<bool> initialize() async {
    // Firebase 초기화부터 해야 FirebaseMessaging 를 사용할 수 있다.
    await Firebase.initializeApp();
    // Android 에서는 별도의 확인 없이 리턴되지만, requestPermission()을 호출하지 않으면 수신되지 않는다.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      carPlay: true,
      // provisional: true,
      sound: true,
    );

    await getAndPostFcmToken();

    void _onMessageTap(RemoteMessage msg) async {
      if (msg.data['id'] != null) {
        Get.toNamed('/question');
        CommunityController.to.questionPageInit(msg.data['id']);
      }
    }

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage msg) {
        message.value = msg;
        Get.snackbar(
          msg.notification?.title ?? 'TITLE',
          msg.notification?.body ?? 'BODY',
          backgroundColor: Colors.white.withOpacity(0.8),
          onTap: (GetSnackBar snackBar) {
            _onMessageTap(msg);
          },
        );
      },
    );

    // FirebaseMessaging.onBackgroundMessage((RemoteMessage msg) {

    // });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage msg) async {
        _onMessageTap(msg);
      },
    );

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      getAndPostFcmToken(refreshedToken: token);
    });

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initialzationSettingsIOS = const IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var initializationSettings = InitializationSettings(
        android: initialzationSettingsAndroid, iOS: initialzationSettingsIOS);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    return true;
  }

  Future<void> getAndPostFcmToken({String? refreshedToken}) async {
    late var token;
    if (refreshedToken == null) {
      token = await FirebaseMessaging.instance.getToken();
    } else {
      token = refreshedToken;
    }

    if (token != null) {
      if (AuthController.to.isAuthenticated.value) {
        await UserApiService.postFcmToken(token);
      }
    }
    log("token : ${token ?? 'token NULL!'}");
  }
}
