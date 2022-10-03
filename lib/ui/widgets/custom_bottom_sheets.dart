import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_template.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/ui/pages/draw_page.dart';
import 'package:qnpick/ui/widgets/buttons.dart';
import 'package:qnpick/ui/widgets/input_fields.dart';

class AddMediaBottomSheet extends StatelessWidget {
  final Function(File) onDrawCompletePressed;
  final Function() onPickImagePressed;
  final Function() onPickVideoPressed;
  const AddMediaBottomSheet({
    Key? key,
    required this.onDrawCompletePressed,
    required this.onPickImagePressed,
    required this.onPickVideoPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 20, bottom: 30, left: 25, right: 25),
      children: [
        SizeAccentTextButton(
          buttonText: '그리기',
          onTap: () {
            Get.back();
            Get.to(DrawPage(onCompletePressed: onDrawCompletePressed));
          },
        ),
        const Divider(color: lightGrayColor, height: 15),
        SizeAccentTextButton(
          buttonText: '사진 가져오기',
          onTap: onPickImagePressed,
        ),
        const Divider(color: lightGrayColor, height: 15),
        SizeAccentTextButton(
          buttonText: '동영상 가져오기',
          onTap: onPickVideoPressed,
        ),
      ],
    );
  }
}

class AddMapQuestionSheet extends StatelessWidget {
  final Function() onWriteOptionQuestionPressed;
  final Function() onWriteCommentQuestionPressed;
  final Function() onBackPressed;
  const AddMapQuestionSheet({
    Key? key,
    required this.onWriteOptionQuestionPressed,
    required this.onWriteCommentQuestionPressed,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 20, bottom: 30, left: 25, right: 25),
      children: [
        SizeAccentTextButton(
          buttonText: '선다형 질문 작성',
          textColor: brightPrimaryColor,
          onTap: onWriteOptionQuestionPressed,
        ),
        const Divider(color: lightGrayColor, height: 15),
        SizeAccentTextButton(
          buttonText: '댓글형 질문 작성',
          textColor: brightPrimaryColor,
          onTap: onWriteCommentQuestionPressed,
        ),
        const Divider(color: lightGrayColor, height: 15),
        SizeAccentTextButton(
          buttonText: '취소',
          onTap: onBackPressed,
        ),
      ],
    );
  }
}

class QuestionOptionsBottomSheet extends StatelessWidget {
  final bool isSelf;
  final bool hasAnswers;
  final Function() onUpdatePressed;
  final Function() onEndPressed;
  final Function() onDeletePressed;
  final Function() onReportPressed;
  const QuestionOptionsBottomSheet({
    Key? key,
    required this.isSelf,
    required this.hasAnswers,
    required this.onUpdatePressed,
    required this.onEndPressed,
    required this.onDeletePressed,
    required this.onReportPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isSelf) {
      if (!hasAnswers) {
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding:
              const EdgeInsets.only(top: 30, bottom: 30, left: 25, right: 25),
          children: [
            const Center(
              child: Text(
                '질문 옵션',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: darkPrimaryColor,
                ),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 15, bottom: 20, left: 20, right: 20),
              child: Text(
                "답변자가 아직 없는 상태에서만 질문 수정이 가능합니다.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: darkPrimaryColor,
                ),
              ),
            ),
            const Divider(color: lightGrayColor, height: 15),
            SizeAccentTextButton(
              buttonText: '삭제',
              textColor: cancelRedColor,
              onTap: onDeletePressed,
            ),
            const Divider(color: lightGrayColor, height: 15),
            SizeAccentTextButton(
              buttonText: '수정',
              onTap: onUpdatePressed,
            ),
            const Divider(color: lightGrayColor, height: 15),
            SizeAccentTextButton(
                buttonText: '취소',
                onTap: () {
                  Get.back();
                }),
          ],
        );
      } else {
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding:
              const EdgeInsets.only(top: 30, bottom: 30, left: 25, right: 25),
          children: [
            const Center(
              child: Text(
                '질문 옵션',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: darkPrimaryColor,
                ),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 15, bottom: 20, left: 20, right: 20),
              child: Text(
                "질문을 조기에 마감하거나 삭제하면 답변자들에게 QP가 지급된 후, 질문 등록 시 소모한 포인트 중 지급되지 않은 만큼 다시 돌려받습니다.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: darkPrimaryColor,
                ),
              ),
            ),
            SizeAccentTextButton(
              buttonText: '마감',
              textColor: brightPrimaryColor,
              onTap: onEndPressed,
            ),
            const Divider(color: lightGrayColor, height: 15),
            SizeAccentTextButton(
              buttonText: '삭제',
              textColor: cancelRedColor,
              onTap: onDeletePressed,
            ),
            const Divider(color: lightGrayColor, height: 15),
            SizeAccentTextButton(
                buttonText: '취소',
                onTap: () {
                  Get.back();
                }),
          ],
        );
      }
    } else {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding:
            const EdgeInsets.only(top: 20, bottom: 30, left: 25, right: 25),
        children: [
          SizeAccentTextButton(
            buttonText: '신고',
            textColor: cancelRedColor,
            onTap: onReportPressed,
          ),
          const Divider(color: lightGrayColor, height: 10),
          SizeAccentTextButton(
            buttonText: '취소',
            onTap: () {
              Get.back();
            },
          ),
        ],
      );
    }
  }
}

