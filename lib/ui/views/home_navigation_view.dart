import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/home_navigation_controller.dart';
import 'package:qnpick/ui/pages/add_question_map_page.dart';
import 'package:qnpick/ui/pages/community/main_home_page.dart';
import 'package:qnpick/ui/pages/point_page.dart';
import 'package:qnpick/ui/pages/profile_page.dart';
import 'package:qnpick/ui/widgets/home_navigation_bar.dart';

class HomeNavigationView extends GetView<HomeNavigationController> {
  const HomeNavigationView({Key? key}) : super(key: key);

  void rebuildAllChildren(BuildContext context) {
    print('rebuild');
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
    HomeNavigationController.to.rebuild = false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const MainHomePage(),
      const AddQuestionMapPage(),
      const PointPage(),
      const ProfilePage(),
    ];

    return GetBuilder<HomeNavigationController>(
      builder: (_) {
        if (_.rebuild) {
          Future.delayed(Duration.zero, () {
            rebuildAllChildren(context);
          });
        }

        return WillPopScope(
          onWillPop: controller.onBackPressed,
          child: Scaffold(
            backgroundColor: () {
              if (_.currentIndex == 0) {
                return darkPrimaryColor;
              } else if (_.currentIndex == 3) {
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
