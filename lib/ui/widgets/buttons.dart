import 'package:flutter/material.dart';
import 'package:qnpick/constants/constants.dart';

class TextActionButton extends StatelessWidget {
  final String buttonText;
  final void Function() onPressed;
  final double? fontSize;
  final Color? textColor;
  final Color? overlayColor;
  final bool? activated;
  final bool? isUnderlined;
  final Widget? leading;
  final double? width;
  final double? height;
  final FontWeight? fontWeight;

  const TextActionButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.fontSize = 14,
    this.textColor = Colors.black,
    this.overlayColor,
    this.activated,
    this.isUnderlined = true,
    this.leading,
    this.width,
    this.height = 40,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      overlayColor: MaterialStateProperty.all(
          overlayColor ?? brightPrimaryColor.withOpacity(0.1)),
      minimumSize: MaterialStateProperty.all(Size.zero),
      padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    Widget text = Text(
      buttonText,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: (activated != null ? activated! : true)
            ? (textColor ?? Colors.black)
            : lightGrayColor,
        textBaseline: TextBaseline.ideographic,
        height: 1.0,
      ),
    );

    Widget underlinedText = isUnderlined!
        ? DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: (activated != null ? activated! : true)
                      ? (textColor ?? Colors.black)
                      : lightGrayColor,
                  width: 0.5,
                ),
              ),
            ),
            child: text)
        : text;

    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: (activated == null || activated!) ? onPressed : null,
        child: leading == null
            ? underlinedText
            : Row(
                children: [
                  leading!,
                  underlinedText,
                ],
              ),
        style: style,
      ),
    );
  }
}

class ElevatedActionButton extends StatelessWidget {
  final String buttonText;
  final dynamic Function()? onPressed;
  final bool? activated;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? overlayColor;
  final Color? disabledColor;
  final TextStyle? textStyle;
  final double? borderRadius;
  final BorderSide? borderSide;
  const ElevatedActionButton({
    Key? key,
    required this.buttonText,
    required dynamic Function() this.onPressed,
    this.activated,
    this.height = 60,
    this.width = 220,
    this.backgroundColor = brightPrimaryColor,
    this.overlayColor,
    this.disabledColor = lightGrayColor,
    this.borderRadius = 30,
    this.borderSide,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return disabledColor ?? deepGrayColor;
          }
          return backgroundColor!; // Use the component's default.
        },
      ),
      overlayColor: MaterialStateProperty.all(overlayColor),
      minimumSize: MaterialStateProperty.all(const Size(250, 50)),
      textStyle: MaterialStateProperty.all(const TextStyle(
        fontSize: 16,
      )),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
      )),
      side: borderSide != null ? MaterialStateProperty.all(borderSide) : null,
      elevation: MaterialStateProperty.all(0),
    );

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            buttonText,
            style: textStyle ??
                TextStyle(
                  color: (activated != null ? activated! : true)
                      ? ((int.parse(
                                  backgroundColor.toString().substring(10, 16),
                                  radix: 16) <
                              int.parse('800000', radix: 16))
                          ? Colors.white
                          : deepGrayColor)
                      : lightGrayColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        onPressed: (activated == null || activated!) ? onPressed : null,
        style: style,
      ),
    );
  }
}
