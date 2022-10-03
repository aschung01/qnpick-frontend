import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/helpers/utils.dart';
import 'package:qnpick/ui/widgets/image_loader.dart';
import 'package:qnpick/ui/widgets/loading_blocks.dart';
import 'package:qnpick/ui/widgets/svg_icons.dart';
import 'package:qnpick/ui/widgets/video_player_container.dart';
import 'package:video_player/video_player.dart';

class InputTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Color? backgroundColor;
  final Widget? icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool? obscureText;
  final bool? isPassword;
  final bool? isPhone;
  final bool? autofocus;

  const InputTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.width = 330,
    this.height = 45,
    this.borderRadius,
    this.backgroundColor = textFieldFillColor,
    this.icon,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.obscureText,
    this.isPassword,
    this.isPhone,
    this.autofocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var phoneNumFormatter = PhoneNumFormatter(
        masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'], separator: '-');
    return SizedBox(
      width: width,
      // height: height,
      child: TextFormField(
        obscureText: obscureText ?? false,
        inputFormatters: isPhone != null && (isPhone ?? false)
            ? [
                phoneNumFormatter,
              ]
            : null,
        autofocus: autofocus ?? true,
        toolbarOptions: const ToolbarOptions(),
        enableSuggestions: !(isPassword ?? false),
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        keyboardType: keyboardType,
        cursorColor: brightPrimaryColor,
        decoration: InputDecoration(
          suffixIcon: icon,
          contentPadding: EdgeInsets.only(
            left: 10,
            bottom: (height ?? 45) / 2,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 20)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: backgroundColor,
          label: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: deepGrayColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final void Function(String) onFieldSubmitted;
  final Function(String)? onChanged;
  const SearchInputField({
    Key? key,
    required this.controller,
    required this.onFieldSubmitted,
    this.onChanged,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(
          left: 0,
          // bottom: 15,
        ),
        border: InputBorder.none,
        hintText: '검색으로 궁금증 해결하기',
        hintStyle: TextStyle(
          fontSize: 16,
          fontFamily: 'GodoM',
          color: lightGrayColor,
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      maxLines: 1,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'GodoM',
        color: darkPrimaryColor,
      ),
    );
  }
}

class TitleInputField extends StatelessWidget {
  final String? hintText;
  final Function(String)? onChanged;
  final TextEditingController controller;
  const TitleInputField({
    Key? key,
    this.hintText = '제목',
    this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      maxLength: 30,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          left: 2,
          bottom: 15,
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: lightGrayColor, width: 0.5),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: lightGrayColor,
            width: 0.5,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: lightGrayColor,
            width: 0.5,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: lightGrayColor,
        ),
      ),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: darkPrimaryColor,
      ),
    );
  }
}

class ContentInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  const ContentInputField({
    Key? key,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(
          left: 2,
          bottom: 15,
        ),
        border: InputBorder.none,
        hintText: '내용을 입력하세요' + communityGuidelines,
        hintStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w300,
          height: 1.3,
          color: lightGrayColor,
        ),
        counterStyle: TextStyle(
          fontSize: 10,
          color: lightGrayColor,
        ),
      ),
      maxLines: null,
      // maxLength: 500,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: darkPrimaryColor,
      ),
    );
  }
}

class TagInputField extends StatelessWidget {
  final String? hintText;
  final Function(String)? onChanged;
  final TextEditingController controller;
  const TagInputField({
    Key? key,
    this.hintText = '띄어쓰기로 태그가 구분됩니다. 예) 일상 운동',
    this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      maxLength: 30,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          left: 2,
          bottom: 2,
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: lightGrayColor, width: 0.5),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: lightGrayColor,
            width: 0.5,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: lightGrayColor,
            width: 0.5,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: lightGrayColor,
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        color: darkPrimaryColor,
      ),
    );
  }
}

class EmailInputField extends StatelessWidget {
  final TextEditingController controller;
  const EmailInputField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(
          left: 2,
          bottom: 15,
        ),
        border: InputBorder.none,
        hintText: '문의사항을 입력하세요',
        hintStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w300,
          height: 1.3,
          color: lightGrayColor,
        ),
        counterStyle: TextStyle(
          fontSize: 10,
          color: lightGrayColor,
        ),
      ),
      maxLines: null,
      // maxLength: 500,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: darkPrimaryColor,
      ),
    );
  }
}

