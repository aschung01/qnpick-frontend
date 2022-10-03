import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/community_controller.dart';
import 'package:qnpick/core/controllers/community_write_controller.dart';
import 'package:qnpick/helpers/transformers.dart';
import 'package:qnpick/ui/widgets/custom_bottom_sheets.dart';
import 'package:qnpick/ui/widgets/buttons.dart';
import 'package:qnpick/ui/widgets/custom_snackbar.dart';
import 'package:qnpick/ui/widgets/header.dart';
import 'package:qnpick/ui/widgets/image_loader.dart';
import 'package:qnpick/ui/widgets/input_fields.dart';
import 'package:qnpick/ui/widgets/svg_icons.dart';
import 'package:qnpick/ui/widgets/video_player_container.dart';

class EditQuestionPage extends GetView<CommunityWriteController> {
  const EditQuestionPage({Key? key}) : super(key: key);

  void _onBackPressed() {
    Get.back();
    Future.delayed(const Duration(milliseconds: 300), () {
      controller.reset();
    });
  }

  void _onSubmitPressed() async {
    if (controller.titleTextController.text.isNotEmpty &&
        controller.contentTextController.text.isNotEmpty &&
        (controller.type == 0
            ? controller.options.every((option) => option.text.isNotEmpty)
            : true) &&
        controller.category.value >= 0) {
      bool success = await controller
          .updateQuestion(CommunityController.to.questionData['id']);
      if (success) {
        Get.back();
        CommunityController.to
            .questionPageInit(CommunityController.to.questionData['id']);
        Future.delayed(const Duration(milliseconds: 300), () {
          controller.reset();
        });
      }
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
    if (controller.mediaKey.value == null) {
      controller.removeMediaFile();
    } else {
      CommunityController.to.questionData['delete_media'] = true;
    }
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
    print(_pickedTime);
    print(controller.dueDateTime.value);

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

  void _onPointInfoPressed() {}

  Widget _buildOption(
      BuildContext context, int index, Animation<double> animation) {
    if (controller.optionMediaFileList.length > index &&
        controller.optionMediaKeyList.length > index) {
      return GetBuilder<CommunityController>(builder: (_) {
        return OptionInputField(
          animation: animation,
          onChanged: (p0) {
            controller.update();
          },
          index: index + 1,
          controller: controller.optionList[index],
          onDeletePressed: () => controller.deleteOption(index),
          onAddMediaPressed: () => _onAddOptionMediaPressed(index),
          onRemoveMediaPressed: () {
            if (controller.optionMediaKeyList[index] != null) {
              _.questionData['options'][index]['delete_media'] = true;
              _.update();
            } else {
              controller.removeOptionMediaFile(index);
            }
          },
          mediaFile: controller.optionMediaFileList[index][0] != null
              ? File(controller.optionMediaFileList[index][0]!.path)
              : null,
          mediaType: (controller.optionMediaFileList[index][0] != null ||
                  controller.optionMediaKeyList[index] != null)
              ? controller.optionMediaFileList[index][1]
              : null,
          mediaKey: () {
            if (index + 1 <= _.questionData['options'].length) {
              return CommunityController.to.questionData['options'][index]
                          ['delete_media'] ==
                      true
                  ? null
                  : controller.optionMediaKeyList[index];
            } else {
              return null;
            }
          }(),
          videoPlayerController:
              controller.optionVideoPlayerControllerMap[index],
        );
      });
    } else {
      return const SizedBox.shrink();
    }
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
                title: '질문 수정',
                actions: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 5, top: 10, bottom: 10),
                    child: TextActionButton(
                      buttonText: '완료',
                      onPressed: _onSubmitPressed,
                      isUnderlined: false,
                      textColor: brightPrimaryColor,
                      fontWeight: FontWeight.bold,
                      activated: true,
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
                            GetBuilder<CommunityWriteController>(
                              builder: (_) {
                                if (_.mediaFile == null &&
                                    (_.mediaKey.value == null ||
                                        CommunityController.to
                                                .questionData['delete_media'] ==
                                            true)) {
                                  return IconButton(
                                    onPressed: _onAddMediaPressed,
                                    splashRadius: 20,
                                    icon: const MediaIcon(),
                                  );
                                } else {
                                  return IconButton(
                                    onPressed: _onRemoveMediaPressed,
                                    splashRadius: 20,
                                    icon: const Icon(
                                      PhosphorIcons.trash,
                                      color: darkPrimaryColor,
                                    ),
                                  );
                                }
                              },
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GetX<CommunityWriteController>(builder: (__) {
                            if (_.mediaKey.value != null &&
                                CommunityController
                                        .to.questionData['delete_media'] !=
                                    true) {
                              return ImageLoader(
                                  mediaKey: __.mediaKey.value!,
                                  mediaType: __.mediaFileType.value);
                            } else {
                              return const SizedBox.shrink();
                            }
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
                        const Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 10),
                          child: Text(
                            '질문 카테고리',
                            style: TextStyle(
                              fontSize: 14,
                              color: darkPrimaryColor,
                            ),
                          ),
                        ),
                        GetX<CommunityWriteController>(builder: (__) {
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
                                      : const BorderSide(color: deepGrayColor),
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
                          GetX<CommunityWriteController>(
                            builder: (_) {
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
                                    if (!Get.isSnackbarOpen) {
                                      Get.showSnackbar(BottomSnackbar(
                                          text: '수정이 불가능한 정보입니다'));
                                    }
                                  },
                                  min: 10,
                                  max: 10000,
                                  divisions: 999,
                                  thumbColor: brightPrimaryColor,
                                ),
                              );
                            },
                          ),
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
                          GetX<CommunityWriteController>(
                            builder: (_) {
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
                                    if (!Get.isSnackbarOpen) {
                                      Get.showSnackbar(BottomSnackbar(
                                          text: '수정이 불가능한 정보입니다'));
                                    }
                                  },
                                  min: 100,
                                  max: 10000,
                                  divisions: 99,
                                  thumbColor: brightPrimaryColor,
                                ),
                              );
                            },
                          ),
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
                                  if (!Get.isSnackbarOpen) {
                                    Get.showSnackbar(
                                        BottomSnackbar(text: '수정이 불가능한 정보입니다'));
                                  }
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
                                '1000 명',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: lightGrayColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        if (_.type == 0)
                          const Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                              '포인트 지급과 관련된 정보는 수정할 수 없습니다',
                              style: TextStyle(
                                fontSize: 14,
                                color: darkPrimaryColor,
                              ),
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
