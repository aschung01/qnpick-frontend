import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/settings_controller.dart';
import 'package:qnpick/helpers/transformers.dart';
import 'package:qnpick/helpers/url_launcher.dart';
import 'package:qnpick/ui/widgets/custom_bottom_sheets.dart';
import 'package:qnpick/ui/widgets/header.dart';
import 'package:qnpick/ui/widgets/svg_icons.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({Key? key}) : super(key: key);

  void _onBackPressed() {
    Get.back();
  }

  void _onUpdateUsernamePressed() {
    Get.toNamed('/update_username');
  }

  void _onUpdateInterestCategoriesPressed() {
    controller.interestCategoryList.clear();
    controller.interestCategoryList
        .addAll(AuthController.to.userInfo['interest_categories'].toList());
    Get.toNamed('/update_interest_categories');
  }

  void _onDeleteAccountPressed() {
    getDeleteUserBottomSheet(onDeletePressed: controller.deleteAccount);
  }

  void _onSendEmailPressed() async {
    await controller.sendFeedbackEmail();
    // Get.back();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      if (AuthController.to.isAuthenticated.value) {
        await controller.getUserNotiReception();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Header(
                onPressed: _onBackPressed,
                title: '설정',
              ),
              const _SettingsLabelItem(labelText: '계정'),
              _SettingsMenuItem(
                labelText: '닉네임',
                onTap: null,
                trailing: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GetX<AuthController>(
                      builder: (_) {
                        Future.delayed(Duration.zero, () async {
                          await _.getUserInfoIfEmpty();
                        });
                        if (_.userInfo.isNotEmpty) {
                          return Text(_.userInfo['username']);
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    IconButton(
                      onPressed: _onUpdateUsernamePressed,
                      splashRadius: 20,
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      icon: const Icon(
                        Icons.edit_rounded,
                        color: lightGrayColor,
                        size: 19,
                      ),
                    ),
                  ],
                ),
              ),
              _SettingsMenuItem(
                labelText: '이메일',
                trailing: Row(
                  children: [
                    () {
                      switch (AuthController.to.userInfo['auth_provider']) {
                        case 0:
                          return const GoogleIcon(
                            width: 18,
                            height: 18,
                          );
                        case 1:
                          return const KakaoIcon(
                            width: 18,
                            height: 18,
                          );
                        case 2:
                          return const AppleBlackIcon(
                            height: 50,
                          );
                        default:
                          return const SizedBox.shrink();
                      }
                    }(),
                    const SizedBox(width: 10),
                    Text(
                      AuthController.to.userInfo['email'] ?? '',
                    ),
                  ],
                ),
              ),
              _SettingsMenuItem(
                labelText: '푸시 알림 설정',
                trailing: GetX<SettingsController>(
                  builder: (_) {
                    return Switch(
                      value: _.userNotiReception.value,
                      onChanged: (val) {
                        _.userNotiReception.value = val;
                      },
                      activeColor: softBlueColor,
                      inactiveTrackColor: lightGrayColor,
                    );
                  },
                ),
              ),
              _SettingsMenuItem(
                labelText: '관심 카테고리',
                trailing: IconButton(
                  onPressed: _onUpdateInterestCategoriesPressed,
                  splashRadius: 20,
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  icon: const Icon(
                    Icons.edit_rounded,
                    color: lightGrayColor,
                    size: 19,
                  ),
                ),
              ),
              if (AuthController.to.userInfo['interest_categories'] != null
                  ? AuthController.to.userInfo['interest_categories'].isNotEmpty
                  : false)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GetX<AuthController>(builder: (_) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 20),
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) => Chip(
                              backgroundColor: backgroundColor,
                              label: Text(
                                questionCategoryIntToStr[
                                    _.userInfo['interest_categories'][index]]!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: darkPrimaryColor,
                                ),
                              ),
                            ),
                            separatorBuilder: ((context, index) =>
                                const SizedBox(width: 6)),
                            itemCount: _.userInfo['interest_categories'] != null
                                ? _.userInfo['interest_categories'].length
                                : 0,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              const SizedBox(height: 12),
              const _SettingsLabelItem(labelText: '정보'),
              _SettingsMenuItem(
                labelText: '이용약관',
                onTap: () {
                  UrlLauncher.launchInApp(termsOfUseUrl);
                },
              ),
              _SettingsMenuItem(
                labelText: '개인정보처리방침',
                onTap: () {
                  UrlLauncher.launchInApp(privacyPolicyUrl);
                },
              ),
              _SettingsMenuItem(
                labelText: '문의하기',
                onTap: () {
                  controller.emailController.clear();
                  getSendEmailBottomSheet(
                    controller: controller.emailController,
                    onSendPressed: _onSendEmailPressed,
                  );
                },
              ),
              _SettingsMenuItem(
                labelText: '앱 버전',
                trailing: GetBuilder<SettingsController>(
                  builder: (_) {
                    return Text(
                      _.appVersion + '+' + _.buildNumber,
                    );
                  },
                ),
              ),
              _SettingsMenuItem(
                labelText: '로그아웃',
                onTap: () => controller.signOut(),
              ),
              _SettingsMenuItem(
                labelText: '회원탈퇴',
                onTap: _onDeleteAccountPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsLabelItem extends StatelessWidget {
  final String labelText;
  const _SettingsLabelItem({
    Key? key,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 16, top: 12),
          child: Text(
            labelText,
            style: const TextStyle(
              color: darkPrimaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        const Divider(
          color: lightGrayColor,
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }
}

class _SettingsMenuItem extends StatelessWidget {
  final Function()? onTap;
  final String labelText;
  final Widget trailing;
  final double leftPadding;
  const _SettingsMenuItem({
    Key? key,
    this.onTap = null,
    required this.labelText,
    this.trailing = const SizedBox(),
    this.leftPadding = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: context.width,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: leftPadding),
                  child: Text(
                    labelText,
                    style: const TextStyle(
                      fontSize: 16,
                      color: darkPrimaryColor,
                    ),
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ));
  }
}