class OptionInputField extends StatelessWidget {
  final int index;
  final Animation<double> animation;
  final TextEditingController controller;
  final Function() onDeletePressed;
  final Function(String) onChanged;
  final Function() onAddMediaPressed;
  final Function() onRemoveMediaPressed;
  final File? mediaFile;
  final int? mediaType;
  final String? mediaKey;
  final VideoPlayerController? videoPlayerController;
  const OptionInputField({
    Key? key,
    required this.index,
    required this.animation,
    required this.controller,
    required this.onDeletePressed,
    required this.onChanged,
    required this.onAddMediaPressed,
    required this.onRemoveMediaPressed,
    this.mediaFile,
    this.mediaType,
    this.mediaKey,
    this.videoPlayerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Container(
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: backgroundColor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Material(
                type: MaterialType.transparency,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      index.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: darkPrimaryColor,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: TextField(
                          controller: controller,
                          onChanged: onChanged,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(
                              left: 2,
                              bottom: 6,
                            ),
                            border: InputBorder.none,
                            hintText: '내용을 입력하세요',
                            hintStyle: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                              color: lightGrayColor,
                            ),
                            constraints: BoxConstraints(
                              maxHeight: 42,
                            ),
                            counterText: '',
                          ),
                          maxLength: 100,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: darkPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: (mediaFile != null || mediaKey != null)
                          ? IconButton(
                              onPressed: onRemoveMediaPressed,
                              splashRadius: 20,
                              icon: const Icon(
                                PhosphorIcons.trash,
                                color: darkPrimaryColor,
                              ),
                            )
                          : IconButton(
                              onPressed: onAddMediaPressed,
                              splashRadius: 20,
                              padding: EdgeInsets.zero,
                              icon: const MediaIcon(
                                width: 24,
                                height: 24,
                              ),
                            ),
                    ),
                    if (index > 2)
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: IconButton(
                          onPressed: onDeletePressed,
                          splashRadius: 20,
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.close_rounded,
                            color: cancelRedColor,
                            size: 24,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            () {
              if (mediaFile != null) {
                if (mediaType == 0) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.file(
                        mediaFile!,
                        fit: BoxFit.scaleDown,
                        width: context.width - 60,
                        height: 200,
                      ),
                    ),
                  );
                } else {
                  return VideoPlayerContainer(
                      width: context.width - 60,
                      height: 200,
                      controller: videoPlayerController!);
                }
              } else if (mediaKey != null) {
                return ImageLoader(
                  key: Key(mediaKey!),
                  mediaKey: mediaKey!,
                  mediaType: mediaType!,
                  background: backgroundColor,
                  imageType: ImageType.whole,
                );
              } else {
                return const SizedBox.shrink();
              }
            }(),
          ],
        ),
      ),
    );
  }
}

class CommentInputTextField extends StatelessWidget {
  final Function() onSendPressed;
  final Function()? onAddMediaPressed;
  final Function()? onRemoveMediaPressed;
  final TextEditingController controller;
  final File? mediaFile;
  final String? mediaKey;
  final int? mediaType;
  final VideoPlayerController? videoPlayerController;

  final double width;
  final FocusNode? focusNode;
  const CommentInputTextField({
    Key? key,
    required this.onSendPressed,
    this.onAddMediaPressed,
    this.onRemoveMediaPressed,
    required this.controller,
    required this.width,
    this.mediaFile,
    this.mediaKey,
    this.mediaType,
    this.videoPlayerController,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: width,
          child: TextField(
            maxLines: null,
            maxLength: 100,
            focusNode: focusNode,
            style: const TextStyle(
              fontSize: 14,
              color: darkPrimaryColor,
            ),
            controller: controller,
            decoration: InputDecoration(
              counterText: '',
              prefixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CommentIcon(
                    width: 20,
                    height: 20,
                    color: Color(0xffDBD7EA),
                  ),
                ],
              ),
              suffixIcon: onAddMediaPressed != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        (mediaFile == null && mediaKey == null)
                            ? Material(
                                type: MaterialType.circle,
                                color: Colors.transparent,
                                child: IconButton(
                                  splashRadius: 20,
                                  onPressed: onAddMediaPressed,
                                  icon: const MediaIcon(
                                    color: deepGrayColor,
                                  ),
                                ),
                              )
                            : Material(
                                type: MaterialType.circle,
                                color: Colors.transparent,
                                child: IconButton(
                                  splashRadius: 20,
                                  onPressed: onRemoveMediaPressed,
                                  icon: const Icon(
                                    PhosphorIcons.trash,
                                    color: deepGrayColor,
                                  ),
                                ),
                              ),
                        Transform.rotate(
                          angle: -45 * pi / 180,
                          child: Material(
                            type: MaterialType.circle,
                            color: Colors.transparent,
                            child: IconButton(
                              onPressed: onSendPressed,
                              splashRadius: 20,
                              icon: const Icon(
                                Icons.send_rounded,
                                color: brightPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Transform.rotate(
                      angle: -45 * pi / 180,
                      child: Material(
                        type: MaterialType.circle,
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: onSendPressed,
                          splashRadius: 20,
                          icon: const Icon(
                            Icons.send_rounded,
                            color: brightPrimaryColor,
                          ),
                        ),
                      ),
                    ),
              contentPadding: const EdgeInsets.only(
                left: 10,
                bottom: 10,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: textFieldFillColor,
              hintText: '댓글을 입력하세요',
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: darkPrimaryColor,
              ),
            ),
          ),
        ),
        () {
          if (mediaFile != null) {
            if (mediaType == 0) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.file(
                    mediaFile!,
                    fit: BoxFit.scaleDown,
                    width: context.width - 60,
                    height: 200,
                  ),
                ),
              );
            } else {
              return VideoPlayerContainer(
                controller: videoPlayerController!,
                width: context.width - 60,
                height: 200,
              );
            }
          } else if (mediaKey != null) {
            return ImageLoader(
              mediaKey: mediaKey!,
              mediaType: mediaType!,
            );
          } else {
            return const SizedBox.shrink();
          }
        }(),
      ],
    );
  }
}
