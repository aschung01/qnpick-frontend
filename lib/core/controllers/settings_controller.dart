import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  static SettingsController to = Get.find<SettingsController>();

  // late FocusNode searchFieldFocus;
  bool loading = false;

  @override
  void onInit() {
    // searchFieldFocus = FocusNode();
    super.onInit();
  }

  @override
  void onClose() {
    // searchFieldFocus.dispose();
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
