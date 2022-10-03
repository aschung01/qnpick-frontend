import 'package:get/get.dart';
import 'package:qnpick/ui/pages/auth_page.dart';
import 'package:qnpick/ui/pages/community/edit_question_page.dart';
import 'package:qnpick/ui/pages/community/question_list_page.dart';
import 'package:qnpick/ui/pages/community/question_page.dart';
import 'package:qnpick/ui/pages/community/search_page.dart';
import 'package:qnpick/ui/pages/draw_page.dart';
import 'package:qnpick/ui/pages/initial_help_page.dart';
import 'package:qnpick/ui/pages/purchase_points_page.dart';
import 'package:qnpick/ui/pages/settings_page.dart';
import 'package:qnpick/ui/pages/splash_page.dart';
import 'package:qnpick/ui/pages/community/write_question_page.dart';
import 'package:qnpick/ui/pages/update_interest_categories_page.dart';
import 'package:qnpick/ui/pages/update_interest_local_page.dart';
import 'package:qnpick/ui/pages/update_username_page.dart';
import 'package:qnpick/ui/views/home_navigation_view.dart';
import 'package:qnpick/ui/views/register_info_view.dart';

class AppRoutes {
  AppRoutes._();
  static final routes = [
    GetPage(name: '/', page: () => const SplashPage()),
    GetPage(
      name: '/home',
      page: () => const HomeNavigationView(),
      transition: Transition.fadeIn,
    ),
    GetPage(name: '/search', page: () => const SearchPage()),
    GetPage(name: '/settings', page: () => const SettingsPage()),
    GetPage(name: '/question_list', page: () => const QuestionListPage()),
    GetPage(name: '/question', page: () => const QuestionPage()),
    GetPage(name: '/write', page: () => const WriteQuestionPage()),
    GetPage(name: '/edit_question', page: () => const EditQuestionPage()),
    GetPage(name: '/purchase', page: () => const PurchasePointsPage()),
    GetPage(name: '/auth', page: () => const AuthPage()),
    GetPage(name: '/register_info', page: () => const RegisterInfoView()),
    GetPage(name: '/update_username', page: () => const UpdateUsernamePage()),
    GetPage(
        name: '/update_interest_local',
        page: () => const UpdateInterestLocalPage()),
    GetPage(
        name: '/update_interest_categories',
        page: () => const UpdateInterestCategoryPage()),
  ];
}
