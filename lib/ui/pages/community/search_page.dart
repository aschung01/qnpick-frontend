import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/community_controller.dart';
import 'package:qnpick/core/controllers/main_home_controller.dart';
import 'package:qnpick/core/controllers/search_controller.dart';
import 'package:qnpick/ui/widgets/content_preview_builder.dart';
import 'package:qnpick/ui/widgets/custom_refresh_footer.dart';
import 'package:qnpick/ui/widgets/input_fields.dart';
import 'package:qnpick/ui/widgets/loading_blocks.dart';
import 'package:qnpick/ui/widgets/search_filter.dart';
import 'package:qnpick/ui/widgets/svg_icons.dart';

class SearchPage extends GetView<SearchController> {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onFieldSubmitted(String inputText) {
      controller.searchFieldFocus.unfocus();
      controller.search();
    }

    void _onBackPressed() {
      CommunityController.to.filter.value = controller.searchFilter.value;
      CommunityController.to.filterCategoryList.clear();
      CommunityController.to.filterCategoryList
          .addAll(controller.searchCategoryList.toList());
      controller.searchFieldFocus.unfocus();
      controller.reset();
      Get.back();
    }

    void _onFilterPressed() {
      Get.bottomSheet(
        SearchFilter(
          tapList: controller.searchCategoryTapList,
          filter: controller.searchFilter,
          randomMode: false,
          showInterestCategories: true,
          showSearchButton: true,
          filterCategoryList: controller.searchCategoryList,
          onDetailFilterCompletePressed:
              controller.onDetailFilterCompletePressed,
          seeClosed: controller.seeClosed,
          onSeeClosedChanged: controller.onSeeClosedChanged,
          onSearchPressed: () {
            controller.search();
            Get.back();
          },
          searchActivated: controller.searchTextController.text.isNotEmpty,
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

    void _onInputChanged(String input) {
      if (controller.searchFailed.value && input.isEmpty) {
        controller.searchFailed.value = false;
      }

      controller.update();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<SearchController>(
          builder: (_) {
            return Column(
              children: [
                Hero(
                  tag: "search",
                  child: SizedBox(
                    height: 56,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: IconButton(
                              onPressed: _onBackPressed,
                              splashRadius: 25,
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: _.searchTextController.text != ''
                                    ? darkPrimaryColor
                                    : lightGrayColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: Center(
                                child: SearchInputField(
                                  controller: _.searchTextController,
                                  onFieldSubmitted: _onFieldSubmitted,
                                  focusNode: _.searchFieldFocus,
                                  onChanged: _onInputChanged,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 6, top: 10, bottom: 10),
                            child: IconButton(
                              onPressed: _onFilterPressed,
                              splashRadius: 25,
                              icon: Text(
                                '필터',
                                style: TextStyle(
                                  color: _.searchTextController.text != ''
                                      ? darkPrimaryColor
                                      : lightGrayColor,
                                ),
                              ),
                              // FilterIcon(
                              //   color: _.searchTextController.text != ''
                              //       ? darkPrimaryColor
                              //       : lightGrayColor,
                              // ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GetX<SearchController>(
                    builder: (_) {
                      return SmartRefresher(
                        controller: _.resultListRefreshController,
                        onLoading: _.onResultListLoadMore,
                        enablePullUp: true,
                        enablePullDown: false,
                        footer: const CustomRefreshFooter(),
                        physics: const ClampingScrollPhysics(),
                        child: () {
                          if (_.initialLoading.value) {
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets.fromLTRB(20, 15, 20, 10),
                              itemBuilder: ((context, index) =>
                                  const LoadingBlock()),
                              separatorBuilder: ((context, index) =>
                                  const SizedBox(
                                    height: 15,
                                  )),
                              itemCount: 3,
                            );
                          } else if (_.searchResultList.isEmpty) {
                            if (_.searchFailed.value) {
                              return Column(
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 150, bottom: 30),
                                    child: FailCharacter(),
                                  ),
                                  Text(
                                    '검색 결과가 없습니다',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                      color: lightGrayColor,
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 150, bottom: 30),
                                    child: SearchCharacter(),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        '무엇이든 물어보세요',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                          color: lightGrayColor,
                                        ),
                                      ),
                                      Transform.rotate(
                                        angle: pi * 20 / 360,
                                        child: const ExclamationIcon(
                                          color: lightGrayColor,
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            }
                          } else {
                            return ListView.separated(
                              physics: const ClampingScrollPhysics(),
                              controller: _.resultListScrollController,
                              padding: const EdgeInsets.only(bottom: 20),
                              itemBuilder: (context, index) {
                                if (_.searchResultList[index]['question_data']
                                        ['media_key'] ==
                                    null) {
                                  return ContentPreviewBuilder(
                                    questionData: _.searchResultList[index]
                                        ['question_data'],
                                    count: _.searchResultList[index]['count'],
                                  );
                                } else {
                                  return MediaContentPreviewBuilder(
                                    questionData: _.searchResultList[index]
                                        ['question_data'],
                                    count: _.searchResultList[index]['count'],
                                  );
                                }
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 15,
                              ),
                              itemCount: _.searchResultList.length,
                            );
                          }
                        }(),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
