import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qnpick/core/services/community_api_service.dart';

class ProfileController extends GetxController
    with GetTickerProviderStateMixin {
  static ProfileController to = Get.find<ProfileController>();

  RxBool loading = false.obs;
  RxBool initialLoading = true.obs;

  late TabController profileTabController;
  ScrollController userCreatedQuestionsScrollController = ScrollController();
  ScrollController userAnsweredQuestionsScrollController = ScrollController();
  late RefreshController userCreatedQuestionsRefreshController;
  late RefreshController userAnsweredQuestionsRefreshController;

  RxInt userCreatedQuestionsStartIndex = 0.obs;
  RxInt userAnsweredQuestionsStartIndex = 0.obs;
  RxList userCreatedQuestions = [].obs;
  RxList userAnsweredQuestions = [].obs;

  @override
  void onInit() {
    super.onInit();
    profileTabController = TabController(length: 2, vsync: this);
    userCreatedQuestionsScrollController
        .addListener(onUserCreatedQuestionsScroll);
    userAnsweredQuestionsScrollController
        .addListener(onUserAnsweredQuestionsScroll);
    userCreatedQuestionsRefreshController = RefreshController();
    userAnsweredQuestionsRefreshController = RefreshController();
  }

  @override
  void onClose() {
    profileTabController.dispose();
    userCreatedQuestionsScrollController
        .removeListener(onUserCreatedQuestionsScroll);
    userAnsweredQuestionsScrollController
        .removeListener(onUserAnsweredQuestionsScroll);
    userCreatedQuestionsScrollController.dispose();
    userAnsweredQuestionsScrollController.dispose();
    userCreatedQuestionsRefreshController.dispose();
    userAnsweredQuestionsRefreshController.dispose();
    super.onClose();
  }

  void onUserCreatedQuestionsScroll() {
    if (userCreatedQuestionsScrollController.position.extentAfter < 300 &&
        !loading.value) {
      userCreatedQuestionsStartIndex.value = userCreatedQuestions.length;
    }
    update();
  }

  void onUserAnsweredQuestionsScroll() {
    if (userAnsweredQuestionsScrollController.position.extentAfter < 300 &&
        !loading.value) {
      userAnsweredQuestionsStartIndex.value = userAnsweredQuestions.length;
    }
    update();
  }

  void onUserCreatedQuestionsLoadMore() async {
    loading.value = true;
    await getUserCreatedQuestions();
    userCreatedQuestionsRefreshController.loadComplete();
    loading.value = false;
  }

  void onUserAnsweredQuestionsLoadMore() async {
    loading.value = true;
    await getUserAnsweredQuestions();
    userAnsweredQuestionsRefreshController.loadComplete();
    loading.value = false;
  }

  void reset() {
    loading.value = false;
    initialLoading.value = true;
    userCreatedQuestionsStartIndex.value = 0;
    userAnsweredQuestionsStartIndex.value = 0;
    userCreatedQuestions.clear();
    userAnsweredQuestions.clear();
  }

  Future<void> getUserCreatedQuestions() async {
    var resData = await CommunityApiService.getUserCreatedQuestionPreview(
        userCreatedQuestionsStartIndex.value);
    userCreatedQuestions.addAll(resData);
  }

  Future<void> getUserAnsweredQuestions() async {
    var resData = await CommunityApiService.getUserAnsweredQuestionPreview(
        userAnsweredQuestionsStartIndex.value);
    userAnsweredQuestions.addAll(resData);
  }
}
