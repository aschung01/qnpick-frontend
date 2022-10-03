import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/community_controller.dart';
import 'package:qnpick/core/controllers/community_write_controller.dart';
import 'package:qnpick/core/controllers/main_home_controller.dart';
import 'package:qnpick/helpers/transformers.dart';
import 'package:qnpick/helpers/utils.dart';
import 'package:qnpick/ui/widgets/custom_bottom_sheets.dart';
import 'package:qnpick/ui/widgets/buttons.dart';
import 'package:qnpick/ui/widgets/custom_snackbar.dart';
import 'package:qnpick/ui/widgets/header.dart';
import 'package:qnpick/ui/widgets/image_loader.dart';
import 'package:qnpick/ui/widgets/input_fields.dart';
import 'package:qnpick/ui/widgets/loading_blocks.dart';

class QuestionPage extends GetView<CommunityController> {
  const QuestionPage({Key? key}) : super(key: key);

  void _onBackPressed() {
    Get.back();
    Future.delayed(const Duration(milliseconds: 500), () {
      controller.resetQuestionPage();
    });
  }

  void _onDeletePressed(int id, String instance) async {
    await controller.delete(id, instance);
    controller.focusedComment.value = -1;
    controller.focusedReply.value = -1;
    if (instance == 'question') {
      Get.back(closeOverlays: true);
      if (Get.currentRoute == '/community/question_list') {
        if (controller.mediaType.value == 0) {
          controller.textQuestionList
              .removeWhere((element) => element['question_data']['id'] == id);
        } else if (controller.mediaType.value == 1) {
          controller.imageQuestionList
              .removeWhere((element) => element['question_data']['id'] == id);
        } else {
          controller.videoQuestionList
              .removeWhere((element) => element['question_data']['id'] == id);
        }
      } else {
        MainHomeController.to.getHomeQuestionPreview();
      }
    } else if (instance == 'comment_answer' || instance == 'comment_reply') {
      Get.back();
      controller.getQuestionCount(controller.questionData['id']);
      controller.getCommentAnswers(controller.questionData['id']);
    }
  }

  void _onEditPressed(int id, String instance) {
    Get.back();
    if (instance == 'question') {
      Get.toNamed('/edit_question');
      CommunityWriteController.to.titleTextController.text =
          controller.questionData['title'];
      CommunityWriteController.to.contentTextController.text =
          controller.questionData['content'];
      CommunityWriteController.to.type = controller.questionData['type'];
      CommunityWriteController.to.category.value =
          controller.questionData['category'];
      CommunityWriteController.to.mediaKey.value =
          controller.questionData['media_key'];
      CommunityWriteController.to.mediaFileType.value =
          controller.questionData['media_type'] ?? 0;

      if (CommunityWriteController.to.type == 0) {
        Future.delayed(const Duration(milliseconds: 100), () {
          CommunityWriteController.to.options.clear();
          CommunityWriteController.to.optionMediaFileList.clear();
          CommunityWriteController.to.optionMediaKeyList.clear();
          for (int i = 0;
              i < CommunityWriteController.to.optionList.length;
              i++) {
            CommunityWriteController.to.optionList.removeAt(i);
          }
          controller.questionData['options'].forEach((option) {
            CommunityWriteController.to.options
                .add(TextEditingController(text: option['content']));
            CommunityWriteController.to.optionList
                .insert(CommunityWriteController.to.options.last);
            CommunityWriteController.to.optionMediaKeyList
                .add(option['media_key']);
            CommunityWriteController.to.optionMediaFileList
                .add([null, option['media_type']]);
          });
          CommunityWriteController.to.optionList.removeAt(0);
        });
      }

      Future.delayed(Duration.zero, () {
        if (controller.questionData['tags'] != null) {
          getListFromStr(controller.questionData['tags']).forEach((tag) {
            CommunityWriteController.to.initialTags.add(tag);
          });
        }
      });
      CommunityWriteController.to.update();
    } else if (instance == 'comment_answer') {
      controller.commentTextController.text =
          controller.comments[controller.focusedComment.value]['content'];
      controller.commentFocusNode.requestFocus();
    } else if (instance == 'comment_reply') {
      controller.commentTextController.text =
          controller.comments[controller.focusedComment.value]['replies']
              [controller.focusedReply.value]['content'];
      controller.commentFocusNode.requestFocus();
    }
  }

