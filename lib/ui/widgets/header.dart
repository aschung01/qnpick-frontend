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
            leadingWidth: 70,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onPressed,
                child: Row(
                  children: const [
                    Icon(Icons.arrow_back_ios_new_rounded,
                        color: darkPrimaryColor),
                    Text(
                      '뒤로',
                      style: TextStyle(
                        fontSize: 14,
                        color: darkPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: color,
            actions: actions,
          )
        : AppBar(
            leadingWidth: 70,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onPressed,
                child: Row(
                  children: const [
                    Icon(Icons.arrow_back_ios_new_rounded,
                        color: darkPrimaryColor),
                    Text(
                      '뒤로',
                      style: TextStyle(
                        fontSize: 14,
                        color: darkPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            title: Text(
              title!,
              style: const TextStyle(
                color: darkPrimaryColor,
                fontSize: 16,
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
