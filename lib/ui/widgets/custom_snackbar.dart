import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qnpick/constants/constants.dart';

class BottomSnackbar extends GetSnackBar {
  final String text;
  final TextAlign align;

  BottomSnackbar({
    Key? key,
    required this.text,
    this.align = TextAlign.start,
  }) : super(
          key: key,
          messageText: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
            ),
            textAlign: align,
          ),
          borderRadius: 10,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          duration: const Duration(seconds: 2),
          isDismissible: false,
          backgroundColor: darkPrimaryColor.withOpacity(0.8),
        );
}

class PointSnackbar extends GetSnackBar {
  final String text;
  final double? width;

  PointSnackbar({
    Key? key,
    required this.text,
    this.width,
  }) : super(
          key: key,
          icon: const Icon(
            PhosphorIcons.coinsBold,
            color: darkPrimaryColor,
          ),
          shouldIconPulse: false,
          messageText: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: darkPrimaryColor,
              fontFamily: 'GodoM',
              fontWeight: FontWeight.bold,
            ),
          ),
          snackStyle: SnackStyle.FLOATING,
          borderRadius: 50,
          margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
          maxWidth: width ?? (text.length * 12 + 50),
          duration: const Duration(seconds: 2),
          isDismissible: false,
          snackPosition: SnackPosition.TOP,
          backgroundColor: softYellowColor,
        );
}

class ErrorSnackbar extends GetSnackBar {
  final String text;

  ErrorSnackbar({
    Key? key,
    required this.text,
  }) : super(
          key: key,
          icon: const Icon(
            PhosphorIcons.warningCircle,
            color: Colors.white,
          ),
          // shouldIconPulse: false,
          messageText: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          snackStyle: SnackStyle.FLOATING,
          borderRadius: 10,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          duration: const Duration(seconds: 2),
          isDismissible: false,
          overlayBlur: 3,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: brightSecondaryColor,
        );
}
