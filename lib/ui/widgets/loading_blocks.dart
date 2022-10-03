import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class LoadingChips extends StatelessWidget {
  const LoadingChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Shimmer.fromColors(
        child: Row(
          children: const [
            Chip(
              label: SizedBox(
                width: 50,
                height: 30,
              ),
              backgroundColor: backgroundColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Chip(
                label: SizedBox(
                  width: 40,
                  height: 30,
                ),
                backgroundColor: backgroundColor,
              ),
            ),
            Chip(
              label: SizedBox(
                width: 60,
                height: 30,
              ),
              backgroundColor: backgroundColor,
            ),
          ],
        ),
        baseColor: backgroundColor,
        highlightColor: Colors.white.withOpacity(0.3),
      ),
    );
  }
}

class LoadingBlock extends StatelessWidget {
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  const LoadingBlock({
    Key? key,
    this.height = 100,
    this.width,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: backgroundColor,
      highlightColor: Colors.white.withOpacity(0.3),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          color: backgroundColor,
        ),
        child: SizedBox(
          height: height,
          width: width ?? context.width - 40,
        ),
      ),
    );
  }
}

class LoadingMiniBlock extends StatelessWidget {
  final double height;
  const LoadingMiniBlock({Key? key, this.height = 172}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: backgroundColor,
      highlightColor: Colors.white.withOpacity(0.3),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: backgroundColor,
        ),
        child: SizedBox(
          height: height,
          width: context.width / 2 - 25,
        ),
      ),
    );
  }
}

class LoadingMiniImage extends StatelessWidget {
  const LoadingMiniImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: backgroundColor,
      highlightColor: Colors.white.withOpacity(0.3),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: backgroundColor,
        ),
        child: SizedBox(
          height: 100,
          width: context.width / 2 - 25,
        ),
      ),
    );
  }
}
