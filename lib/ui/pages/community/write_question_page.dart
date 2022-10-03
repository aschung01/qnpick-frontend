import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/community_write_controller.dart';
import 'package:qnpick/core/controllers/main_home_controller.dart';
import 'package:qnpick/core/controllers/store_controller.dart';
import 'package:qnpick/helpers/transformers.dart';
import 'package:qnpick/ui/widgets/custom_bottom_sheets.dart';
import 'package:qnpick/ui/widgets/buttons.dart';
import 'package:qnpick/ui/widgets/custom_snackbar.dart';
import 'package:qnpick/ui/widgets/header.dart';
import 'package:qnpick/ui/widgets/input_fields.dart';
import 'package:qnpick/ui/widgets/svg_icons.dart';
import 'package:qnpick/ui/widgets/video_player_container.dart';
import 'package:video_player/video_player.dart';

class WriteQuestionPage extends GetView<CommunityWriteController> {
  const WriteQuestionPage({Key? key}) : super(key: key);

  void _onBackPressed() {
    Get.back();
    controller.reset();
  }

  void _onSubmitPressed() async {
    if (StoreController.to.pointStatus.isEmpty) {
      await StoreController.to.getPointStatus();
    }

    if (controller.type == 0) {
      if (controller.point * controller.closureRequirement.value + 200 >
          StoreController.to.pointStatus['count_points']) {
        Get.showSnackbar(ErrorSnackbar(
            text:
                '보유 포인트가 부족합니다 (${AuthController.to.userInfo['points']} QP 보유)'));
        return;
      }
    } else {
      if (200 > StoreController.to.pointStatus['count_points']) {
        Get.showSnackbar(ErrorSnackbar(
            text:
                '보유 포인트가 부족합니다 (${AuthController.to.userInfo['points']} QP 보유)'));
        return;
      }
    }
    bool success = await controller.postQuestion();
    Get.until((route) => Get.currentRoute == '/home');
    if (success) {
      if (controller.type == 0) {
        Get.showSnackbar(PointSnackbar(
            text:
                '- ${controller.point * controller.closureRequirement.value + 200} QP'));
      } else {
        Get.showSnackbar(PointSnackbar(text: '- 200 QP'));
      }
      MainHomeController.to.getHomeQuestionPreview();
      controller.reset();
    }
  }

  void _onAddMediaPressed() {
    getAddMediaBottomSheet(
      onCompleteDrawPressed: controller.onDrawComplete,
      onPickImagePressed: () {
        controller.pickImageFile();
        Get.back();
      },
      onPickVideoPressed: () async {
        await controller.pickVideoFile();
        Get.back();
      },
    );
  }

  void _onAddOptionMediaPressed(int index) {
    getAddMediaBottomSheet(
      onCompleteDrawPressed: (File file) {
        controller.onOptionDrawComplete(index, file);
      },
      onPickImagePressed: () {
        controller.pickOptionImageFile(index);
        Get.back();
      },
      onPickVideoPressed: () async {
        await controller.pickOptionVideoFile(index);
        Get.back();
      },
    );
  }

  void _onRemoveMediaPressed() {
    controller.removeMediaFile();
  }

  void _onAddOptionPressed() {
    controller.addOption();
  }

  void _onSelectDueDatePressed() async {
    DateTime? _pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: controller.dueDateTime.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),

