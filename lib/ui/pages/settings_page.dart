import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/settings_controller.dart';
import 'package:qnpick/ui/widgets/header.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onBackPressed() {
      Get.back();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(
              onPressed: _onBackPressed,
              title: '설정',
            ),
            const _SettingsLabelItem(labelText: '계정'),
            _SettingsMenuItem(labelText: '닉네임'),
            _SettingsMenuItem(labelText: '이메일'),
            _SettingsMenuItem(labelText: '푸시 알림 설정'),
            _SettingsMenuItem(labelText: '관심 카테고리'),
            _SettingsMenuItem(labelText: '관심 지역'),
            const SizedBox(height: 12),
            const _SettingsLabelItem(labelText: '정보'),
            _SettingsMenuItem(labelText: '이용약관'),
            _SettingsMenuItem(labelText: '개인정보처리방침'),
            _SettingsMenuItem(labelText: '앱 버전'),
            _SettingsMenuItem(labelText: '로그아웃'),
            _SettingsMenuItem(labelText: '회원탈퇴'),
          ],
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
      ),
    );
  }
}
