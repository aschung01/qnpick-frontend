import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:qnpick/core/controllers/app_controller.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/home_navigation_controller.dart';
import 'package:qnpick/core/controllers/map_controller.dart';
import 'package:qnpick/core/controllers/profile_controller.dart';
import 'package:qnpick/core/controllers/store_controller.dart';
import 'package:qnpick/core/services/amplify_service.dart';
import 'package:qnpick/helpers/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

bool _initialLinkIsHandled = false;

class DeepLinkController extends GetxController {
  String? _initialLink = '/';
  String? _latestLink;
  Object? _err;

  StreamSubscription? _sub;

  @override
  void onInit() {
    _handleIncomingLinks();
    _handleInitialLink();
    super.onInit();
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  void _updateInitialLink(String? link) {
    _initialLink = link;
    update();
  }

  void _updateLatestLink(String? link) {
    _latestLink = link;
    update();
  }

  void _updateErr(Object? err) {
    _err = err;
    update();
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks() {
    // It will handle app links while the app is already started - be it in
    // the foreground or in the background.
    _sub = linkStream.listen(
      (String? link) async {
        print(link);
        if (!link!.contains('kakao')) {
          if (link.contains('code=') && link.contains("qnpick")) {
            int index = link.indexOf('?');
            int codeIndex = link.indexOf('code=') + 'code='.length;
            String parsedLink = '/' + link.substring("qnpick://".length, index);
            String authCode = link.substring(codeIndex, codeIndex + 36);
            bool success =
                await AmplifyService.getAuthTokensWithAuthCode(authCode);
            print('got link: $parsedLink');
            print(success);
            _updateLatestLink(parsedLink);
            _updateErr(null);
            if (success) {
              if (GetPlatform.isIOS) {
                await UrlLauncher.webView.close();
              }
              if (parsedLink == '/home') {
                await AuthController.to.checkAuthentication();
                if (AuthController.to.isAuthenticated.value) {
                  MapController.to.postUserLocation();
                  Future.delayed(Duration.zero, () async {
                    await AuthController.to.getUserInfo();
                    await ProfileController.to.getUserCreatedQuestions();
                    await ProfileController.to.getUserAnsweredQuestions();
                    ProfileController.to.initialLoading.value = false;
                    AuthController.to.userInfo.refresh();
                    await StoreController.to.getPointStatus();
                    StoreController.to.rebuild = true;
                    StoreController.to.pointStatus.refresh();
                    StoreController.to.update();
                    await AppController.to.getAndPostFcmToken();
                  });
                }
                HomeNavigationController.to.currentIndex = 0;
                HomeNavigationController.to.rebuild = true;
                HomeNavigationController.to.update();

                Get.until((route) => Get.currentRoute == '/home');
              } else {
                Get.toNamed(parsedLink);
              }
            }
          } else {
            int index = link.indexOf('qnpick://') + 'qnpick://'.length;
            String parsedLink = '/' + link.substring(index);
            if (GetPlatform.isIOS) {
              await UrlLauncher.webView.close();
            }
            if (parsedLink == '/home') {
              await AuthController.to.checkAuthentication();
              if (AuthController.to.isAuthenticated.value) {
                MapController.to.postUserLocation();
                Future.delayed(Duration.zero, () async {
                  await AuthController.to.getUserInfo();
                  await ProfileController.to.getUserCreatedQuestions();
                  await ProfileController.to.getUserAnsweredQuestions();
                  ProfileController.to.initialLoading.value = false;
                  AuthController.to.userInfo.refresh();
                  StoreController.to.rebuild = true;
                  StoreController.to.pointStatus.refresh();
                  await AppController.to.getAndPostFcmToken();
                });
              }
              HomeNavigationController.to.currentIndex = 0;
              HomeNavigationController.to.rebuild = true;
              HomeNavigationController.to.update();

              Get.until((route) => Get.currentRoute == '/home');
            } else {
              Get.toNamed(parsedLink);
            }
          }
        } else {
          Get.dialog(Text('$link'));
          return;
        }
      },
      onError: (Object err) {
        print('got err: $err');
        _updateInitialLink(null);
        _updateLatestLink(null);
        if (err is FormatException) {
          _updateErr(err);
        } else {
          _updateErr(null);
        }
      },
    );
  }

  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _handleInitialLink() async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a weidget that will be disposed of (ex. a navigation route change).
    if (!_initialLinkIsHandled) {
      _initialLinkIsHandled = true;
      print('_handleInitialLink called');
      try {
        final link = await getInitialLink();
        int? index;
        String? parsedLink;
        if (link == null) {
          print('no initial link');
        } else {
          index = link.indexOf('?');
          parsedLink = '/' + link.substring("qnpick://".length, index);
          print('got initial link: $parsedLink');
        }
        _updateInitialLink(parsedLink);
        print(_initialLink ?? _latestLink ?? '/');
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial link');
      } on FormatException catch (err) {
        print('malformed initial link');
        _updateErr(err);
      }
    }
  }
}
