import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/ui/widgets/svg_icons.dart';

class HomeNavigationBar extends StatelessWidget {
  final double bottomPadding;
  final double height;
  final int currentIndex;
  final void Function(int) onIconTap;
  const HomeNavigationBar({
    Key? key,
    required this.bottomPadding,
    required this.height,
    required this.currentIndex,
    required this.onIconTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _getNavigationBarItem(int index) {
      late Widget icon;
      late String text;

      switch (index) {
        case 0:
          icon = HomeIcon(colored: currentIndex == index);
          text = '홈';
          break;
        case 1:
          icon = PointIcon(colored: currentIndex == index);
          text = '포인트';
          break;
        case 2:
          icon = ProfileIcon(colored: currentIndex == index);
          text = '프로필';
          break;
        default:
          break;
      }
      return SizedBox(
        width: (context.width - 20) / 3,
        // width: 60,
        height: 60,
        child: IconButton(
          splashRadius: 85,
          padding: EdgeInsets.zero,
          onPressed: () => onIconTap(index),
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  text,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 12,
                    color: currentIndex == index
                        ? brightPrimaryColor
                        : darkPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffFAFAFA),
      ),
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(bottom: bottomPadding),
      height: height,
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (index) => _getNavigationBarItem(index),
            ),
          ),
        ),
      ),
    );
  }
}
