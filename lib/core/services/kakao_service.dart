import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:qnpick/constants/constants.dart';

class KakaoService {
  static _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode: authCode);
      Get.back();
      var tokenManger = DefaultTokenManager();
      tokenManger.setToken(token);
      print(token.toJson());
      return token.toJson();
    } catch (e) {
      print(e);
    }
  }

  static loginWithKakao() async {
    try {
      String authCode = await AuthCodeClient.instance.request();
      var token = await _issueAccessToken(authCode);
      return token.map((key, value) => MapEntry(key, value?.toString()));
    } catch (e) {
      print(e);
    }
  }

  static loginWithKakaoTalk() async {
    try {
      String authCode = await AuthCodeClient.instance.requestWithTalk();
      var token = await _issueAccessToken(authCode);
      return token.map((key, value) => MapEntry(key, value?.toString()));
    } catch (e) {
      print(e);
    }
  }

  static void logoutKakaoTalk() async {
    try {
      var code = await UserApi.instance.logout();
      print(code.toString());
    } catch (e) {
      print(e);
    }
  }

  static void unlinkKakaoTalk() async {
    try {
      var code = await UserApi.instance.unlink();
      print(code.toString());
    } catch (e) {
      print(e);
    }
  }
}
