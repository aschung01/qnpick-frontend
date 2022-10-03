import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/app_controller.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/home_navigation_controller.dart';
import 'package:qnpick/core/controllers/kakao_controller.dart';
import 'package:qnpick/core/controllers/profile_controller.dart';
import 'package:qnpick/core/controllers/register_info_controller.dart';
import 'package:qnpick/core/controllers/store_controller.dart';
import 'package:qnpick/core/services/amplify_service.dart';
import 'package:qnpick/core/services/kakao_service.dart';
import 'package:qnpick/helpers/url_launcher.dart';
import 'package:qnpick/ui/widgets/buttons.dart';
import 'package:qnpick/ui/widgets/svg_icons.dart';

const String _logoText = '큐앤픽';

const String _kakaoLoginButtonText = '카카오 로그인';
const String _appleLoginButtonText = 'Apple로 로그인';
const String _googleLoginButtonText = 'Google 계정으로 로그인';
final Color _kakaoLoginTextColor = Colors.black.withOpacity(0.85);
final Color _googleLoginTextColor = Colors.black.withOpacity(0.54);

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  Future<void> _onKakaoLoginPressed() async {
    dynamic accessToken;
    late var token;

    EasyLoading.show();

    if (KakaoController.to.isKakaoInstalled) {
      token = await KakaoService.loginWithKakaoTalk();
      accessToken = token['access_token']!.toString();
    } else {
      token = await KakaoService.loginWithKakao();
      accessToken = token['access_token'];
    }
    inspect(token);
    bool success = await AmplifyService.signUserInWithKakaoLogin(accessToken);
    print('success:');
    print(success);
    if (success) {
      await RegisterInfoController.to.checkUserInfo();
      EasyLoading.dismiss();
      print('userInfoExists');
      print(RegisterInfoController.to.userInfoExists.value);
      if (RegisterInfoController.to.userInfoExists.value) {
        Get.until((route) => Get.currentRoute == '/home');
        Future.delayed(
          Duration.zero,
          () async {
            if (AuthController.to.isAuthenticated.value) {
              await AuthController.to.getUserInfoIfEmpty();
              if (ProfileController.to.initialLoading.isTrue) {
                await ProfileController.to.getUserCreatedQuestions();
                await ProfileController.to.getUserAnsweredQuestions();
                ProfileController.to.initialLoading.value = false;
                ProfileController.to.initialLoading.refresh();
                AuthController.to.userInfo.refresh();
                await StoreController.to.getPointStatus();
                StoreController.to.rebuild = true;
                StoreController.to.pointStatus.refresh();
                StoreController.to.update();
                await AppController.to.getAndPostFcmToken();
              }
            }
          },
        );
        Get.back();
      } else {
        inspect(await AuthController.to.storage.readAll());
        Get.until((route) => Get.currentRoute == '/home');
        Get.toNamed('/register_info');
      }
    } else {
      EasyLoading.dismiss();
    }
  }

  void _onSignInLaterPressed() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                _logoText,
                style: TextStyle(
                  color: brightPrimaryColor,
                  fontSize: 50,
                  fontFamily: 'Jalnan',
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 60, bottom: 10),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '글을 작성하거나 답변을 남기려면 로그인하세요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: darkPrimaryColor,
                    ),
                  ),
                ),
              ),
              const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '가장 빠르고 효율적인 궁금증 해결 커뮤니티에 참여하세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: darkPrimaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60, bottom: 10),
                child: AppleLoginButton(
                  onPressed: () => UrlLauncher.launchInApp(
                    AmplifyService.getSocialLoginUrl('SignInWithApple'),
                  ),
                ),
              ),
              KakaoLoginButton(
                onPressed: _onKakaoLoginPressed,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 60),
                child: GoogleLoginButton(
                  onPressed: () => UrlLauncher.launchInApp(
                    AmplifyService.getSocialLoginUrl('Google'),
                  ),
                  // onPressed: () async {
                  //   try {
                  //     var res = await Amplify.Auth.signInWithWebUI(
                  //       provider: AuthProvider.google,
                  //     );
                  //     print(res);
                  //   } on AuthException catch (e) {
                  //     print(e);
                  //   }
                  // },
                ),
              ),
              TextActionButton(
                buttonText: '로그인하지 않고 조금 더 구경할래요 >',
                textColor: deepGrayColor,
                onPressed: _onSignInLaterPressed,
                isUnderlined: false,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      '로그인함으로써 ',
                      style: TextStyle(
                        color: deepGrayColor,
                        fontSize: 14,
                      ),
                    ),
                    TextActionButton(
                      buttonText: '이용약관',
                      textColor: deepGrayColor,
                      fontSize: 14,
                      onPressed: () {
                        UrlLauncher.launchInApp(termsOfUseUrl);
                      },
                    ),
                    const Text(
                      '과 ',
                      style: TextStyle(
                        color: deepGrayColor,
                        fontSize: 14,
                      ),
                    ),
                    TextActionButton(
                      buttonText: '개인정보처리방침',
                      textColor: deepGrayColor,
                      fontSize: 14,
                      onPressed: () {
                        UrlLauncher.launchInApp(privacyPolicyUrl);
                      },
                    ),
                    const Text(
                      '에 동의합니다',
                      style: TextStyle(
                        color: deepGrayColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KakaoLoginButton extends StatelessWidget {
  final Function() onPressed;
  const KakaoLoginButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _style = ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      backgroundColor: MaterialStateProperty.all(kakaoLoginColor),
      elevation: MaterialStateProperty.all(0),
    );

    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: _style,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: KakaoIcon(
                height: 16,
              ),
            ),
            Text(
              _kakaoLoginButtonText,
              style: TextStyle(
                height: 1,
                color: _kakaoLoginTextColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppleLoginButton extends StatelessWidget {
  final Function() onPressed;
  const AppleLoginButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _style = ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      backgroundColor: MaterialStateProperty.all(Colors.black),
      overlayColor: MaterialStateProperty.all(Colors.black),
      elevation: MaterialStateProperty.all(0),
    );

    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: _style,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.only(right: 3),
              child: AppleWhiteIcon(
                height: 50,
                width: 50,
              ),
            ),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _appleLoginButtonText,
                  style: TextStyle(
                    height: 1,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 21.5,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}

class GoogleLoginButton extends StatelessWidget {
  final Function() onPressed;
  const GoogleLoginButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _style = ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      backgroundColor: MaterialStateProperty.all(Colors.white),
      overlayColor: MaterialStateProperty.all(lightGrayColor.withOpacity(0.15)),
      elevation: MaterialStateProperty.all(1),
    );

    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: _style,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(right: 24),
              child: GoogleIcon(
                width: 18,
              ),
            ),
            Text(
              _googleLoginButtonText,
              style: TextStyle(
                height: 1,
                color: _googleLoginTextColor,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
