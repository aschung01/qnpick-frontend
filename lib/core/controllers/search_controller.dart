import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  static SearchController to = Get.find<SearchController>();

  TextEditingController searchTextController = TextEditingController();
  late FocusNode searchFieldFocus;
  int searchCategory =
      0; //0: 게시판, 1: HOT 게시판, 2: 자유 게시판, 3: 정보 게시판, 4: Q&A, 5: HOT Q&A, 6: 미해결 Q&A, 7: 해결 Q&A
  bool loading = false;
  List<dynamic>? searchResultList;

  @override
  void onInit() {
    searchFieldFocus = FocusNode();
    super.onInit();
  }

  @override
  void onClose() {
    searchFieldFocus.dispose();
    super.onClose();
  }

  void setLoading(bool val) {
    loading = val;
    update();
  }

  void updateSearchCategory(int val) {
    searchCategory = val;
    update();
  }

  void reset() {
    searchResultList = null;
    searchTextController.clear();
    update();
  }

  Future<void> search() async {
    setLoading(true);
    // var resData = await CommunityApiService.search(
    //     searchCategory, searchTextController.text);
    // searchResultList = resData;
    setLoading(false);
  }
}
