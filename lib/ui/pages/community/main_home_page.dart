import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/community_controller.dart';
import 'package:qnpick/core/controllers/community_write_controller.dart';
import 'package:qnpick/core/controllers/main_home_controller.dart';
import 'package:qnpick/core/controllers/search_controller.dart';
import 'package:qnpick/helpers/transformers.dart';
import 'package:qnpick/helpers/utils.dart';
import 'package:qnpick/ui/widgets/buttons.dart';
import 'package:qnpick/ui/widgets/content_preview_builder.dart';
import 'package:qnpick/ui/widgets/index_indicator.dart';
import 'package:qnpick/ui/widgets/loading_blocks.dart';
import 'package:qnpick/ui/widgets/search_filter.dart';
import 'package:qnpick/ui/widgets/svg_icons.dart';

class MainHomePage extends GetView<MainHomeController> {
  const MainHomePage({Key? key}) : super(key: key);

  void _onSearchTap() {
    SearchController.to.reset();
    Get.toNamed('/search');
    Future.delayed(
      Duration.zero,
      () {
        if (SearchController.to.searchTextController.text == '') {
          SearchController.to.searchFieldFocus.requestFocus();
        }
      },
    );
  }

  void _onFilterPressed() {
    Get.bottomSheet(
      SearchFilter(
        tapList: controller.searchCategoryTapList,
        filter: controller.searchFilter,
        onCreateRandomPressed: () {
          controller.searchCategoryList.value = getRandomCategories();
          controller.getHomeQuestionPreview();
          Get.back();
        },
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

  void _onExpandListPressed() {
    CommunityController.to.initialLoading.value = true;
    CommunityController.to.questionListStartIndex.value = 0;
    Get.toNamed('/question_list');
  }

  void _onWriteOptionQuestionPressed() {
    if (AuthController.to.isAuthenticated.value) {
      CommunityWriteController.to.updateType(0);
      CommunityWriteController.to.point.value = 10;
      Get.toNamed('/write');
    } else {
      Get.toNamed('/auth');
    }
  }

  void _onWriteCommentQuestionPressed() {
    if (AuthController.to.isAuthenticated.value) {
      CommunityWriteController.to.updateType(1);
      CommunityWriteController.to.point.value = 100;
      Get.toNamed('/write');
    } else {
      Get.toNamed('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      if (AuthController.to.isAuthenticated.value) {
        await AuthController.to.getUserInfoIfEmpty();
        if (AuthController.to.userInfo['interest_categories'].isNotEmpty) {
          controller.searchFilter.value = 1;
          controller.searchCategoryList
              .addAll(AuthController.to.userInfo['interest_categories']);
        }
      }
      if (controller.textQuestionList.isEmpty &&
          controller.imageQuestionList.isEmpty &&
          controller.videoQuestionList.isEmpty) {
        controller.getHomeQuestionPreview();
      }
    });

    return Stack(
      children: [
        NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '큐앤픽.',
                        style: TextStyle(
                          fontFamily: 'Jalnan',
                          color: brightPrimaryColor,
                          // color: lightBrightPrimaryColor,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            const Text(
                              '가장 빠르고 효율적인 ',
                              style: TextStyle(
                                fontFamily: 'Jalnan',
                                color: lightBrightPrimaryColor,
                                fontSize: 16,
                              ),
                            ),
                            DefaultTextStyle(
                              style: const TextStyle(
                                fontSize: 16,
                                color: lightBrightPrimaryColor,
                                fontFamily: 'Jalnan',
                              ),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  RotateAnimatedText('궁금증 해결'),
                                  RotateAnimatedText('설문조사'),
                                  RotateAnimatedText('투표'),
                                  RotateAnimatedText('실시간 대답'),
                                ],
                                pause: const Duration(milliseconds: 300),
                                repeatForever: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                    PreferredSize(
                      child: Hero(
                        child: SearchInputSection(onTap: _onSearchTap),
                        tag: "search",
                      ),
                      preferredSize: const Size.fromHeight(56),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Builder(
            builder: (context) {
              return DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverFillRemaining(
                      child: SmartRefresher(
                        controller: controller.refreshController,
                        onRefresh: controller.onRefresh,
                        header: const MaterialClassicHeader(
                          color: brightPrimaryColor,
                        ),
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 5, 0, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Material(
                                    type: MaterialType.transparency,
                                    child: IconButton(
                                      onPressed: _onFilterPressed,
                                      splashRadius: 20,
                                      icon: const CircleAvatar(
                                        backgroundColor: softBlueColor,
                                        child: FilterIcon(
                                          color: Colors.white,
                                          // color: deepGrayColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GetX<MainHomeController>(
                                      builder: (__) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxHeight: 30,
                                                maxWidth: context.width - 250,
                                              ),
                                              child: () {
                                                if (__.searchFilter.value ==
                                                    0) {
                                                  return const Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      '전체 카테고리',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: deepGrayColor,
                                                      ),
                                                    ),
                                                  );
                                                } else if (__.searchCategoryList
                                                    .isEmpty) {
                                                  return const LoadingChips();
                                                } else {
                                                  return ListView.separated(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        ((context, index) {
                                                      return Chip(
                                                        backgroundColor:
                                                            backgroundColor,
                                                        label: Text(
                                                          questionCategoryIntToStr[
                                                              __.searchCategoryList[
                                                                  index]]!,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                darkPrimaryColor,
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                    separatorBuilder:
                                                        ((context, index) =>
                                                            const SizedBox(
                                                                width: 6)),
                                                    itemCount: __
                                                        .searchCategoryList
                                                        .length,
                                                  );
                                                }
                                              }(),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 6),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  const Text(
                                                    '마감된 질문들 보기',
                                                    style: TextStyle(
                                                      color: deepGrayColor,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Switch(
                                                    value: __.seeClosed.value,
                                                    onChanged: (bool val) {
                                                      __.seeClosed.value = val;
                                                    },
                                                    activeColor:
                                                        brightSecondaryColor,
                                                  ),
                                                ],
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '질문 게시글',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: darkPrimaryColor,
                                    ),
                                  ),
                                  TextActionButton(
                                    buttonText: '전체보기 >',
                                    onPressed: () {
                                      CommunityController.to.textQuestionList
                                          .clear();
                                      _onExpandListPressed();
                                      CommunityController.to.mediaType.value =
                                          0;
                                    },
                                    isUnderlined: false,
                                    textColor: deepGrayColor,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: GetX<MainHomeController>(
                                builder: (_) {
                                  if (_.loading.value) {
                                    return const Center(
                                      child: LoadingBlock(),
                                    );
                                  } else if (_.textQuestionList.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        '질문이 없습니다',
                                        style: TextStyle(
                                          height: 2,
                                          fontSize: 14,
                                          color: lightGrayColor,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xffF4F4F4),
                                        ),
                                        child: Column(
                                          children: List.generate(
                                            _.textQuestionList.length * 2 - 1,
                                            (index) => index % 2 == 0
                                                ? HomeTextPreviewBuilder(
                                                    questionData:
                                                        _.textQuestionList[
                                                                index ~/ 2]
                                                            ['question_data'],
                                                    count: _.textQuestionList[
                                                        index ~/ 2]['count'],
                                                  )
                                                : Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    child: Divider(
                                                      color: lightGrayColor
                                                          .withOpacity(0.5),
                                                      height: 1,
                                                      thickness: 1,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '사진 질문',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: darkPrimaryColor,
                                    ),
                                  ),
                                  TextActionButton(
                                    buttonText: '전체보기 >',
                                    onPressed: () {
                                      CommunityController.to.imageQuestionList
                                          .clear();
                                      _onExpandListPressed();
                                      CommunityController.to.mediaType.value =
                                          1;
                                    },
                                    isUnderlined: false,
                                    textColor: deepGrayColor,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: GetX<MainHomeController>(
                                builder: (_) {
                                  if (_.loading.value) {
                                    return LoadingBlock();
                                  } else if (_.imageQuestionList.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        '질문이 없습니다',
                                        style: TextStyle(
                                          height: 2,
                                          fontSize: 14,
                                          color: lightGrayColor,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xffF4F4F4),
                                        ),
                                        child: Column(
                                          children: List.generate(
                                            _.imageQuestionList.length * 2 - 1,
                                            (index) {
                                              return index % 2 == 0
                                                  ? HomeMediaPreviewBuilder(
                                                      questionData:
                                                          _.imageQuestionList[
                                                                  index ~/ 2]
                                                              ['question_data'],
                                                      count:
                                                          _.imageQuestionList[
                                                                  index ~/ 2]
                                                              ['count'],
                                                    )
                                                  : Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8),
                                                      child: Divider(
                                                        color: lightGrayColor
                                                            .withOpacity(0.5),
                                                        height: 1,
                                                        thickness: 1,
                                                      ),
                                                    );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(25, 20, 25, 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '동영상 질문',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: darkPrimaryColor,
                                    ),
                                  ),
                                  TextActionButton(
                                    buttonText: '전체보기 >',
                                    onPressed: () {
                                      CommunityController.to.videoQuestionList
                                          .clear();
                                      _onExpandListPressed();
                                      CommunityController.to.mediaType.value =
                                          2;
                                    },
                                    isUnderlined: false,
                                    textColor: deepGrayColor,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              child: GetX<MainHomeController>(
                                builder: (_) {
                                  if (_.loading.value) {
                                    return LoadingBlock();
                                  } else if (_.videoQuestionList.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        '질문이 없습니다',
                                        style: TextStyle(
                                          height: 2,
                                          fontSize: 14,
                                          color: lightGrayColor,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xffF4F4F4),
                                        ),
                                        child: Column(
                                          children: List.generate(
                                            _.videoQuestionList.length * 2 - 1,
                                            (index) {
                                              return index % 2 == 0
                                                  ? HomeMediaPreviewBuilder(
                                                      questionData:
                                                          _.videoQuestionList[
                                                                  index ~/ 2]
                                                              ['question_data'],
                                                      count:
                                                          _.videoQuestionList[
                                                                  index ~/ 2]
                                                              ['count'],
                                                    )
                                                  : Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8),
                                                      child: Divider(
                                                        color: lightGrayColor
                                                            .withOpacity(0.5),
                                                        height: 1,
                                                        thickness: 1,
                                                      ),
                                                    );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Positioned(
          right: 25,
          bottom: 25,
          child: SpeedDial(
            buttonSize: const Size(70, 70),
            backgroundColor: brightPrimaryColor,
            activeBackgroundColor: Colors.white,
            overlayColor: Colors.white,
            overlayOpacity: 0.7,
            iconTheme: const IconThemeData(
              size: 35,
            ),
            animatedIconTheme: const IconThemeData(
              size: 25,
            ),
            icon: Icons.edit_rounded,
            activeIcon: Icons.close_rounded,
            activeForegroundColor: brightPrimaryColor,
            foregroundColor: Colors.white,
            spaceBetweenChildren: 5,
            spacing: 5,
            children: [
              SpeedDialChild(
                labelWidget: const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    '댓글형 질문 작성',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
                labelBackgroundColor: lightBrightPrimaryColor,
                elevation: 5,
                labelShadow: [],
                child: const CommentIcon(),
                onTap: _onWriteCommentQuestionPressed,
              ),
              SpeedDialChild(
                labelWidget: const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    '선다형 질문 작성',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
                labelBackgroundColor: lightBrightPrimaryColor,
                elevation: 5,
                labelShadow: [],
                child: const NumberedListIcon(),
                onTap: _onWriteOptionQuestionPressed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this.child);

  final PreferredSizeWidget child;

  @override
  double get minExtent => child.preferredSize.height;
  @override
  double get maxExtent => child.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

const String _searchLabelText = '검색으로 궁금증 해결하기';

class SearchInputSection extends StatelessWidget {
  final Function() onTap;
  const SearchInputSection({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: darkPrimaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          width: context.width,
          height: 28,
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 56,
            width: context.width - 30,
            padding: const EdgeInsets.only(left: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: darkPrimaryColor),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: Offset.fromDirection(
                    pi / 2,
                    2,
                  ),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.search_rounded,
                  color: lightGrayColor,
                  size: 24,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    _searchLabelText,
                    style: TextStyle(
                      color: lightGrayColor,
                      fontSize: 16,
                      fontFamily: 'GodoM',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