  void _onBlockPressed(String username, String instance) async {
    var success = await controller.blockUser(username);
    if (success) {
      Get.showSnackbar(BottomSnackbar(text: '사용자 차단이 완료되었습니다'));
      if (instance == 'question') {
        Get.until((route) => Get.currentRoute == '/home');
        MainHomeController.to.getHomeQuestionPreview();
      } else {
        Get.back();
        controller.getQuestionCount(controller.questionData['id']);
        controller.getCommentAnswers(controller.questionData['id']);
      }
    } else {
      Get.showSnackbar(BottomSnackbar(text: '오류가 발생했습니다'));
    }
  }

  void _onUserReportPressed(String username) async {
    var success = await controller.reportUser(username);
    if (success) {
      Get.back();
      Get.showSnackbar(BottomSnackbar(text: '사용자 신고가 완료되었습니다'));
    } else {
      Get.back();
      Get.showSnackbar(BottomSnackbar(text: '이미 신고한 사용자입니다'));
    }
  }

  void _onReportPressed(int id, String username, String instance) async {
    Get.back();
    getReportBottomSheet(
      onReportPressed: () => _onReport(id, username, instance),
      reportCategoryList: controller.reportCategoryList,
    );
  }

  void _onReport(int id, String username, String instance) async {
    var success = await controller.report(
        id, instance, controller.reportCategoryList.toList());
    if (success) {
      Get.back();
      Get.showSnackbar(BottomSnackbar(
          text:
              '${instance == 'question' ? '질문 ' : (instance == 'comment_answer' ? '댓글 ' : '대댓글 ')}신고가 완료되었습니다'));
      getBlockUserBottomSheet(
        username: username,
        onBlockPressed: () => _onBlockPressed(username, instance),
        onReportPressed: () => _onUserReportPressed(username),
        onBackPressed: () {
          Get.back();
        },
      );
    } else {
      Get.back();
      late String messageText;
      if (instance == 'question') {
        messageText = '이미 신고한 질문입니다';
      } else {
        messageText = '이미 신고한 댓글입니다';
      }
      Get.showSnackbar(BottomSnackbar(text: messageText));
    }
    controller.focusedComment.value = -1;
    controller.focusedReply.value = -1;
  }

  void _onReplyPressed(int id, String username) async {
    Get.back();
    controller.replyMode.value = true;
    controller.commentFocusNode.requestFocus();
  }

  void _onMenuPressed(
      bool isSelf, bool? hasAnswers, int id, String username, String instance,
      {int? replyIndex, int? commentId}) {
    if (!controller.loading.value) {
      if (instance == 'question') {
        getQuestionOptionsBottomSheet(
          isSelf: isSelf,
          hasAnswers: hasAnswers!,
          onUpdatePressed: () => _onEditPressed(id, instance),
          onEndPressed: () {},
          onDeletePressed: () => _onDeletePressed(id, instance),
          onReportPressed: () => _onReportPressed(id, username, instance),
        );
      } else {
        if (replyIndex != null) {
          controller.focusedComment.value = controller.comments
              .indexWhere((comment) => comment['id'] == commentId);
          controller.focusedReply.value = replyIndex;
        } else {
          controller.focusedComment.value =
              controller.comments.indexWhere((comment) => comment['id'] == id);
        }
        getCommentAnswerOptionsBottomSheet(
            isSelf: isSelf,
            onUpdatePressed: () => _onEditPressed(id, instance),
            onDeletePressed: () => _onDeletePressed(id, instance),
            onReportPressed: () => _onReportPressed(id, username, instance),
            onReplyPressed: instance == 'comment_answer'
                ? () => _onReplyPressed(id, username)
                : null,
            onBackPressed: () {
              controller.focusedComment.value = -1;
              controller.focusedReply.value = -1;
            });
      }
    }
  }

  void _onOptionBlockTap(int index) {
    if (controller.selectedOption.value == index) {
      controller.selectedOption.value = -1;
    } else {
      controller.selectedOption.value = index;
    }
  }

  void _onOptionSelectCompletePressed() {
    if (AuthController.to.isAuthenticated.value) {
      controller.postOptionAnswer();
    } else {
      Get.toNamed('/auth');
    }
  }

