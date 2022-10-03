import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/profile_controller.dart';
import 'package:qnpick/core/controllers/register_info_controller.dart';
import 'package:qnpick/ui/widgets/buttons.dart';
import 'package:qnpick/ui/widgets/header.dart';
import 'package:qnpick/ui/widgets/input_fields.dart';

const String _titleText = '추천인 닉네임을 입력해주세요';
const String _labelText = '추천인에게 500 QP가 지급됩니다';
const String _textFieldLabelText = '닉네임';
const String _skipAndStartButtonText = '입력하지 않고 시작하기 >';
const String _startButtonText = '시작하기';

class InviteUsernamePage extends GetView<RegisterInfoController> {
  const InviteUsernamePage({Key? key}) : super(key: key);

  void _onBackPressed() {
    controller.page.value = 1;
  }

  void _onStartPressed() async {
    await controller.checkExistingUser();
    if (controller.formKey.currentState != null) {
      bool isValid = controller.formKey.currentState!.validate();
      controller.isUsernameValid.value = isValid;
    }
    if (controller.doesUsernameExist.value &&
        controller.isUsernameValid.value) {
      EasyLoading.show();
      var success = await controller.registerUserInfo();
      if (success) {
        EasyLoading.showSuccess('회원가입에 성공했습니다!');
        AuthController.to.getUserInfo();
        await ProfileController.to.getUserCreatedQuestions();
        await ProfileController.to.getUserAnsweredQuestions();
        ProfileController.to.initialLoading.value = false;
      } else {
        EasyLoading.showError('오류가 발생했습니다.\n잠시 후 다시 시도해 주세요');
      }
      EasyLoading.dismiss();
      Get.until((route) => Get.currentRoute == '/home');
    }
  }

  void _onSkipAndStartPressed() async {
    EasyLoading.show();
    controller.inviteUsernameController.clear();
    var success = await controller.registerUserInfo();
    if (success) {
      EasyLoading.showSuccess('회원가입에 성공했습니다!');
      AuthController.to.getUserInfo();
    } else {
      EasyLoading.showError('오류가 발생했습니다.\n잠시 후 다시 시도해 주세요');
    }
    EasyLoading.dismiss();
    Get.until((route) => Get.currentRoute == '/home');
  }

  @override
  Widget build(BuildContext context) {
    final double _height = Get.height;

    String? _usernameValidator(String? text) {
      const pattern =
          r'^(?=.{3,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣._\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]]+(?<![_.])$';
      final regExp = RegExp(pattern);
      if (text == null || text.isEmpty) {
        return '닉네임을 입력해주세요';
      } else if (text.length < 3) {
        return '3글자 이상 입력해주세요';
      } else if (text.length > 20) {
        return '20자 이내로 입력해주세요';
      } else if (!regExp.hasMatch(text)) {
        return '닉네임 형식이 올바르지 않습니다';
      } else {
        if (!controller.doesUsernameExist.value) {
          return '존재하지 않는 사용자입니다';
        } else {
          return null;
        }
      }
    }

    void _onUsernameChanged(String text) async {
      if (controller.inviteUsernameController.text.length >= 3 &&
          controller.inviteUsernameController.text.length <= 20) {
        controller.loading.value = true;
        await controller.checkExistingUser();
        controller.loading.value = false;
      }
      if (controller.formKey.currentState != null) {
        bool isValid = controller.formKey.currentState!.validate();
        controller.isUsernameValid.value = isValid;
      }
    }

    return Column(
      children: [
        // Header(onPressed: _onBackPressed),
        Header(onPressed: _onBackPressed),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 20),
            physics: const ClampingScrollPhysics(),
            children: [
              SizedBox(
                height: 0.025 * _height,
              ),
              Column(
                children: [
                  SizedBox(
                    width: 330,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            _titleText,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 70),
                          child: Text(
                            _labelText,
                            style: TextStyle(
                              fontSize: 16,
                              color: darkPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: controller.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: InputTextField(
                      label: _textFieldLabelText,
                      controller: controller.inviteUsernameController,
                      validator: _usernameValidator,
                      onChanged: _onUsernameChanged,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Center(
            child: TextActionButton(
              buttonText: _skipAndStartButtonText,
              onPressed: _onSkipAndStartPressed,
              isUnderlined: false,
              fontSize: 16,
              fontWeight: FontWeight.normal,
              textColor: deepGrayColor,
            ),
          ),
        ),
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetX<RegisterInfoController>(
              builder: (_) {
                if (_.loading.value) {
                  return const CircularProgressIndicator(
                      color: brightPrimaryColor);
                } else {
                  return ElevatedActionButton(
                    buttonText: _startButtonText,
                    onPressed: _onStartPressed,
                    width: 330,
                    height: 50,
                    backgroundColor: brightPrimaryColor,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    activated:
                        _.isUsernameValid.value && _.doesUsernameExist.value,
                  );
                }
              },
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
