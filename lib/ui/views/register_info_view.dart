import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/core/controllers/register_info_controller.dart';
import 'package:qnpick/ui/pages/register/invite_username_page.dart';
import 'package:qnpick/ui/pages/register/register_interest_category_page.dart';
import 'package:qnpick/ui/pages/register/register_username_page.dart';

class RegisterInfoView extends GetView<RegisterInfoController> {
  const RegisterInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      const RegisterUsernamePage(),
      const RegisterInterestCategoryPage(),
      const InviteUsernamePage(),
    ];

    if (controller.page < 0 || controller.page >= _pages.length) {
      controller.page.value = 0;
    }

    return GetX<RegisterInfoController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(child: _pages[_.page.value]),
        );
      },
    );
  }
}
