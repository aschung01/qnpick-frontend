import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/settings_controller.dart';
import 'package:qnpick/helpers/transformers.dart';
import 'package:qnpick/ui/widgets/buttons.dart';
import 'package:qnpick/ui/widgets/custom_snackbar.dart';
import 'package:qnpick/ui/widgets/header.dart';

const String _titleText = '관심 분야를 선택해 주세요';
const String _labelText = '최대 5개까지 선택이 가능합니다';
const String _completeButtonText = '완료';

class UpdateInterestCategoryPage extends GetView<SettingsController> {
  const UpdateInterestCategoryPage({Key? key}) : super(key: key);

  void _onBackPressed() {
    Get.back();
  }

  void _onCompletePressed() async {
    await controller.updateInterestCategories();
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
                          children: [
                            const Text(
                              _titleText,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: darkPrimaryColor,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 70),
                              child: Text(
                                _labelText,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: darkPrimaryColor,
                                ),
                              ),
                            ),
                            GetX<SettingsController>(
                              builder: (_) {
                                return Wrap(
                                  spacing: 5,
                                  runSpacing: 10,
                                  children: List.generate(
                                    questionCategoryIntToStr.length,
                                    (index) {
                                      bool _activated = _.interestCategoryList
                                          .contains(index);
                                      return ChoiceChip(
                                        onSelected: (bool sel) {
                                          if (sel) {
                                            if (_.interestCategoryList.length <
                                                5) {
                                              _.interestCategoryList.add(index);
                                            } else {
                                              if (!Get.isSnackbarOpen) {
                                                Get.showSnackbar(
                                                  BottomSnackbar(
                                                    text:
                                                        '관심 분야는 최대 5개까지만 선택 가능합니다',
                                                  ),
                                                );
                                              }
                                            }
                                          } else {
                                            _.interestCategoryList
                                                .remove(index);
                                          }
                                        },
                                        selected: _.interestCategoryList
                                            .contains(index),
                                        selectedColor: brightPrimaryColor,
                                        disabledColor: Colors.white,
                                        backgroundColor: Colors.white,
                                        side: _activated
                                            ? const BorderSide(
                                                color: brightPrimaryColor)
                                            : const BorderSide(
                                                color: deepGrayColor),
                                        elevation: 0,
                                        pressElevation: 3,
                                        label: Text(
                                          questionCategoryIntToStr[index]!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: _activated
                                                ? Colors.white
                                                : deepGrayColor,
                                            fontWeight: _activated
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: GetX<SettingsController>(
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
                      activated: _.interestCategoryList.length > 2 &&
                          !(_.interestCategoryList.toList().every((e) =>
                                  AuthController
                                      .to.userInfo['interest_categories']
                                      .contains(e)) &&
                              _.interestCategoryList.length ==
                                  AuthController.to
                                      .userInfo['interest_categories'].length),
                    );
                  }
                },
              ),
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
