import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/core/controllers/store_controller.dart';
import 'package:qnpick/core/services/user_api_service.dart';
import 'package:qnpick/ui/widgets/custom_snackbar.dart';

class RegisterInfoController extends GetxController {
  static RegisterInfoController to = Get.find<RegisterInfoController>();

  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController inviteUsernameController = TextEditingController();

  RxInt page = 0.obs;
  RxBool loading = false.obs;
  RxBool userInfoExists = false.obs;
  RxBool isUsernameValid = false.obs;
  RxBool isUsernameRegexValid = false.obs;
  RxBool isUsernameAvailable = false.obs;
  RxBool doesUsernameExist = false.obs;

  RxList<int> interestCategoryList = <int>[].obs;

  // Api control
  Future<void> checkUserInfo() async {
    loading.value = true;
    userInfoExists.value = await UserApiService.checkUserInfo();
    loading.value = false;
  }

  Future<void> checkAvailableUsername() async {
    isUsernameAvailable.value =
        await UserApiService.checkUsernameAvailable(usernameController.text);
  }

  Future<void> checkExistingUser() async {
    doesUsernameExist.value = !await UserApiService.checkUsernameAvailable(
        inviteUsernameController.text);
  }

  Future<bool> registerUserInfo() async {
    var success = await UserApiService.registerUserInfo(
      usernameController.text,
      inviteUsernameController.text.isNotEmpty
          ? inviteUsernameController.text
          : null,
      interestCategoryList.isEmpty ? null : interestCategoryList.toList(),
    );
    if (success) {
      Get.showSnackbar(PointSnackbar(
        text: "+ 3,000 QP",
      ));
      await StoreController.to.getPointStatus();
      StoreController.to.rebuild = true;
      StoreController.to.pointStatus.refresh();
      StoreController.to.update();
    }
    return success;
  }
}
