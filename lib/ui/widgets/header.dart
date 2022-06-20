import 'package:flutter/material.dart';
import 'package:qnpick/constants/constants.dart';

class Header extends StatelessWidget {
  final dynamic Function() onPressed;
  final Color? color;
  final String? title;
  final List<Widget>? actions;
  final Widget? icon;

  const Header({
    Key? key,
    required this.onPressed,
    this.color = Colors.transparent,
    this.title,
    this.actions,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return title == null
        ? AppBar(
            leading: IconButton(
              icon: icon ??
                  const Icon(Icons.arrow_back_rounded, color: darkPrimaryColor),
              onPressed: onPressed,
              splashRadius: 25,
            ),
            elevation: 0,
            backgroundColor: color,
            actions: actions,
          )
        : AppBar(
            leading: IconButton(
              splashRadius: 25,
              icon: icon ??
                  const Icon(Icons.arrow_back_rounded, color: darkPrimaryColor),
              onPressed: onPressed,
            ),
            title: Text(
              title!,
              style: const TextStyle(
                color: darkPrimaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: color,
            actions: actions,
          );
  }
}
