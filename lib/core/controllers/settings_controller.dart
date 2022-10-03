import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/home_navigation_controller.dart';
import 'package:qnpick/core/controllers/profile_controller.dart';
import 'package:qnpick/core/controllers/store_controller.dart';
import 'package:qnpick/core/services/amplify_service.dart';
import 'package:qnpick/core/services/user_api_service.dart';
import 'package:qnpick/helpers/url_launcher.dart';
import 'package:qnpick/ui/widgets/custom_snackbar.dart';

class SettingsController extends GetxController {
  static SettingsController to = Get.find<SettingsController>();

  // late FocusNode searchFieldFocus;
  RxBool loading = false.obs;
  late String appVersion;
  late String buildNumber;

  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  RxBool userInfoExists = false.obs;
  RxBool isUsernameValid = false.obs;
  RxBool isUsernameRegexValid = false.obs;
  RxBool isUsernameAvailable = false.obs;
  RxBool userNotiReception = false.obs;

  RxList interestCategoryList = [].obs;

  @override
  void onInit() async {
    // searchFieldFocus = FocusNode();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    await AuthController.to.getUserInfoIfEmpty();
    userNotiReception.listen((val) {
      postUserNotiReception(val);
    });
    if (AuthController.to.isAuthenticated.value) {
      getUserNotiReception();
    }
    super.onInit();
  }

  @override
  void onClose() {
    // searchFieldFocus.dispose();
    usernameController.dispose();
    super.onClose();
  }

  void reset() {
    loading.value = false;
    usernameController.clear();
    userInfoExists.value = false;
    isUsernameRegexValid.value = false;
    isUsernameAvailable.value = false;
    interestCategoryList.clear();
  }

  String? usernameValidator(String? text) {
    const pattern =
        r'^(?=.{3,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣._\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]]+(?<![_.])$';
    final regExp = RegExp(pattern);
    if (text == null || text.isEmpty) {
      return '닉네임을 입력해주세요';
    } else if (text.length < 3) {
      return '3글자 이상 입력해주세요';
    } else if (text.length > 20) {
      return '20자 이내로 입력해주세요';
    } else if (!regExp.hasMatch(text)) {
      return '닉네임 형식이 올바르지 않습니다';
    } else {
      if (!isUsernameAvailable.value) {
        if (usernameController.text != AuthController.to.userInfo['username'] &&
            !loading.value) {
          return '이미 존재하는 닉네임이에요';
        } else {
          return '현재 닉네임과 동일해요';
        }
      } else {
        return null;
      }
    }
  }

  void onUsernameChanged(String text) async {
    if (usernameController.text.length >= 3 &&
        usernameController.text.length <= 20) {
      loading.value = true;
      await checkAvailableUsername();
      loading.value = false;
    }
    if (formKey.currentState != null) {
      bool isValid = formKey.currentState!.validate();
      isUsernameValid.value = isValid;
    }
  }

  Future<void> checkAvailableUsername() async {
    print(usernameController.text);
    isUsernameAvailable.value =
        await UserApiService.checkUsernameAvailable(usernameController.text);
  }

  Future<void> updateUsername() async {
    EasyLoading.show();
    await checkAvailableUsername();
    if (formKey.currentState != null) {
      bool isValid = formKey.currentState!.validate();
      isUsernameValid.value = isValid;
    }
    if (isUsernameAvailable.value && isUsernameValid.value) {
      var success =
          await UserApiService.updateUsername(usernameController.text);

      if (success) {
        EasyLoading.showSuccess('닉네임이 수정되었습니다');
        AuthController.to.getUserInfo();
        Get.back();
        reset();
      } else {
        EasyLoading.showError('오류가 발생했습니다.\n잠시 후 다시 시도해 주세요');
      }
    }
    EasyLoading.dismiss();
  }

  Future<void> updateInterestCategories() async {
    EasyLoading.show();
    var success = await UserApiService.updateInterestCategories(
        interestCategoryList.toList()..sort());
    if (success) {
      EasyLoading.showSuccess('관심 분야가 수정되었습니다');
      AuthController.to.getUserInfo();
      Get.back();
      reset();
    } else {
      EasyLoading.showError('오류가 발생했습니다.\n잠시 후 다시 시도해 주세요');
    }
    EasyLoading.dismiss();
  }

  Future<void> signOut() async {
    Get.back();
    await AmplifyService.signOut();
    await AuthController.to.checkAuthentication();
    HomeNavigationController.to.currentIndex = 0;
    HomeNavigationController.to.update();
    ProfileController.to.reset();
    StoreController.to.reset();
  }

  Future<void> deleteAccount() async {
    Get.back();
    // var data = await AuthController.to.readIdToken();
    // await AmplifyService.deleteUser(data['email']);
    var success = await UserApiService.deleteAccount();
    if (success) {
      Get.showSnackbar(BottomSnackbar(
        text: '회원 탈퇴가 신청되었습니다.\n며칠 내로 처리가 완료됩니다',
        align: TextAlign.center,
      ));
    }
    await AuthController.to.checkAuthentication();
    HomeNavigationController.to.currentIndex = 0;
    HomeNavigationController.to.update();
    ProfileController.to.reset();
  }

  Future<void> getUserNotiReception() async {
    userNotiReception.value = await UserApiService.getUserNotiReception();
  }

  Future<void> postUserNotiReception(bool val) async {
    await UserApiService.postUserNotiReception(val);
  }

  Future<void> sendFeedbackEmail() async {
    if (emailController.text.isNotEmpty) {
      EasyLoading.show();
      try {
        var success = await UrlLauncher.sendEmail(
          recipent: 'help@qnpick.com',
          subject: '[큐앤픽 문의사항]',
          body: emailController.text,
        );
        if (!success) {
          EasyLoading.showError(
            '연결 가능한 메일 앱이 설치되어 있지 않습니다.\n설치 후 다시 시도해 주세요',
            duration: const Duration(seconds: 2),
          );
        }
      } catch (e) {
        print(e);
        EasyLoading.showError('오류가 발생했습니다.\n잠시 후 다시 시도해 주세요');
      }
      EasyLoading.dismiss();
      emailController.clear();
    }
  }
}
