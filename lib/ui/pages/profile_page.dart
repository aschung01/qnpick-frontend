import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/profile_controller.dart';
import 'package:qnpick/helpers/transformers.dart';
import 'package:qnpick/ui/widgets/buttons.dart';
import 'package:qnpick/ui/widgets/content_preview_builder.dart';
import 'package:qnpick/ui/widgets/custom_refresh_footer.dart';
import 'package:qnpick/ui/widgets/loading_blocks.dart';
import 'package:qnpick/ui/widgets/svg_icons.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  void _onAddInterestCategoryPressed() {
    Get.toNamed('/update_interest_categories');
  }

  void _onSignInPressed() {
    Get.toNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration.zero,
      () async {
        if (AuthController.to.isAuthenticated.value) {
          await AuthController.to.getUserInfoIfEmpty();
          controller.userCreatedQuestions.clear();
          controller.userAnsweredQuestions.clear();
          await controller.getUserCreatedQuestions();
          await controller.getUserAnsweredQuestions();
        }
      },
    );

    return GetX<ProfileController>(
      builder: (_) {
        _.userCreatedQuestionsRefreshController = RefreshController();
        _.userAnsweredQuestionsRefreshController = RefreshController();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetX<AuthController>(
              builder: (__) {
                return ProfileHeader(
                  username: __.userInfo['username'],
                );
              },
            ),
            GetX<AuthController>(
              builder: (__) {
                if (__.userInfo.isNotEmpty
                    ? __.userInfo['interest_categories']?.isEmpty
                    : true) {
                  return const SizedBox.shrink();
                } else {
                  return const Padding(
                    padding: EdgeInsets.only(left: 25, top: 10, bottom: 10),
                    child: Text(
                      '관심 분야',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, bottom: 10, right: 0),
              child: GetX<AuthController>(builder: (__) {
                if (__.isAuthenticated.value) {
                  return GetX<AuthController>(
                    builder: (__) {
                      if (__.userInfo.isNotEmpty
                          ? __.userInfo['interest_categories']?.isEmpty
                          : true) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: TextActionButton(
                            buttonText: '관심 분야 선택하러 가기 >',
                            onPressed: _onAddInterestCategoryPressed,
                            fontSize: 14,
                            isUnderlined: false,
                            fontWeight: FontWeight.bold,
                            textColor: Colors.white,
                            overlayColor: Colors.white.withOpacity(0.2),
                            // padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: 40,
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: ((context, index) {
                              return Chip(
                                backgroundColor: Colors.white,
                                label: Text(
                                  questionCategoryIntToStr[__
                                      .userInfo['interest_categories'][index]]!,
                                  style: const TextStyle(
                                    color: brightPrimaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }),
                            separatorBuilder: ((context, index) =>
                                const SizedBox(width: 6)),
                            itemCount:
                                __.userInfo['interest_categories'].length,
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15, bottom: 5),
                      child: TextActionButton(
                        buttonText: '큐앤픽 로그인하기 >',
                        onPressed: _onSignInPressed,
                        fontSize: 20,
                        fontFamily: 'Jalnan',
                        isUnderlined: false,
                        activated: !__.isAuthenticated.value,
                        fontWeight: FontWeight.bold,
                        textColor: Colors.white,
                        overlayColor: Colors.white.withOpacity(0.2),
                        // padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      ),
                    ),
                  );
                }
              }),
            ),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TabBar(
                controller: _.profileTabController,
                indicatorColor: brightPrimaryColor,
                automaticIndicatorColorAdjustment: false,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: brightPrimaryColor,
                unselectedLabelColor: darkPrimaryColor,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                tabs: const [
                  Tab(
                    child: Text(
                      '내가 올린 질문',
                    ),
                  ),
                  Tab(
                    child: Text(
                      '내가 응답한 질문',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: TabBarView(
                  physics: const ClampingScrollPhysics(),
                  controller: _.profileTabController,
                  children: [
                    SmartRefresher(
                      controller: _.userCreatedQuestionsRefreshController,
                      onLoading: _.onUserCreatedQuestionsLoadMore,
                      enablePullUp: true,
                      enablePullDown: false,
                      footer: const CustomRefreshFooter(),
                      physics: const ClampingScrollPhysics(),
                      child: () {
                        if (_.userCreatedQuestions.isNotEmpty) {
                          return ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            controller: _.userCreatedQuestionsScrollController,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 10),
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: ContentPreviewBuilder(
                                  questionData: _.userCreatedQuestions[index]
                                      ['question_data'],
                                  count: _.userCreatedQuestions[index]['count'],
                                ),
                              );
                            }),
                            itemCount: _.userCreatedQuestions.length,
                          );
                        } else if (AuthController.to.isAuthenticated.value &&
                            _.initialLoading.value) {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                            itemBuilder: ((context, index) =>
                                const LoadingBlock()),
                            separatorBuilder: ((context, index) =>
                                const SizedBox(
                                  height: 15,
                                )),
                            itemCount: 3,
                          );
                        } else {
                          return Column(
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(top: 150, bottom: 30),
                                child: FailCharacter(),
                              ),
                              Text(
                                '올린 질문이 없습니다',
                                style: TextStyle(
                                    fontSize: 16, color: lightGrayColor),
                              )
                            ],
                          );
                        }
                      }(),
                    ),
                    SmartRefresher(
                      controller: _.userAnsweredQuestionsRefreshController,
                      onLoading: _.onUserAnsweredQuestionsLoadMore,
                      enablePullUp: true,
                      enablePullDown: false,
                      footer: const CustomRefreshFooter(),
                      physics: const ClampingScrollPhysics(),
                      child: () {
                        if (_.userAnsweredQuestions.isNotEmpty) {
                          return ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            controller: _.userAnsweredQuestionsScrollController,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 10),
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: ContentPreviewBuilder(
                                  questionData: _.userAnsweredQuestions[index]
                                      ['question_data'],
                                  count: _.userAnsweredQuestions[index]
                                      ['count'],
                                ),
                              );
                            }),
                            itemCount: _.userAnsweredQuestions.length,
                          );
                        } else if (AuthController.to.isAuthenticated.value &&
                            _.initialLoading.value) {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                            itemBuilder: ((context, index) =>
                                const LoadingBlock()),
                            separatorBuilder: ((context, index) =>
                                const SizedBox(
                                  height: 15,
                                )),
                            itemCount: 3,
                          );
                        } else {
                          return Column(
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(top: 150, bottom: 30),
                                child: FailCharacter(),
                              ),
                              Text(
                                '응답한 질문이 없습니다',
                                style: TextStyle(
                                    fontSize: 16, color: lightGrayColor),
                              )
                            ],
                          );
                        }
                      }(),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String? username;
  const ProfileHeader({Key? key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onMenuPressed() {
      Get.toNamed('/settings');
    }

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: username != null
          ? Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                username!,
                style: const TextStyle(
                  fontFamily: 'Jalnan',
                  color: lightBrightPrimaryColor,
                  fontSize: 20,
                ),
              ),
            )
          : null,
      actions: username != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: IconButton(
                  onPressed: _onMenuPressed,
                  splashRadius: 25,
                  icon: const Icon(Icons.menu_rounded, size: 30),
                ),
              )
            ]
          : null,
    );
  }
}
