import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qnpick/core/controllers/app_controller.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/services/community_api_service.dart';
import 'package:qnpick/helpers/utils.dart';
import 'package:qnpick/ui/pages/initial_help_page.dart';

class MainHomeController extends GetxController {
  static MainHomeController to = Get.find<MainHomeController>();
  final storage = const FlutterSecureStorage();

  int searchCategory =
      1; //0: 게시판, 1: HOT 게시판, 2: 자유 게시판, 3: 정보 게시판, 4: Q&A, 5: HOT Q&A, 6: 미해결 Q&A, 7: 해결 Q&A
  RxBool loading = false.obs;
  RxList<bool> searchCategoryTapList = [false, false, false].obs;
  RxInt searchFilter = 0.obs;
  RxBool seeClosed = false.obs;
  RxList<dynamic> searchCategoryList = <dynamic>[].obs;

  RefreshController refreshController = RefreshController();
  PageController textQuestionPageController = PageController();
  PageController pictureQuestionPageController = PageController();
  RxInt textQuestionPageIndex = 0.obs;
  RxInt pictureQuestionPageIndex = 0.obs;
  RxList<dynamic> questionList = [].obs;
  RxList<dynamic> textQuestionList = [].obs;
  RxList<dynamic> imageQuestionList = [].obs;
  RxList<dynamic> videoQuestionList = [].obs;

  @override
  void onInit() async {
    super.onInit();
    searchFilter.listen(onSearchFilterChanged);
    seeClosed.listen(onSeeClosedChanged);
    if (await storage.read(key: 'initial') != 'false') {
      Future.delayed(Duration.zero, () {
        Get.dialog(
          const InitialHelpPage(),
          useSafeArea: false,
        );
      });
      storage.write(key: 'initial', value: 'false');
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void reset() {
    textQuestionList.value = [];
    imageQuestionList.value = [];
    videoQuestionList.value = [];
  }

  void onRefresh() async {
    searchFilter.value = 2;
    searchCategoryList.value = getRandomCategories();
    getHomeQuestionPreview();
    refreshController.refreshCompleted();
  }

  void onSeeClosedChanged(bool val) async {
    getHomeQuestionPreview();
  }

  void onSearchFilterChanged(int val) async {
    if (val == 0) {
      searchCategoryList.value = [];
      getHomeQuestionPreview();
      Get.back();
    } else if (val == 1) {
      Get.back();
      if (AuthController.to.isAuthenticated.value) {
        await AuthController.to.getUserInfoIfEmpty();
        searchCategoryList.clear();
        searchCategoryList
            .addAll(AuthController.to.userInfo['interest_categories']);
        getHomeQuestionPreview();
      } else {
        searchFilter.value = 0;
        Get.toNamed('/auth');
      }
    } else {
      searchCategoryList.value = getRandomCategories();
      getHomeQuestionPreview();
      Get.back();
    }
    print(searchCategoryList);
  }

  void setLoading(bool val) {
    loading.value = val;
    update();
  }

  Future<void> getHomeQuestionPreview() async {
    loading.value = true;
    var resData = await CommunityApiService.getHomeQuestionPreview(
        seeClosed.value,
        searchFilter.value,
        searchFilter.value == 0 ? null : searchCategoryList.toList());
    textQuestionList.value = resData['text_questions'];
    imageQuestionList.value = resData['image_questions'];
    videoQuestionList.value = resData['video_questions'];
    loading.value = false;
    AppController.to.getAndPostFcmToken();
  }
}