  void _onCommentAddMediaPressed() {
    getAddMediaBottomSheet(
      onCompleteDrawPressed: controller.onCommentDrawComplete,
      onPickImagePressed: () {
        Get.back();
        controller.pickCommentImageFile();
      },
      onPickVideoPressed: () {
        Get.back();
        controller.pickCommentVideoFile();
      },
    );
  }

  void _onCommentRemoveMediaPressed() {
    if (controller.focusedComment >= 0) {
      controller.comments[controller.focusedComment.value]['delete_media'] =
          true;
      controller.update();
    } else {
      controller.removeCommentMediaFile();
    }
  }

  void _onCompleteSelectCommentsPressed() async {
    await controller.postCommentSelection();
    controller.getCommentAnswers(controller.questionData['id']);
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      await AuthController.to.getUserInfoIfEmpty();
    });

    void _onCommentSendPressed() {
      if (AuthController.to.isAuthenticated.value) {
        if (controller.replyMode.value) {
          controller.postReply();
          controller.replyMode.value = false;
        } else {
          controller.postComment();
        }
      } else {
        Get.toNamed('/auth');
      }
      FocusScope.of(context).unfocus();
    }

    void _onCommentUpdatePressed() async {
      if (controller.focusedReply >= 0) {
        await controller.updateReply();
      } else {
        await controller.updateComment();
      }
      controller.commentFocusNode.unfocus();
      controller.focusedComment.value = -1;
      controller.focusedReply.value = -1;
    }

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus!.unfocus();
              if (controller.focusedComment.value >= 0) {
                controller.comments[controller.focusedComment.value]
                    .remove('delete_media');
              }
              if (controller.replyMode.value) {
                controller.replyMode.value = false;
                controller.commentTextController.clear();
              }
            }
            controller.focusedComment.value = -1;
            controller.focusedReply.value = -1;
          },
          child: Column(
            children: [
              GetX<CommunityController>(
                builder: (_) {
                  return Header(
                    onPressed: _onBackPressed,
                    title: questionCategoryIntToStr[_.questionData['category']],
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.more_vert_rounded,
                          color: darkPrimaryColor,
                        ),
                        splashRadius: 20,
                        onPressed: () => _onMenuPressed(
                          _.questionData['username'] ==
                              AuthController.to.userInfo['username'],
                          _.questionData['type'] == 0
                              ? _.optionCountData.any((count) => count > 0)
                              : _.comments.isNotEmpty,
                          _.questionData['id'],
                          _.questionData['username'],
                          'question',
                        ),
                      ),
                    ],
                  );
                },
              ),
              Expanded(
                child: GetX<CommunityController>(
                  builder: (_) {
                    if (_.loading.value) {
                      return const LoadingBlock();
                    } else {
                      return ListView(
                        padding: const EdgeInsets.only(top: 5, bottom: 20),
                        physics: const ClampingScrollPhysics(),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 6),
                            child: Text(
                              _.questionData['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: darkPrimaryColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text.rich(
                              TextSpan(
                                text:
                                    '${'${formatDateTimeRawString(_.questionData['created_at'])} • ' + _.questionData['username']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: lightGrayColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: () {
                                      if (_.questionData['type'] == 0) {
                                        if (_.questionCountData['closed'] ==
                                            true) {
                                          return ' • 마감됨';
                                        } else {
                                          return ' • 진행률 ${formatPercentage(_.questionCountData['progress'])}${_.questionData['due_date'] != null ? ' • ${formatDateTimeRawString(_.questionData['due_date'])} 마감' : ''}';
                                        }
                                      }
                                    }(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: brightSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20,
                                left: 30,
                                right: 30,
                                bottom: _.questionData['media_key'] != null
                                    ? 20
                                    : 35),
                            child: Text(
                              _.questionData['content'],
                              style: const TextStyle(
                                fontSize: 15,
                                color: darkPrimaryColor,
                              ),
                            ),
                          ),
                          if (_.questionData['media_key'] != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: ImageLoader(
                                mediaKey: _.questionData['media_key'],
                                mediaType: _.questionData['media_type'],
                                height: null,
                                width: context.width,
                                imageType: ImageType.whole,
                                background: _.questionData['media_type'] == 0
                                    ? Colors.transparent
                                    : Colors.black,
                              ),
                            ),
                          if (_.questionData['type'] == 0)
                            for (int i = 0;
                                i < _.questionData['options'].length * 2 - 1;
                                i++)
                              i % 2 == 0
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: OptionBlock(
                                        data: _.questionData['options'][i ~/ 2],
                                        onTap: _.optionCountData.isNotEmpty
                                            ? null
                                            : () => _onOptionBlockTap(i ~/ 2),
                                        selected:
                                            _.selectedOption.value == (i ~/ 2),
                                        count: _.optionCountData.isNotEmpty
                                            ? _.optionCountData[i ~/ 2]
                                            : null,
                                        closureRequirement:
                                            _.optionCountData.isNotEmpty
                                                ? _.questionData[
                                                    'closure_requirement']
                                                : null,
                                        isMax: _.optionCountData.isNotEmpty
                                            ? (_.optionCountData.reduce(
                                                    (curr, next) => curr > next
                                                        ? curr
                                                        : next) ==
                                                _.optionCountData[i ~/ 2])
                                            : null,
                                      ),
                                    )
                                  : const SizedBox(height: 10),
                          if (_.questionData['tags'] != null)
                            Padding(
                              padding: EdgeInsets.only(
                                  top: _.questionData['type'] == 0 ? 30 : 20,
                                  left: 30,
                                  right: 30,
                                  bottom: 20),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(
                                      PhosphorIcons.tag,
                                      size: 16,
                                      color: deepGrayColor,
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 6,
                                    children: List.generate(
                                      getListFromStr(_.questionData['tags'])
                                          .length,
                                      (index) {
                                        return Text(
                                          getListFromStr(
                                              _.questionData['tags'])[index],
                                          style: const TextStyle(
                                            color: deepGrayColor,
                                            fontSize: 15,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (_.questionData['type'] == 1)
                            const Divider(
                              height: 10,
                              thickness: 10,
                              color: backgroundColor,
                            ),
                          if (_.questionData['type'] == 1)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 25, bottom: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        '댓글',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: darkPrimaryColor,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Text(
                                          _.comments.length.toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: brightPrimaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_.questionData['type'] == 1 &&
                                      _.questionCountData['closed'] == false)
                                    _.commentSelectMode.value
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            child: Row(
                                              children: [
                                                TextActionButton(
                                                  buttonText: '취소',
                                                  onPressed: () {
                                                    _.commentSelectMode.value =
                                                        false;
                                                    _.selectedComments.clear();
                                                  },
                                                  isUnderlined: false,
                                                  textColor: lightGrayColor,
                                                  overlayColor: lightGrayColor
                                                      .withOpacity(0.2),
                                                ),
                                                const SizedBox(width: 10),
                                                TextActionButton(
                                                  buttonText: '완료',
                                                  onPressed:
                                                      _onCompleteSelectCommentsPressed,
                                                  isUnderlined: false,
                                                  textColor:
                                                      brightSecondaryColor,
                                                  overlayColor:
                                                      brightSecondaryColor
                                                          .withOpacity(0.2),
                                                ),
                                              ],
                                            ),
                                          )
                                        : AuthController
                                                    .to.userInfo['username'] ==
                                                _.questionData['username']
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15),
                                                child: TextActionButton(
                                                  buttonText: '댓글 채택하기 >',
                                                  onPressed: () {
                                                    _.commentSelectMode.value =
                                                        true;
                                                  },
                                                  isUnderlined: false,
                                                  textColor:
                                                      brightSecondaryColor,
                                                  overlayColor:
                                                      brightSecondaryColor
                                                          .withOpacity(0.2),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          if (_.questionData['type'] == 1)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 0),
                              child: Column(
                                children: List.generate(
                                  _.comments.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: CommentBlock(
                                      focused: index == _.focusedComment.value,
                                      focusedReply: _.focusedReply.value,
                                      selected:
                                          _.selectedComments.contains(index),
                                      isAuthor: AuthController
                                              .to.userInfo['username'] ==
                                          _.questionData['username'],
                                      onSelect: (_.questionData['type'] == 1 &&
                                              _.questionCountData['closed'] ==
                                                  false &&
                                              _.commentSelectMode.value)
                                          ? () {
                                              if (_.selectedComments
                                                  .contains(index)) {
                                                _.selectedComments
                                                    .remove(index);
                                              } else {
                                                _.selectedComments.add(index);
                                              }
                                            }
                                          : null,
                                      onMenuPressed: () => _onMenuPressed(
                                        _.comments[index]['username'] ==
                                            AuthController
                                                .to.userInfo['username'],
                                        null,
                                        _.comments[index]['id'],
                                        _.comments[index]['username'],
                                        'comment_answer',
                                      ),
                                      onReplyMenuPressed: (bool isSelf,
                                              int id,
                                              String username,
                                              int replyIndex,
                                              int commentId) =>
                                          _onMenuPressed(
                                        isSelf,
                                        null,
                                        id,
                                        username,
                                        'comment_reply',
                                        replyIndex: replyIndex,
                                        commentId: commentId,
                                      ),
                                      data: _.comments[index],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }
                  },
                ),
              ),
              GetX<CommunityController>(
                builder: (_) {
                  bool _showAnswerInput =
                      AuthController.to.userInfo['username'] !=
                          _.questionData['username'];

                  if (_.replyMode.value) {
                    return GetBuilder<CommunityController>(
                      builder: (_) {
                        return CommentInputTextField(
                          focusNode: _.commentFocusNode,
                          onSendPressed: _onCommentSendPressed,
                          controller: _.commentTextController,
                          width: context.width,
                        );
                      },
                    );
                  } else if (_.focusedReply >= 0) {
                    return GetBuilder<CommunityController>(builder: (_) {
                      return CommentInputTextField(
                        focusNode: _.commentFocusNode,
                        onSendPressed: _onCommentUpdatePressed,
                        controller: _.commentTextController,
                        width: context.width,
                      );
                    });
                  }

                  if (_showAnswerInput) {
                    if (_.questionData['type'] == 1) {
                      // if (_.comments.every((comment) =>
                      //         comment['username'] !=
                      //         AuthController.to.userInfo['username']) ||
                      //     _.focusedComment >= 0) {
                      return SizedBox(
                        child: GetBuilder<CommunityController>(builder: (_) {
                          return CommentInputTextField(
                            focusNode: _.commentFocusNode,
                            onSendPressed: _.focusedComment.value >= 0
                                ? _onCommentUpdatePressed
                                : _onCommentSendPressed,
                            controller: _.commentTextController,
                            width: context.width,
                            onAddMediaPressed: _onCommentAddMediaPressed,
                            onRemoveMediaPressed: _onCommentRemoveMediaPressed,
                            mediaFile: _.commentMediaFile != null
                                ? File(_.commentMediaFile!.path)
                                : null,
                            mediaKey: (_.focusedComment >= 0 &&
                                    _.comments[_.focusedComment.value]
                                            ['delete_media'] !=
                                        true)
                                ? _.comments[_.focusedComment.value]
                                    ['media_key']
                                : null,
                            mediaType: _.commentMediaFileType.value,
                            videoPlayerController: _.videoPlayerController,
                          );
                        }),
                      );
                      // }
                    } else if (_.selectedOption.value >= 0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 30),
                        child: ElevatedActionButton(
                          buttonText: '답변 제출',
                          width: 330,
                          height: 50,
                          backgroundColor: brightSecondaryColor,
                          overlayColor: brightSecondaryColor.withOpacity(0.2),
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          onPressed: _onOptionSelectCompletePressed,
                        ),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OptionBlock extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function()? onTap;
  final bool selected;
  final int? count;
  final int? closureRequirement;
  final bool? isMax;
  const OptionBlock({
    Key? key,
    required this.data,
    required this.onTap,
    this.selected = false,
    this.count,
    this.closureRequirement,
    this.isMax,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: data['media_key'] != null ? 242 : 42,
      width: context.width - 60,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: data['media_key'] != null ? 242 : 42,
            width: context.width - 60,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: selected
                        ? brightSecondaryColor.withOpacity(0.6)
                        : backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 42,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      count != null
                          ? Container(
                              decoration: BoxDecoration(
                                color: isMax!
                                    ? brightSecondaryColor.withOpacity(0.7)
                                    : brightPrimaryColor.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 42,
                              width: (context.width - 60) *
                                  count! /
                                  closureRequirement!,
                            )
                          : const SizedBox.shrink(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Text(
                              (data['num'] + 1).toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    selected ? Colors.white : darkPrimaryColor,
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          Text(
                            data['content'],
                            style: TextStyle(
                              fontSize: 15,
                              color: selected ? Colors.white : darkPrimaryColor,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                data['media_key'] != null
                    ? ImageLoader(
                        mediaKey: data['media_key'],
                        mediaType: data['media_type'],
                        background: backgroundColor,
                        imageType: ImageType.whole,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          if (count != null && closureRequirement != null)
            Positioned(
              right: 10,
              child: SizedBox(
                height: 42,
                child: Center(
                  child: Text(
                    '$count / $closureRequirement',
                    style: const TextStyle(
                      fontSize: 13,
                      color: darkPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(
            height: (data['media_key'] != null && data['media_type'] != 1)
                ? 242
                : 42,
            width: context.width - 60,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                highlightColor: brightSecondaryColor.withOpacity(0.2),
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentBlock extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool focused;
  final int focusedReply;
  final bool selected;
  final bool isAuthor;
  final Function()? onSelect;
  final Function() onMenuPressed;
  final Function(bool, int, String, int, int) onReplyMenuPressed;
  const CommentBlock({
    Key? key,
    required this.focused,
    required this.focusedReply,
    required this.selected,
    required this.isAuthor,
    required this.data,
    required this.onSelect,
    required this.onMenuPressed,
    required this.onReplyMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                // height: data['media_key'] != null ? 260 : null,
                constraints: BoxConstraints(
                    minHeight: data['media_key'] != null ? 260 : 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: () {
                    if (focusedReply < 0) {
                      if (focused) {
                        return brightPrimaryColor.withOpacity(0.3);
                      } else if (selected) {
                        return brightSecondaryColor.withOpacity(0.6);
                      } else {
                        return backgroundColor;
                      }
                    }
                  }(),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: isAuthor ? onSelect : null,
                    splashColor: brightSecondaryColor.withOpacity(0.2),
                    highlightColor: brightSecondaryColor.withOpacity(0.2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  data['content'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: darkPrimaryColor,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(width: 3),
                                  Text(
                                    '${formatDateTimeRawString(data['created_at'])}\n${data['username']}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: darkPrimaryColor.withOpacity(0.8),
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                  if (data['selected'] == true)
                                    // Column(
                                    //   children: [
                                    // Text(
                                    //   '채택됨',
                                    //   style: TextStyle(
                                    //     fontSize: 13,
                                    //     color: brightSecondaryColor,
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6),
                                      child: Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.only(right: 2),
                                            child: Icon(
                                              PhosphorIcons.circleWavyCheckFill,
                                              color: brightSecondaryColor,
                                              size: 20,
                                            ),
                                          ),
                                          Text(
                                            '채택',
                                            style: TextStyle(
                                              color: brightSecondaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  // ],
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        data['media_key'] != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ImageLoader(
                                  mediaKey: data['media_key'],
                                  mediaType: data['media_type'],
                                  background: backgroundColor,
                                  imageType: ImageType.whole,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: onMenuPressed,
              splashRadius: 20,
              icon: const Icon(
                Icons.more_vert_rounded,
              ),
            ),
          ],
        ),
        if (data['replies'] != null)
          ...List.generate(
            data['replies'].length,
            (index) {
              print(data['replies']);
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      // height: 50,
                      constraints: const BoxConstraints(minHeight: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: () {
                          if (focusedReply == index && focused) {
                            return brightPrimaryColor.withOpacity(0.3);
                          } else {
                            return backgroundColor;
                          }
                        }(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        PhosphorIcons.arrowBendDownRight,
                                        color: darkPrimaryColor,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        data['replies'][index]['content'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: darkPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const SizedBox(width: 3),
                                Text(
                                  '${formatDateTimeRawString(data['replies'][index]['created_at'])}\n' +
                                      data['replies'][index]['username'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: darkPrimaryColor.withOpacity(0.8),
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => onReplyMenuPressed(
                      data['replies'][index]['username'] ==
                          AuthController.to.userInfo['username'],
                      data['replies'][index]['id'],
                      data['replies'][index]['username'],
                      index,
                      data['id'],
                    ),
                    splashRadius: 20,
                    icon: const Icon(
                      Icons.more_vert_rounded,
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
