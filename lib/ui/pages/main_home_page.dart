import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/search_controller.dart';
import 'package:qnpick/ui/widgets/buttons.dart';
import 'package:qnpick/ui/widgets/svg_icons.dart';

class MainHomePage extends StatelessWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onSearchTap() {
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

    void _onExpandListPressed() {}

    void _onWriteInfoPostPressed() {}

    void _onWriteCommentQuestionPressed() {}

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
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 20, 25, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '내 관심 분야의 인기 질문',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: darkPrimaryColor,
                                  ),
                                ),
                                TextActionButton(
                                  buttonText: '더보기 >',
                                  onPressed: _onExpandListPressed,
                                  isUnderlined: false,
                                  textColor: deepGrayColor,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 20, 25, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '내 관심 분야의 인기 사진',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: darkPrimaryColor,
                                  ),
                                ),
                                TextActionButton(
                                  buttonText: '더보기 >',
                                  onPressed: _onExpandListPressed,
                                  isUnderlined: false,
                                  textColor: deepGrayColor,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 20, 25, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '내 관심 분야의 인기 동영상',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: darkPrimaryColor,
                                  ),
                                ),
                                TextActionButton(
                                  buttonText: '더보기 >',
                                  onPressed: _onExpandListPressed,
                                  isUnderlined: false,
                                  textColor: deepGrayColor,
                                )
                              ],
                            ),
                          ),
                        ],
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
                onTap: _onWriteInfoPostPressed,
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
