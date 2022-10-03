import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/settings_controller.dart';
import 'package:qnpick/ui/widgets/buttons.dart';
import 'package:qnpick/ui/widgets/header.dart';
import 'package:qnpick/ui/widgets/input_fields.dart';

const String _titleText = '새 닉네임을 입력해 주세요';
const String _textFieldLabelText = '닉네임';
const String _completeButtonText = '완료';

class UpdateUsernamePage extends GetView<SettingsController> {
  const UpdateUsernamePage({Key? key}) : super(key: key);

  void _onBackPressed() {
    Get.back();
    controller.reset();
  }

  void _onCompletePressed() async {
    await controller.updateUsername();
  }

  @override
  Widget build(BuildContext context) {
    final double _height = Get.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      Form(
                        key: controller.formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: InputTextField(
                          label: _textFieldLabelText,
                          controller: controller.usernameController,
                          validator: controller.usernameValidator,
                          onChanged: controller.onUsernameChanged,
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
                GetX<SettingsController>(
                  builder: (_) {
                    if (_.loading.value) {
                      return const CircularProgressIndicator(
                          color: brightPrimaryColor);
                    } else {
                      return ElevatedActionButton(
                        buttonText: _completeButtonText,
                        onPressed: _onCompletePressed,
                        width: 330,
                        height: 50,
                        backgroundColor: brightPrimaryColor,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        activated: _.isUsernameValid.value &&
                            _.isUsernameAvailable.value,
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