      helpText: '마감 일자 선택',
      cancelText: '취소',
      confirmText: '완료',
      // selectableDayPredicate: _disableDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: brightPrimaryColor, // header background color
              onPrimary: darkPrimaryColor, // header text color
              onSurface: darkPrimaryColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: brightSecondaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    TimeOfDay? _pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: const TimeOfDay(hour: 24, minute: 0),
      helpText: '마감 시간 선택',
      cancelText: '취소',
      confirmText: '완료',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: brightPrimaryColor, // header background color
              onPrimary: darkPrimaryColor, // header text color
              onSurface: darkPrimaryColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: brightSecondaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (_pickedDate != null &&
        _pickedTime != null &&
        !(_pickedDate.year == controller.dueDateTime.value?.year &&
            _pickedDate.month == controller.dueDateTime.value?.month &&
            _pickedDate.day == controller.dueDateTime.value?.day &&
            _pickedTime.hour == controller.dueDateTime.value?.hour)) {
      controller.dueDateTime.value = DateTime(
          _pickedDate.year,
          _pickedDate.month,
          _pickedDate.day,
          _pickedTime.hour,
          _pickedTime.minute);
    }
  }

  void _onPointInfoPressed() {
    Get.dialog(
      Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                  'QP포인트',
                  style: TextStyle(
                    color: darkPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Text(
                'QP포인트란 질문 작성시 정해진 포인트가 사용되며 답변채택시 설정한 QP포인트가 답변자에게 지급되고 채택자에게 설정한 포인트가 적립됩니다.',
                style: TextStyle(
                  color: darkPrimaryColor,
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextActionButton(
                  buttonText: '확인',
                  fontWeight: FontWeight.bold,
                  textColor: brightPrimaryColor,
                  onPressed: () {
                    Get.back();
                  },
                  isUnderlined: false,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
      BuildContext context, int index, Animation<double> animation) {
    return OptionInputField(
      animation: animation,
      onChanged: (p0) {
        controller.update();
      },
      index: index + 1,
      controller: controller.optionList[index],
      onDeletePressed: () => controller.deleteOption(index),
      onAddMediaPressed: () => _onAddOptionMediaPressed(index),
      onRemoveMediaPressed: () => controller.removeOptionMediaFile(index),
      mediaFile: controller.optionMediaFileList[index][0] != null
          ? File(controller.optionMediaFileList[index][0]!.path)
          : null,
      mediaType: controller.optionMediaFileList[index][0] != null
          ? controller.optionMediaFileList[index][1]
          : null,
      videoPlayerController: controller.optionVideoPlayerControllerMap[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      AuthController.to.getUserInfoIfEmpty();
    });

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Header(
                onPressed: _onBackPressed,
                title: '질문 작성',
                actions: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 5, top: 10, bottom: 10),
                    child: GetBuilder<CommunityWriteController>(
                      builder: (_) {
                        bool _isSubmitActivated = _
                                .titleTextController.text.isNotEmpty &&
                            _.contentTextController.text.isNotEmpty &&
                            (_.type == 0
                                ? _.options
                                    .every((option) => option.text.isNotEmpty)
                                : true) &&
                            _.category.value >= 0;

                        return TextActionButton(
                          buttonText: '등록',
                          onPressed: _onSubmitPressed,
                          isUnderlined: false,
                          textColor: brightPrimaryColor,
                          fontWeight: FontWeight.bold,
                          activated: _isSubmitActivated,
                        );
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: GetBuilder<CommunityWriteController>(
                  builder: (_) {
                    return ListView(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.only(
                          top: 0, left: 30, right: 30, bottom: 40),
                      children: [
                        TitleInputField(
                          onChanged: (p0) {
                            controller.update();
                          },
                          controller: controller.titleTextController,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ContentInputField(
                            onChanged: (p0) {
                              controller.update();
                            },
                            controller: controller.contentTextController,
                          ),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                right: 20,
                              ),
                              child: Text(
                                '사진/동영상 첨부',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: darkPrimaryColor,
                                ),
                              ),
                            ),
                            _.mediaFile == null
                                ? IconButton(
                                    onPressed: _onAddMediaPressed,
                                    splashRadius: 20,
                                    icon: const MediaIcon(),
                                  )
                                : IconButton(
                                    onPressed: _onRemoveMediaPressed,
                                    splashRadius: 20,
                                    icon: const Icon(
                                      PhosphorIcons.trash,
                                      color: darkPrimaryColor,
                                    ),
                                  ),
                          ],
                        ),
                        if (_.mediaFile != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child:
                                GetX<CommunityWriteController>(builder: (__) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: __.mediaFileType.value == 0
                                      ? Image.file(
                                          File(_.mediaFile!.path),
                                          fit: BoxFit.scaleDown,
                                          width: context.width - 60,
                                          // height: 300,
                                        )
                                      : VideoPlayerContainer(
                                          width: context.width - 60,
                                          height: 200,
                                          controller: __.videoPlayerController!,
                                        ),
                                ),
                              );
                            }),
                          ),
                        if (_.type == 0)
                          const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              '선지 작성',
                              style: TextStyle(
                                fontSize: 14,
                                color: darkPrimaryColor,
                              ),
                            ),
                          ),
                        if (_.type == 0)
                          AnimatedList(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            key: _.optionListKey,
                            initialItemCount: _.optionList.length,
                            itemBuilder: _buildOption,
                          ),
                        if (_.type == 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: AddOptionButton(
                                  onPressed: _onAddOptionPressed),
                            ),
                          ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: Text(
                            '태그',
                            style: TextStyle(
                              fontSize: 14,
                              color: darkPrimaryColor,
                            ),
                          ),
                        ),
                        TagInputField(
                          controller: controller.tagsController,
                          onChanged: (txt) {
                            if (txt.isNotEmpty) {
                              if (txt[txt.length - 1] == ' ') {
                                List<String> _tagsList = txt.split(' ');
                                String _newStr = '';
                                for (int i = 0; i < _tagsList.length - 1; i++) {
                                  if (_tagsList[i].isNotEmpty) {
                                    if (!_tagsList[i].contains('#')) {
                                      _tagsList[i] = '#${_tagsList[i]}';
                                    }
                                    _newStr += '${_tagsList[i]} ';
                                  }
                                }
                                controller.tagsController.text = _newStr;
                                controller.tagsController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: controller
                                            .tagsController.text.length));
                              }
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            children: [
                              const Text(
                                '질문 카테고리',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: darkPrimaryColor,
                                ),
                              ),
                              GetX<CommunityWriteController>(builder: (_) {
                                return AnimatedRotation(
                                  duration: const Duration(milliseconds: 300),
                                  turns: _.seeCategory.value ? 0 : 0.5,
                                  child: IconButton(
                                      splashRadius: 20,
                                      onPressed: () {
                                        _.seeCategory.value =
                                            !_.seeCategory.value;
                                      },
                                      icon: const Icon(
                                        PhosphorIcons.caretUp,
                                        color: darkPrimaryColor,
                                      )),
                                );
                              }),
                            ],
                          ),
                        ),
                        GetX<CommunityWriteController>(builder: (__) {
                          if (__.seeCategory.value) {
                            return Wrap(
                              spacing: 5,
                              runSpacing: 10,
                              children: List.generate(
                                questionCategoryIntToStr.length,
                                (index) {
                                  bool _activated = _.category.value == index;
                                  return ChoiceChip(
                                    onSelected: (bool sel) {
                                      if (sel) {
                                        _.category.value = index;
                                      }
                                      _.update();
                                    },
                                    selected: _activated,
                                    backgroundColor: Colors.white,
                                    selectedColor: brightPrimaryColor,
                                    disabledColor: Colors.white,
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
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            children: [
                              const Text(
                                '채택 답변자들에게 줄 포인트',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: darkPrimaryColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: GetX<CommunityWriteController>(
                                  builder: (_) {
                                    return Text(
                                      '${_.point.value} QP',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: brightPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_.type == 0)
                          GetX<CommunityWriteController>(builder: (_) {
                            return SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 1,
                                inactiveTrackColor: lightGrayColor,
                                activeTrackColor: brightPrimaryColor,
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 8),
                                overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 16),
                                overlayColor:
                                    brightPrimaryColor.withOpacity(0.2),
                              ),
                              child: Slider(
                                value: _.point.value.toDouble(),
                                onChanged: (double val) {
                                  _.point.value = val.toInt();
                                },
                                min: 10,
                                max: 10000,
                                divisions: 999,
                                thumbColor: brightPrimaryColor,
                              ),
                            );
                          }),
                        if (_.type == 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                '10 QP',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: lightGrayColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '10,000 QP',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: lightGrayColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        if (_.type == 1)
                          GetX<CommunityWriteController>(builder: (_) {
                            return SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 1,
                                inactiveTrackColor: lightGrayColor,
                                activeTrackColor: brightPrimaryColor,
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 8),
                                overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 16),
                                overlayColor:
                                    brightPrimaryColor.withOpacity(0.2),
                              ),
                              child: Slider(
                                value: _.point.value.toDouble(),
                                onChanged: (double val) {
                                  _.point.value = val.toInt();
                                },
                                min: 100,
                                max: 10000,
                                divisions: 99,
                                thumbColor: brightPrimaryColor,
                              ),
                            );
                          }),
                        if (_.type == 1)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                '100 QP',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: lightGrayColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '10,000 QP',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: lightGrayColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        if (_.type == 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Row(
                              children: [
                                const Text(
                                  '질문 마감을 위한 답변자 수',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: darkPrimaryColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: GetX<CommunityWriteController>(
                                    builder: (_) {
                                      return Text(
                                        '${_.closureRequirement.value} 명',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: brightPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (_.type == 0)
                          GetX<CommunityWriteController>(builder: (_) {
                            return SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 1,
                                inactiveTrackColor: lightGrayColor,
                                activeTrackColor: brightPrimaryColor,
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 8),
                                overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 16),
                                overlayColor:
                                    brightPrimaryColor.withOpacity(0.2),
                              ),
                              child: Slider(
                                value: _.closureRequirement.value.toDouble(),
                                onChanged: (double val) {
                                  _.closureRequirement.value = val.toInt();
                                },
                                min: 10,
                                max: 1000,
                                // divisions: 99,
                                thumbColor: brightPrimaryColor,
                              ),
                            );
                          }),
                        if (_.type == 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                '10 명',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: lightGrayColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '1,000 명',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: lightGrayColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        if (_.type == 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Row(
                              children: [
                                const Text(
                                  '질문 등록 시 소모되는 포인트',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: darkPrimaryColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: GetX<CommunityWriteController>(
                                    builder: (_) {
                                      return Text(
                                        '${200 + _.closureRequirement.value * _.point.value} QP',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: brightPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (_.type == 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Row(
                              children: [
                                const Text(
                                  '마감 일자',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: darkPrimaryColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _onSelectDueDatePressed,
                                  splashRadius: 20,
                                  icon: const CalendarIcon(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: GetX<CommunityWriteController>(
                                    builder: (_) {
                                      if (_.dueDateTime.value == null) {
                                        return const SizedBox.shrink();
                                      } else {
                                        return Text(
                                          DateFormat('yyyy년 MM월 dd일 H:mm')
                                              .format(_.dueDateTime.value!),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: brightPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(
                            child: TextActionButton(
                              width: 160,
                              buttonText: 'QP 시스템 알아보기',
                              onPressed: _onPointInfoPressed,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddOptionButton extends StatelessWidget {
  final Function() onPressed;
  const AddOptionButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 36,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add_rounded,
              color: darkPrimaryColor,
            ),
            Text(
              '선지 추가',
              style: TextStyle(
                fontSize: 14,
                color: darkPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
