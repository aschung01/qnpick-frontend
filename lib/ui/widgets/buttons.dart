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
  final Widget? icon;
  final bool leading;
  final double? width;
  final double? height;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final EdgeInsets? padding;

  const TextActionButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.fontSize = 14,
    this.textColor = Colors.black,
    this.overlayColor,
    this.activated,
    this.isUnderlined = true,
    this.icon,
    this.leading = false,
    this.width,
    this.height = 40,
    this.fontWeight,
    this.fontFamily,
    this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
      padding: MaterialStateProperty.all(padding),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    Widget text = Text(
      buttonText,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
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
        child: icon == null
            ? underlinedText
            : Row(
                children: [
                  if (leading) icon!,
                  underlinedText,
                  if (!leading) icon!,
                ],
              ),
        style: style,
      ),
    );
  }
}

class SizeAccentTextButton extends StatefulWidget {
  final String buttonText;
  final Function() onTap;
  final double? fontSize;
  final Color? textColor;

  const SizeAccentTextButton({
    Key? key,
    required this.buttonText,
    required this.onTap,
    this.fontSize = 16,
    this.textColor = deepGrayColor,
  }) : super(key: key);

  @override
  State<SizeAccentTextButton> createState() => _SizeAccentTextButtonState();
}

class _SizeAccentTextButtonState extends State<SizeAccentTextButton> {
  bool tapDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          tapDown = true;
        });
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          tapDown = false;
        });
      },
      onTapCancel: () {
        setState(() {
          tapDown = false;
        });
      },
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            widget.buttonText,
            style: 
                TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: tapDown ? FontWeight.bold : FontWeight.normal,
                  color: widget.textColor,
                ),
          ),
        ),
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

class ChipButton extends StatelessWidget {
  final Function()? onPressed;
  final String label;
  final bool activated;
  const ChipButton({
    Key? key,
    this.onPressed,
    required this.label,
    required this.activated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              activated ? brightPrimaryColor : Colors.white),
          overlayColor: MaterialStateProperty.all(activated
              ? Colors.white.withOpacity(0.2)
              : brightPrimaryColor.withOpacity(0.1)),
          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          )),
          side: activated
              ? null
              : MaterialStateProperty.all(
                  const BorderSide(color: deepGrayColor)),
          elevation: MaterialStateProperty.all(0),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: activated ? Colors.white : deepGrayColor,
            fontWeight: activated ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
