import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:qnpick/core/controllers/home_navigation_controller.dart';
import 'package:qnpick/core/controllers/register_info_controller.dart';
import 'package:qnpick/core/services/amplify_service.dart';
import 'package:qnpick/core/services/user_api_service.dart';
import 'package:qnpick/helpers/mock_data.dart';
import 'package:qnpick/helpers/parse_jwt.dart';

class AuthController extends GetxController {
  static AuthController to = Get.find<AuthController>();

  FlutterSecureStorage storage = const FlutterSecureStorage();

  RxBool loading = false.obs;
  RxBool isAuthenticated = false.obs;
  RxMap<dynamic, dynamic> userInfo = {}.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void reset() {
    userInfo.value = {};
    update();
  }

  Future<bool> isUserSignedIn() async {
    var state = await Amplify.Auth.fetchAuthSession();
    inspect(state);
    return state.isSignedIn;
  }

  Future<void> checkAuthentication() async {
    var refreshToken = await storage.read(key: 'refresh_token');
    if (!await isUserSignedIn()) {
      var authProvider = await storage.read(key: 'auth_provider');
      if (authProvider == 'Kakao') {
        var _email = await storage.read(key: 'email');
        var _password = await storage.read(key: 'password');
        if (_email != null && _password != null) {
          Amplify.Auth.signIn(username: _email, password: _password);
        }
      }
    }
    isAuthenticated.value = refreshToken != null;
    if (!isAuthenticated.value) {
      userInfo.clear();
    }
    update();
  }

  Future<bool> asyncMethod() async {
    await checkAuthentication();
    // Get.offAllNamed('/home');
    if (isAuthenticated.value) {
      await RegisterInfoController.to.checkUserInfo();
      if (!RegisterInfoController.to.userInfoExists.value) {
        // Get.toNamed('/register_info');
        return false;
      }
    }
    return true;
  }

  Future<dynamic> getAccessToken() async {
    var refreshToken = await storage.read(key: 'refresh_token');
    if (refreshToken != null) {
      var accessToken = await storage.read(key: 'access_token');
      if (parseJwt(accessToken!)["exp"] * 1000 <
              DateTime.now().millisecondsSinceEpoch ||
          (accessToken == null)) {
        print('Access token expired');
        // await AmplifyService.getTokensWithRefreshToken(refreshToken);
        var updatedAccessToken = await storage.read(key: 'access_token');
        print('Access token updated');
        return updatedAccessToken;
      } else {
        return accessToken;
      }
    } else {
      print("refresh token doesn't exist");
      Get.offNamed('/auth');
    }
  }

  Future<dynamic> readIdToken() async {
    var idToken = await storage.read(key: 'id_token');
    if (idToken != null) {
      Map<String, dynamic> data = parseJwt(idToken);
      log(data.toString());
      String cognitoGroup =
          data['cognito:groups'][data['cognito:groups'].length - 1];
      late String authProvider;
      if (data['identities'] != null) {
        print(data['identities'][0]['providerName']);
      }
      print(data['cognito:groups']);
      switch (cognitoGroup) {
        case 'Kakao':
          authProvider = 'Kakao';
          break;
        case 'ap-northeast-2_FHkKRu1Gm_Google':
          authProvider = 'Google';
          break;
        case 'ap-northeast-2_FHkKRu1Gm_SignInWithApple':
          authProvider = 'Apple';
          break;
        default:
          authProvider = cognitoGroup;
          break;
      }
      return {
        'email': data['email'],
        'auth_provider': authProvider,
      };
    } else {
      return;
    }
  }

  Future<void> getUserInfoIfEmpty() async {
    if (isAuthenticated.value && userInfo.isEmpty) {
      var data = await UserApiService.getUserInfo();
      if (data != null) {
        if (data == false) {
          Get.toNamed('/register_info');
        } else {
          userInfo.value = data;
        }
      }
    }
  }

  Future<void> getUserInfo() async {
    if (isAuthenticated.value) {
      var data = await UserApiService.getUserInfo();
      if (data != null) {
        if (data == false) {
          Get.toNamed('/register_info');
        } else {
          userInfo.value = data;
        }
      }
    }
  }
}
