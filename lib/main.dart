import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qnpick/constants/app_routes.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/app_controller.dart';
import 'package:get/get.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/community_controller.dart';
import 'package:qnpick/core/controllers/community_write_controller.dart';
import 'package:qnpick/core/controllers/deep_link_controller.dart';
import 'package:qnpick/core/controllers/home_navigation_controller.dart';
import 'package:qnpick/core/controllers/kakao_controller.dart';
import 'package:qnpick/core/controllers/main_home_controller.dart';
import 'package:qnpick/core/controllers/map_controller.dart';
import 'package:qnpick/core/controllers/profile_controller.dart';
import 'package:qnpick/core/controllers/register_info_controller.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:qnpick/core/controllers/search_controller.dart';
import 'package:qnpick/core/controllers/settings_controller.dart';
import 'package:qnpick/core/controllers/store_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put<AppController>(AppController());
  Get.put<AuthController>(AuthController());
  Get.put<RegisterInfoController>(RegisterInfoController());
  Get.put<KakaoController>(KakaoController());
  Get.put<HomeNavigationController>(HomeNavigationController());
  Get.put<DeepLinkController>(DeepLinkController());
  Get.put<SearchController>(SearchController());
  Get.put<ProfileController>(ProfileController());
  Get.put<SettingsController>(SettingsController());
  Get.put<CommunityController>(CommunityController());
  Get.put<CommunityWriteController>(CommunityWriteController());
  Get.put<MainHomeController>(MainHomeController());
  Get.put<MapController>(MapController());
  Get.put<StoreController>(StoreController());
  KakaoSdk.init(nativeAppKey: kakaoNativeAppKey);
  runApp(const MyApp());
}

class MyApp extends GetView<AppController> {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: GetMaterialApp(
        theme: controller.theme.copyWith(
          colorScheme: controller.theme.colorScheme.copyWith(
            // secondary: brightPrimaryColor.withOpacity(0.3),
            secondary: lightBrightPrimaryColor,
          ),
        ),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ko', 'KR'),
        ],
        key: controller.scaffoldKey,
        initialRoute: '/',
        locale: const Locale('ko', 'KO'),
        getPages: AppRoutes.routes,
        builder: EasyLoading.init(),
      ),
    );
  }
}
