import 'package:get/get.dart';
import 'package:qnpick/ui/pages/search_page.dart';
import 'package:qnpick/ui/pages/settings_page.dart';
import 'package:qnpick/ui/pages/splash_page.dart';
import 'package:qnpick/ui/views/home_navigation_view.dart';

class AppRoutes {
  AppRoutes._();
  static final routes = [
    GetPage(name: '/', page: () => const SplashPage()),
    GetPage(name: '/home', page: () => const HomeNavigationView()),
    GetPage(name: '/search', page: () => const SearchPage()),
    GetPage(name: '/settings', page: () => const SettingsPage()),
  ];
}
