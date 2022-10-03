import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/app_controller.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:shimmer/shimmer.dart';

const String _logoText = '큐앤픽';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      List _auth = await Future.wait(
        [
          Future.delayed(const Duration(milliseconds: 2000), () {
            Get.offAllNamed('/home');
            return true;
          }),
          Future.delayed(
            const Duration(milliseconds: 1000),
            () async => await AuthController.to.asyncMethod(),
          ),
        ],
      );
      if (!_auth.every((e) => e == true)) {
        Get.toNamed('/register_info');
      }
    });

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: FutureBuilder(
            future: Future.delayed(
              const Duration(milliseconds: 1400),
              () {
                return true;
              },
            ),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return Shimmer.fromColors(
                  baseColor: brightPrimaryColor,
                  highlightColor: Colors.white.withOpacity(0.3),
                  period: const Duration(milliseconds: 1000),
                  child: const Text(
                    _logoText,
                    style: TextStyle(
                      color: brightPrimaryColor,
                      fontSize: 50,
                      fontFamily: 'Jalnan',
                    ),
                  ),
                );
              } else {
                return AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      _logoText,
                      speed: const Duration(milliseconds: 300),
                      textStyle: const TextStyle(
                        color: brightPrimaryColor,
                        fontSize: 50,
                        fontFamily: 'Jalnan',
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          // child: Text(
          //   _logoText,
          //   style: TextStyle(
          //     color: brightPrimaryColor,
          //     fontSize: 50,
          //     fontFamily: 'Jalnan',
          //   ),
          // ),
        ),
      ),
    );
  }
}
