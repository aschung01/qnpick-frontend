import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController
    with GetTickerProviderStateMixin {
  static ProfileController to = Get.find<ProfileController>();

  late TabController profileTabController;
  bool loading = false;

  @override
  void onInit() {
    profileTabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    profileTabController.dispose();
    super.onClose();
  }

  void setLoading(bool val) {
    loading = val;
    update();
  }

  void reset() {
    update();
  }
}