class CommentAnswerOptionsBottomSheet extends StatelessWidget {
  final bool isSelf;
  final Function() onUpdatePressed;
  final Function() onDeletePressed;
  final Function() onReportPressed;
  final Function()? onReplyPressed;
  final Function() onBackPressed;
  const CommentAnswerOptionsBottomSheet({
    Key? key,
    required this.isSelf,
    required this.onUpdatePressed,
    required this.onDeletePressed,
    required this.onReportPressed,
    required this.onReplyPressed,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isSelf) {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding:
            const EdgeInsets.only(top: 20, bottom: 30, left: 25, right: 25),
        children: [
          SizeAccentTextButton(
            buttonText: '삭제',
            textColor: cancelRedColor,
            onTap: onDeletePressed,
          ),
          const Divider(color: lightGrayColor, height: 15),
          SizeAccentTextButton(
            buttonText: '수정',
            onTap: onUpdatePressed,
          ),
          const Divider(color: lightGrayColor, height: 15),
          SizeAccentTextButton(
              buttonText: '취소',
              onTap: () {
                onBackPressed();
                Get.back();
              }),
        ],
      );
    } else {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding:
            const EdgeInsets.only(top: 20, bottom: 30, left: 25, right: 25),
        children: [
          if (onReplyPressed != null)
            SizeAccentTextButton(
              buttonText: '대댓글 작성',
              onTap: onReplyPressed!,
            ),
          if (onReplyPressed != null)
            const Divider(color: lightGrayColor, height: 10),
          SizeAccentTextButton(
            buttonText: '신고',
            textColor: cancelRedColor,
            onTap: onReportPressed,
          ),
          const Divider(color: lightGrayColor, height: 10),
          SizeAccentTextButton(
            buttonText: '취소',
            onTap: () {
              onBackPressed();
              Get.back();
            },
          ),
        ],
      );
    }
  }
}

