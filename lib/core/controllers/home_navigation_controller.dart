import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';

class HomeNavigationController extends GetxController {
  static HomeNavigationController to = Get.find<HomeNavigationController>();
  DateTime timeStamp = DateTime.now();
  Duration timeGap = Duration.zero;
  int currentIndex = 0;
  bool rebuild = false;

  void onIconTap(int index) {
    currentIndex = index;
    update();
  }

  void updateTimeStamp(DateTime time) {
    timeStamp = time;
    update();
  }

  Future<bool> onBackPressed() async {
    updateTimeGap();
    updateTimeStamp(DateTime.now());
    if (timeGap >= const Duration(seconds: 2)) {
      Get.showSnackbar(
        GetSnackBar(
          messageText: const Text(
            '뒤로 가기를 다시 눌러 앱을 종료하세요',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          borderRadius: 10,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          backgroundColor: darkPrimaryColor.withOpacity(0.8),
        ),
      );
      return false;
    } else {
      return true;
    }
  }

  void updateTimeGap() {
    timeGap = DateTime.now().difference(timeStamp);
    update();
  }
}
