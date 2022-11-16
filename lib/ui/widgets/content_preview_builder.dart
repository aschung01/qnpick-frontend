import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/community_controller.dart';
import 'package:qnpick/core/services/amplify_service.dart';
import 'package:qnpick/helpers/transformers.dart';
import 'package:qnpick/helpers/utils.dart';
import 'package:qnpick/ui/widgets/image_loader.dart';
import 'package:qnpick/ui/widgets/loading_blocks.dart';
import 'package:shimmer/shimmer.dart';

class ContentPreviewBuilder extends StatelessWidget {
  final Map<String, dynamic> questionData;
  final Map<String, dynamic> count;
  const ContentPreviewBuilder({
    Key? key,
    required this.questionData,
    required this.count,
  }) : super(key: key);

  void _onTap() {
    CommunityController.to.questionPageInit(questionData['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xffF4F4F4),
        ),
        child: SizedBox(
          height: 100,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: _onTap,
              highlightColor: Colors.transparent,
              splashColor: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            questionData['title'],
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
                          questionData['created_at'],
                          style: const TextStyle(
                            color: darkPrimaryColor,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 30,
                        ),
                        child: Text(
                          questionData['content'],
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
                          questionTypeIntToStr[questionData['type']]! +
                              ' | ' +
                              questionCategoryIntToStr[
                                  questionData['category']]!,
                          style: const TextStyle(
                            color: darkPrimaryColor,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          () {
                            if (count['closed'] == true) {
                              return '마감됨';
                            } else if (questionData['type'] == 0) {
                              return questionData['due_date'] != null
                                  ? '마감 ${formatCurrentDDay(DateTime.parse(questionData['due_date']))}'
                                  : '진행률 ' +
                                      formatPercentage(count['progress']);
                            } else {
                              return '';
                            }
                          }(),
                          style: const TextStyle(
                            color: brightSecondaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MediaContentPreviewBuilder extends StatelessWidget {
  final Map<String, dynamic> questionData;
  final Map<String, dynamic> count;
  const MediaContentPreviewBuilder({
    Key? key,
    required this.questionData,
    required this.count,
  }) : super(key: key);

  void _onTap() {
    CommunityController.to.questionPageInit(questionData['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ImageLoader(
            mediaKey: questionData['media_key'],
            mediaType: questionData['media_type'],
            background: backgroundColor,
            fit: BoxFit.fitWidth,
            width: context.width - 40,
            imageType: ImageType.preview,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: const Color(0xffF4F4F4).withOpacity(0.9),
            ),
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        questionData['title'],
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
                      questionData['created_at'],
                      style: const TextStyle(
                        color: darkPrimaryColor,
                        fontSize: 12,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 30,
                    ),
                    child: Text(
                      questionData['content'],
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
                      questionTypeIntToStr[questionData['type']]! +
                          ' | ' +
                          questionCategoryIntToStr[questionData['category']]!,
                      style: const TextStyle(
                        color: darkPrimaryColor,
                        fontSize: 12,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Text(
                      count['closed']
                          ? '마감됨'
                          : returnDueDateOrProgress(
                              questionData['due_date'], count['progress']),
                      style: const TextStyle(
                        color: brightSecondaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            width: context.width - 40,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                highlightColor: Colors.transparent,
                splashColor: Colors.white.withOpacity(0.2),
                onTap: _onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MediaMiniContentPreviewBuilder extends StatelessWidget {
  final Map<String, dynamic> questionData;
  final Map<String, dynamic> count;
  const MediaMiniContentPreviewBuilder({
    Key? key,
    required this.questionData,
    required this.count,
  }) : super(key: key);

  void _onTap() {
    CommunityController.to.questionPageInit(questionData['id']);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width / 2 - 25,
      height: 172,
      child: Stack(
        children: [
          Column(
            children: [
              ImageLoader(
                mediaKey: questionData['media_key'],
                mediaType: questionData['media_type'],
                height: 100,
                width: context.width / 2 - 25,
                fit: BoxFit.fitWidth,
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: backgroundColor,
                ),
                height: 72,
                width: context.width / 2 - 25,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        questionData['title'],
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: darkPrimaryColor,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          questionTypeIntToStr[questionData['type']]!,
                          style: const TextStyle(
                            color: darkPrimaryColor,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          () {
                            if (count['closed'] == true) {
                              return '마감됨';
                            } else if (questionData['type'] == 0) {
                              return questionData['due_date'] != null
                                  ? '마감 ${formatCurrentDDay(DateTime.parse(questionData['due_date']))}'
                                  : '진행률 ' +
                                      formatPercentage(count['progress']);
                            } else {
                              return '';
                            }
                          }(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: brightSecondaryColor,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 172,
            width: context.width / 2 - 25,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                highlightColor: Colors.transparent,
                splashColor: Colors.white.withOpacity(0.2),
                onTap: _onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeTextPreviewBuilder extends StatelessWidget {
  final Map<String, dynamic> questionData;
  final Map<String, dynamic> count;
  const HomeTextPreviewBuilder({
    Key? key,
    required this.questionData,
    required this.count,
  }) : super(key: key);

  void _onTap() {
    CommunityController.to.questionPageInit(questionData['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: _onTap,
          highlightColor: Colors.transparent,
          splashColor: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    questionData['title'],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: darkPrimaryColor,
                      fontSize: 16,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      () {
                        if (count['closed'] == true) {
                          return '마감됨';
                        } else if (questionData['type'] == 0) {
                          return questionData['due_date'] != null
                              ? '마감 ${formatCurrentDDay(DateTime.parse(questionData['due_date']))}'
                              : '진행률 ' + formatPercentage(count['progress']);
                        } else {
                          return '';
                        }
                      }(),
                      style: const TextStyle(
                        color: brightSecondaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        questionData['created_at'],
                        style: const TextStyle(
                          color: darkPrimaryColor,
                          fontSize: 12,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeMediaPreviewBuilder extends StatelessWidget {
  final Map<String, dynamic> questionData;
  final Map<String, dynamic> count;
  const HomeMediaPreviewBuilder({
    Key? key,
    required this.questionData,
    required this.count,
  }) : super(key: key);

  void _onTap() {
    CommunityController.to.questionPageInit(questionData['id']);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width - 40,
      height: 60,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: _onTap,
          highlightColor: Colors.transparent,
          splashColor: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: ImageLoader(
                  mediaKey: questionData['media_key'],
                  mediaType: questionData['media_type'],
                  height: 50,
                  width: 50,
                  fit: BoxFit.fitWidth,
                  imageType: ImageType.miniPreview,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Text(
                          questionData['title'],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: darkPrimaryColor,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            questionData['created_at'],
                            style: const TextStyle(
                              color: darkPrimaryColor,
                              fontSize: 12,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          Text(
                            () {
                              if (count['closed'] == true) {
                                return '마감됨';
                              } else if (questionData['type'] == 0) {
                                return questionData['due_date'] != null
                                    ? '마감 ${formatCurrentDDay(DateTime.parse(questionData['due_date']))}'
                                    : '진행률 ' +
                                        formatPercentage(count['progress']);
                              } else {
                                return '';
                              }
                            }(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: brightSecondaryColor,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
