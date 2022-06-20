import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/home_navigation_controller.dart';
import 'package:qnpick/core/controllers/profile_controller.dart';
import 'package:qnpick/core/controllers/search_controller.dart';
import 'package:qnpick/core/controllers/settings_controller.dart';
import 'package:qnpick/ui/pages/main_home_page.dart';
import 'package:qnpick/ui/pages/point_page.dart';
import 'package:qnpick/ui/pages/profile_page.dart';
import 'package:qnpick/ui/widgets/home_navigation_bar.dart';

class HomeNavigationView extends GetView<HomeNavigationController> {
  const HomeNavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put<SearchController>(SearchController());
    Get.put<ProfileController>(ProfileController());
    Get.put<SettingsController>(SettingsController());

    final List<Widget> _pages = [
      const MainHomePage(),
      const PointPage(),
      const ProfilePage(),
    ];

    Future<bool> _onBackPressed() async {
      return await controller.onBackPressed();
    }

    return GetBuilder<HomeNavigationController>(
      builder: (_) {
        return WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            backgroundColor: () {
              if (_.currentIndex == 0) {
                return darkPrimaryColor;
              } else if (_.currentIndex == 2) {
                return brightPrimaryColor;
              } else {
                return Colors.white;
              }
            }(),
            body: SafeArea(
              child: _pages[_.currentIndex],
            ),
            bottomNavigationBar: HomeNavigationBar(
              currentIndex: _.currentIndex,
              onIconTap: _.onIconTap,
              height: 60 + context.mediaQueryPadding.bottom,
              bottomPadding: context.mediaQueryPadding.bottom,
            ),
          ),
        );
      },
    );
  }
}