class ReportBottomSheet extends StatelessWidget {
  final Function() onReportPressed;
  final RxList reportCategoryList;
  const ReportBottomSheet({
    Key? key,
    required this.onReportPressed,
    required this.reportCategoryList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding:
            const EdgeInsets.only(top: 30, bottom: 30, left: 25, right: 25),
        children: [
          const Center(
            child: Text(
              '신고하기',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: darkPrimaryColor,
              ),
            ),
          ),
          const Divider(color: lightGrayColor, height: 15),
          GestureDetector(
            onTap: () {
              if (reportCategoryList.contains(0)) {
                reportCategoryList.remove(0);
              } else {
                reportCategoryList.add(0);
              }
            },
            child: Row(
              children: [
                Radio(
                  value: 0,
                  groupValue: reportCategoryList.contains(0) ? 0 : null,
                  toggleable: true,
                  onChanged: (val) {
                    if (reportCategoryList.contains(0)) {
                      reportCategoryList.remove(0);
                    } else {
                      reportCategoryList.add(0);
                    }
                  },
                ),
                const Text(
                  '괴롭힘 또는 온라인 왕따',
                  style: TextStyle(
                    color: darkPrimaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (reportCategoryList.contains(1)) {
                reportCategoryList.remove(1);
              } else {
                reportCategoryList.add(1);
              }
            },
            child: Row(
              children: [
                Radio(
                    value: 1,
                    groupValue: reportCategoryList.contains(1) ? 1 : null,
                    onChanged: (val) {
                      if (reportCategoryList.contains(1)) {
                        reportCategoryList.remove(1);
                      } else {
                        reportCategoryList.add(1);
                      }
                    }),
                const Text(
                  '혐오발언 또는 욕설',
                  style: TextStyle(
                    color: darkPrimaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (reportCategoryList.contains(2)) {
                reportCategoryList.remove(2);
              } else {
                reportCategoryList.add(2);
              }
            },
            child: Row(
              children: [
                Radio(
                    value: 2,
                    groupValue: reportCategoryList.contains(2) ? 2 : null,
                    onChanged: (val) {
                      if (reportCategoryList.contains(2)) {
                        reportCategoryList.remove(2);
                      } else {
                        reportCategoryList.add(2);
                      }
                    }),
                const Text(
                  '폭력 및 범죄 활동 유도',
                  style: TextStyle(
                    color: darkPrimaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (reportCategoryList.contains(3)) {
                reportCategoryList.remove(3);
              } else {
                reportCategoryList.add(3);
              }
            },
            child: Row(
              children: [
                Radio(
                  value: 3,
                  groupValue: reportCategoryList.contains(3) ? 3 : null,
                  onChanged: (val) {
                    if (reportCategoryList.contains(3)) {
                      reportCategoryList.remove(3);
                    } else {
                      reportCategoryList.add(3);
                    }
                  },
                ),
                const Text(
                  '음란물 게시 및 신체노출, 성적희롱 등',
                  style: TextStyle(
                    color: darkPrimaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (reportCategoryList.contains(4)) {
                reportCategoryList.remove(4);
              } else {
                reportCategoryList.add(4);
              }
            },
            child: Row(
              children: [
                Radio(
                    value: 4,
                    groupValue: reportCategoryList.contains(4) ? 4 : null,
                    onChanged: (val) {
                      if (reportCategoryList.contains(4)) {
                        reportCategoryList.remove(4);
                      } else {
                        reportCategoryList.add(4);
                      }
                    }),
                const Text(
                  '불법 (사기, 도박, 사행성)',
                  style: TextStyle(
                    color: darkPrimaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (reportCategoryList.contains(5)) {
                reportCategoryList.remove(5);
              } else {
                reportCategoryList.add(5);
              }
            },
            child: Row(
              children: [
                Radio(
                    value: 5,
                    groupValue: reportCategoryList.contains(5) ? 5 : null,
                    onChanged: (val) {
                      if (reportCategoryList.contains(5)) {
                        reportCategoryList.remove(5);
                      } else {
                        reportCategoryList.add(5);
                      }
                    }),
                const Text(
                  '홍보 및 상업적 광고 또는 게시물 도배',
                  style: TextStyle(
                    color: darkPrimaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (reportCategoryList.contains(6)) {
                reportCategoryList.remove(6);
              } else {
                reportCategoryList.add(6);
              }
            },
            child: Row(
              children: [
                Radio(
                    value: 6,
                    groupValue: reportCategoryList.contains(6) ? 6 : null,
                    onChanged: (val) {
                      if (reportCategoryList.contains(6)) {
                        reportCategoryList.remove(6);
                      } else {
                        reportCategoryList.add(6);
                      }
                    }),
                const Text(
                  '개인정보 요청 및 오프만남 요구 등',
                  style: TextStyle(
                    color: darkPrimaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: lightGrayColor, height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizeAccentTextButton(
                  buttonText: '취소',
                  onTap: () {
                    Get.back();
                  }),
              SizeAccentTextButton(
                buttonText: '완료',
                textColor: cancelRedColor,
                onTap: onReportPressed,
              ),
            ],
          ),
        ],
      );
    });
  }
}

class BlockUserBottomSheet extends StatelessWidget {
  final String username;
  final Function() onBlockPressed;
  final Function() onReportPressed;
  final Function() onBackPressed;
  const BlockUserBottomSheet({
    Key? key,
    required this.username,
    required this.onBlockPressed,
    required this.onReportPressed,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 30, bottom: 30, left: 25, right: 25),
      children: [
        const Center(
          child: Text(
            '알려주셔서 고맙습니다',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: darkPrimaryColor,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 15, bottom: 20, left: 20, right: 20),
          child: Text(
            "회원님의 소중한 의견은 큐앤픽 커뮤니티를 안전하게 유지하는데 도움이 됩니다.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: darkPrimaryColor,
            ),
          ),
        ),
        SizeAccentTextButton(
          buttonText: '$username님 차단하기',
          textColor: cancelRedColor,
          onTap: onBlockPressed,
        ),
        const Divider(color: lightGrayColor, height: 15),
        SizeAccentTextButton(
          buttonText: '$username님 신고하기',
          onTap: onReportPressed,
        ),
        const Divider(color: lightGrayColor, height: 15),
        SizeAccentTextButton(
            buttonText: '돌아가기',
            onTap: () {
              onBackPressed();
              Get.back();
            }),
      ],
    );
  }
}

class DeleteUserBottomSheet extends StatelessWidget {
  final Function() onDeletePressed;
  const DeleteUserBottomSheet({
    Key? key,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 25, bottom: 30, left: 25, right: 25),
      children: [
        SizeAccentTextButton(
          buttonText: '회원 탈퇴',
          textColor: cancelRedColor,
          onTap: onDeletePressed,
        ),
        const Divider(color: lightGrayColor, height: 15),
        SizeAccentTextButton(
            buttonText: '취소',
            onTap: () {
              Get.back();
            }),
      ],
    );
  }
}

class SendEmailBottomSheet extends StatelessWidget {
  final TextEditingController controller;
  final Function() onSendPressed;
  const SendEmailBottomSheet({
    Key? key,
    required this.controller,
    required this.onSendPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 25, bottom: 30, left: 25, right: 25),
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 100,
            maxHeight: context.height * 0.6,
          ),
          child: EmailInputField(
            controller: controller,
          ),
        ),
        const Divider(color: lightGrayColor, height: 15),
        SizeAccentTextButton(
          buttonText: '전송',
          textColor: brightPrimaryColor,
          onTap: onSendPressed,
        ),
      ],
    );
  }
}

void getAddMediaBottomSheet({
  required Function(File) onCompleteDrawPressed,
  required Function() onPickImagePressed,
  required Function() onPickVideoPressed,
}) {
  Get.bottomSheet(
    AddMediaBottomSheet(
        onDrawCompletePressed: onCompleteDrawPressed,
        onPickImagePressed: onPickImagePressed,
        onPickVideoPressed: onPickVideoPressed),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    backgroundColor: Colors.white,
  );
}

void getAddMapQuestionSheet({
  required Function() onWriteOptionQuestionPressed,
  required Function() onWriteCommentQuestionPressed,
  required Function() onBackPressed,
}) {
  Get.bottomSheet(
    AddMapQuestionSheet(
        onWriteOptionQuestionPressed: onWriteOptionQuestionPressed,
        onWriteCommentQuestionPressed: onWriteCommentQuestionPressed,
        onBackPressed: onBackPressed),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    backgroundColor: Colors.white,
  );
}

void getQuestionOptionsBottomSheet({
  required bool isSelf,
  required bool hasAnswers,
  required Function() onUpdatePressed,
  required Function() onEndPressed,
  required Function() onDeletePressed,
  required Function() onReportPressed,
}) {
  Get.bottomSheet(
    QuestionOptionsBottomSheet(
        isSelf: isSelf,
        hasAnswers: hasAnswers,
        onUpdatePressed: onUpdatePressed,
        onEndPressed: onEndPressed,
        onDeletePressed: onDeletePressed,
        onReportPressed: onReportPressed),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    backgroundColor: Colors.white,
  );
}

void getReportBottomSheet({
  required Function() onReportPressed,
  required RxList reportCategoryList,
}) {
  Get.bottomSheet(
    ReportBottomSheet(
      onReportPressed: onReportPressed,
      reportCategoryList: reportCategoryList,
    ),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    backgroundColor: Colors.white,
  );
}

void getBlockUserBottomSheet({
  required String username,
  required Function() onBlockPressed,
  required Function() onReportPressed,
  required Function() onBackPressed,
}) {
  Get.bottomSheet(
    BlockUserBottomSheet(
      username: username,
      onBlockPressed: onBlockPressed,
      onReportPressed: onReportPressed,
      onBackPressed: onBackPressed,
    ),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    backgroundColor: Colors.white,
  );
}

void getCommentAnswerOptionsBottomSheet({
  required bool isSelf,
  required Function() onUpdatePressed,
  required Function() onDeletePressed,
  required Function() onReportPressed,
  required Function()? onReplyPressed,
  required Function() onBackPressed,
}) {
  Get.bottomSheet(
    CommentAnswerOptionsBottomSheet(
      isSelf: isSelf,
      onUpdatePressed: onUpdatePressed,
      onDeletePressed: onDeletePressed,
      onReportPressed: onReportPressed,
      onReplyPressed: onReplyPressed,
      onBackPressed: onBackPressed,
    ),
    isScrollControlled: true,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    backgroundColor: Colors.white,
  );
}

void getDeleteUserBottomSheet({
  required Function() onDeletePressed,
}) {
  Get.bottomSheet(
    DeleteUserBottomSheet(
      onDeletePressed: onDeletePressed,
    ),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    backgroundColor: Colors.white,
  );
}

void getSendEmailBottomSheet({
  required TextEditingController controller,
  required Function() onSendPressed,
}) {
  Get.bottomSheet(
    SendEmailBottomSheet(
      controller: controller,
      onSendPressed: onSendPressed,
    ),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    backgroundColor: Colors.white,
  );
}
