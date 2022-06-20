import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/helpers/transformers.dart';
import 'package:qnpick/helpers/utils.dart';

class ContentPreviewBuilder extends StatelessWidget {
  final Map<String, dynamic> data;
  const ContentPreviewBuilder({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xffF4F4F4),
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  data['title'],
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkPrimaryColor,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              Text(
                data['created_at'],
                style: const TextStyle(
                  color: darkPrimaryColor,
                  fontSize: 12,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 30,
              ),
              child: Text(
                data['content'],
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: deepGrayColor,
                  fontSize: 12,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                questionTypeIntToStr[data['type']]! +
                    ' | ' +
                    questionCategoryIntToStr[data['category']]!,
                style: const TextStyle(
                  color: darkPrimaryColor,
                  fontSize: 12,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                '진행률 ' + formatPercentage(data['progress']),
                style: const TextStyle(
                  color: darkPrimaryColor,
                  fontSize: 12,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
