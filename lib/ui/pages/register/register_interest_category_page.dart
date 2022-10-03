import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/register_info_controller.dart';
import 'package:qnpick/helpers/transformers.dart';
import 'package:qnpick/ui/widgets/buttons.dart';
import 'package:qnpick/ui/widgets/custom_snackbar.dart';
import 'package:qnpick/ui/widgets/header.dart';

const String _titleText = '관심 분야를 선택해 주세요';
const String _labelText = '최대 5개까지 선택이 가능합니다';
const String _nextTimeButtonText = '다음에 선택할게요 >';
const String _startButtonText = '다음';

class RegisterInterestCategoryPage extends GetView<RegisterInfoController> {
  const RegisterInterestCategoryPage({Key? key}) : super(key: key);

  void _onBackPressed() {
    controller.page.value = 0;
  }

  void _onNextTimePressed() async {
    controller.page.value = 2;
  }

  void _onNextPressed() async {
    controller.page.value = 2;
  }

  @override
  Widget build(BuildContext context) {
    final double _height = Get.height;

    return Column(
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
                          padding: EdgeInsets.only(top: 10, bottom: 45),
                          child: Text(
                            _labelText,
                            style: TextStyle(
                              fontSize: 16,
                              color: darkPrimaryColor,
                            ),
                          ),
                        ),
                        GetX<RegisterInfoController>(
                          builder: (_) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Wrap(
                                spacing: 5,
                                runSpacing: 10,
                                children: List.generate(
                                  questionCategoryIntToStr.length,
                                  (index) {
                                    bool _activated =
                                        _.interestCategoryList.contains(index);
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
                                          _.interestCategoryList.remove(index);
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
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Center(
            child: TextActionButton(
              buttonText: _nextTimeButtonText,
              onPressed: _onNextTimePressed,
              isUnderlined: false,
              fontSize: 16,
              fontWeight: FontWeight.normal,
              textColor: deepGrayColor,
            ),
          ),
        ),
        Center(
          child: GetX<RegisterInfoController>(
            builder: (_) {
              if (_.loading.value) {
                return const CircularProgressIndicator(
                    color: brightPrimaryColor);
              } else {
                return ElevatedActionButton(
                  buttonText: _startButtonText,
                  onPressed: _onNextPressed,
                  width: 330,
                  height: 50,
                  backgroundColor: brightPrimaryColor,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  activated: _.interestCategoryList.length > 2,
                );
              }
            },
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
