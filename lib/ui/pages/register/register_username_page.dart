import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/register_info_controller.dart';
import 'package:qnpick/ui/widgets/buttons.dart';
import 'package:qnpick/ui/widgets/input_fields.dart';

const String _titleText = '닉네임을 입력해 주세요';
const String _textFieldLabelText = '닉네임';
const String _nextButtonText = '다음';

class RegisterUsernamePage extends GetView<RegisterInfoController> {
  const RegisterUsernamePage({Key? key}) : super(key: key);

  void _onNextPressed() async {
    await controller.checkAvailableUsername();
    if (controller.formKey.currentState != null) {
      bool isValid = controller.formKey.currentState!.validate();
      controller.isUsernameValid.value = isValid;
    }
    if (controller.isUsernameAvailable.value &&
        controller.isUsernameValid.value) {
      controller.page.value = 1;
    }
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
        if (!controller.isUsernameAvailable.value) {
          return '이미 존재하는 닉네임이에요';
        } else {
          return null;
        }
      }
    }

    void _onUsernameChanged(String text) async {
      if (controller.usernameController.text.length >= 3 &&
          controller.usernameController.text.length <= 20) {
        controller.loading.value = true;
        await controller.checkAvailableUsername();
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
        SizedBox(
          height: 56,
        ),
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Form(
                    key: controller.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: InputTextField(
                      label: _textFieldLabelText,
                      controller: controller.usernameController,
                      validator: _usernameValidator,
                      onChanged: _onUsernameChanged,
                    ),
                  ),
                ],
              ),
            ],
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
                    buttonText: _nextButtonText,
                    onPressed: _onNextPressed,
                    width: 330,
                    height: 50,
                    backgroundColor: brightPrimaryColor,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    activated:
                        _.isUsernameValid.value && _.isUsernameAvailable.value,
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
