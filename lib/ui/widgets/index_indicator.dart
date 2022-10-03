import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';

class IndexIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalLength;
  final Color? color;
  const IndexIndicator({
    Key? key,
    required this.currentIndex,
    required this.totalLength,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalLength,
        (index) {
          return Container(
            height: 6,
            width: 6,
            margin: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == currentIndex
                  ? (color ?? darkPrimaryColor)
                  : lightGrayColor,
            ),
          );
        },
      ),
    );
  }
}
