import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:qnpick/constants/constants.dart';

const String _logoText = '큐앤픽';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        Get.toNamed('/home');
      },
    );

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            _logoText,
            style: TextStyle(
              color: brightPrimaryColor,
              fontSize: 50,
              fontFamily: 'Jalnan',
            ),
          ),
        ),
      ),
    );
  }
}
