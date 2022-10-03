import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/community_controller.dart';
import 'package:qnpick/core/controllers/search_controller.dart';
import 'package:qnpick/ui/widgets/content_preview_builder.dart';
import 'package:qnpick/ui/widgets/custom_refresh_footer.dart';
import 'package:qnpick/ui/widgets/header.dart';
import 'package:qnpick/ui/widgets/loading_blocks.dart';
import 'package:qnpick/ui/widgets/search_filter.dart';
import 'package:qnpick/ui/widgets/svg_icons.dart';

class QuestionListPage extends GetView<CommunityController> {
  const QuestionListPage({Key? key}) : super(key: key);

  void _onBackPressed() {
    Get.back();
  }

  void _onSearchPressed() {
    SearchController.to.searchTextController.clear();
    SearchController.to.searchFilter.value = controller.filter.value;
    SearchController.to.searchCategoryList.clear();
    SearchController.to.searchCategoryList
        .addAll(controller.filterCategoryList.toList());
    Get.toNamed('/search');
  }

  void _onFilterPressed() {
    Get.bottomSheet(
      SearchFilter(
        tapList: controller.filterCategoryTapList,
        filter: controller.filter,
        randomMode: false,
        showInterestCategories: true,
        filterCategoryList: controller.filterCategoryList,
        onDetailFilterCompletePressed: controller.onDetailFilterCompletePressed,
        searchActivated: true,
        seeClosed: controller.seeClosed,
        onSeeClosedChanged: controller.onSeeClosedChanged,
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

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      if (controller.initialLoading.value) {
        await controller.getQuestionList();
        controller.initialLoading.value = false;
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(
              onPressed: _onBackPressed,
              title: '질문 전체보기',
              actions: [
                IconButton(
                  onPressed: _onSearchPressed,
                  splashRadius: 25,
                  icon: const Icon(
                    Icons.search_rounded,
                    color: darkPrimaryColor,
                  ),
                ),
                IconButton(
                  onPressed: _onFilterPressed,
                  splashRadius: 25,
                  icon: const FilterIcon(
                    color: darkPrimaryColor,
                  ),
                ),
              ],
            ),
            Expanded(
              child: GetX<CommunityController>(
                builder: (_) {
                  return SmartRefresher(
                    controller: _.questionListRefreshController,
                    onLoading: _.onQuestionListLoadMore,
                    enablePullUp: true,
                    enablePullDown: false,
                    footer: const CustomRefreshFooter(),
                    physics: const ClampingScrollPhysics(),
                    child: () {
                      if (_.initialLoading.value) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                          itemBuilder: ((context, index) =>
                              const LoadingBlock()),
                          separatorBuilder: ((context, index) => const SizedBox(
                                height: 15,
                              )),
                          itemCount: 3,
                        );
                      } else if ((_.mediaType.value == 0 &&
                              _.textQuestionList.isEmpty) ||
                          (_.mediaType.value == 1 &&
                              _.imageQuestionList.isEmpty) ||
                          (_.mediaType.value == 2 &&
                              _.videoQuestionList.isEmpty)) {
                        return Column(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(top: 150, bottom: 30),
                              child: FailCharacter(),
                            ),
                            Text(
                              '질문이 없습니다',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                color: lightGrayColor,
                              ),
                            )
                          ],
                        );
                      } else {
                        late RxList<dynamic> _list;
                        if (_.mediaType.value == 0) {
                          _list = _.textQuestionList;
                        } else if (_.mediaType.value == 1) {
                          _list = _.imageQuestionList;
                        } else {
                          _list = _.videoQuestionList;
                        }
                        return ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          controller: _.questionListScrollController,
                          padding: const EdgeInsets.only(bottom: 20),
                          itemBuilder: (context, index) {
                            if (_list[index]['question_data']['media_key'] ==
                                null) {
                              return HomeTextPreviewBuilder(
                                questionData: _list[index]['question_data'],
                                count: _list[index]['count'],
                              );
                            } else {
                              return HomeMediaPreviewBuilder(
                                questionData: _list[index]['question_data'],
                                count: _list[index]['count'],
                              );
                            }
                          },
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Divider(
                              color: lightGrayColor.withOpacity(0.5),
                              height: 1,
                              thickness: 1,
                            ),
                          ),
                          itemCount: _list.length,
                        );
                      }
                    }(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
