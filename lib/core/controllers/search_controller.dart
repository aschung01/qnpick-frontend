import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/services/community_api_service.dart';
import 'package:qnpick/helpers/utils.dart';

class SearchController extends GetxController {
  static SearchController to = Get.find<SearchController>();

  TextEditingController searchTextController = TextEditingController();
  ScrollController resultListScrollController = ScrollController();
  RefreshController resultListRefreshController = RefreshController();

  late FocusNode searchFieldFocus;

  RxBool initialLoading = false.obs;
  RxBool loading = false.obs;
  RxBool searchFailed = false.obs;
  RxBool seeClosed = false.obs;

  RxInt searchFilter = 0.obs;
  RxList<bool> searchCategoryTapList = [false, false, false].obs;
  // 0: 전체, 1: 내 관심 카테고리, 2: 상세 카테고리
  RxInt resultListStartIndex = 0.obs;
  RxList searchCategoryList = [].obs;
  RxList searchResultList = [].obs;

  @override
  void onInit() {
    searchFieldFocus = FocusNode();
    resultListScrollController.addListener(onResultListScroll);
    searchFilter.listen(onSearchFilterChanged);
    super.onInit();
  }

  @override
  void onClose() {
    resultListScrollController.removeListener(onResultListScroll);
    searchFieldFocus.dispose();
    super.onClose();
  }

  void onSearchFilterChanged(int val) async {
    if (val == 0) {
      searchCategoryList.value = [];
    } else if (val == 1) {
      if (AuthController.to.isAuthenticated.value) {
        await AuthController.to.getUserInfoIfEmpty();
        searchCategoryList.clear();
        searchCategoryList
            .addAll(AuthController.to.userInfo['interest_categories']);
      } else {
        searchFilter.value = 0;
        Get.toNamed('/auth');
      }
    } else {}
  }

  void onSeeClosedChanged(bool val) async {
    seeClosed.value = val;
  }

  void onDetailFilterCompletePressed() async {
    initialLoading.value = true;
    Get.back();
    searchResultList.clear();
    await search();
    initialLoading.value = false;
  }

  void onResultListScroll() {
    if (resultListScrollController.position.extentAfter < 300 &&
        !loading.value) {
      resultListStartIndex.value = searchResultList.length;
    }
    update();
  }

  void onResultListLoadMore() async {
    if (searchResultList.length >= 20) {
      loading.value = true;
      await search();
      loading.value = false;
    }
    resultListRefreshController.loadComplete();
  }

  void reset() {
    searchTextController.clear();
    initialLoading.value = false;
    loading.value = false;
    searchFailed.value = false;

    searchFilter.value = 0;
    searchCategoryTapList.value = [false, false, false];
    resultListStartIndex.value = 0;
    searchCategoryList.clear();
    searchResultList.clear();
  }

  Future<void> search() async {
    if (searchTextController.text.isNotEmpty) {
      initialLoading.value = true;
      resultListStartIndex.value = 0;
      searchResultList.clear();

      var resData = await CommunityApiService.search(
          resultListStartIndex.value,
          searchTextController.text,
          seeClosed.value,
          searchFilter.value,
          searchFilter.value == 0 ? null : searchCategoryList.toList());
      searchResultList.addAll(resData);
      if (searchResultList.isEmpty) {
        searchFailed.value = true;
      }
      initialLoading.value = false;
    }
  }
}
