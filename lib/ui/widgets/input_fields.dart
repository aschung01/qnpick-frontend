import 'package:flutter/material.dart';
import 'package:qnpick/constants/constants.dart';

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
