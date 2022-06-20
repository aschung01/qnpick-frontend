import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qnpick/constants/app_routes.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/app_controller.dart';
import 'package:get/get.dart';
import 'package:qnpick/core/controllers/home_navigation_controller.dart';

void main() {
  Get.put<AppController>(AppController());
  Get.put<HomeNavigationController>(HomeNavigationController());
  runApp(const MyApp());
}

class MyApp extends GetView<AppController> {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
      initialRoute: '/',
      locale: const Locale('ko', 'KO'),
      getPages: AppRoutes.routes,
    );
  }
}
