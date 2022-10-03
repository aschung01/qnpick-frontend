import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/helpers/transformers.dart';
import 'package:qnpick/ui/widgets/buttons.dart';

class SearchFilter extends StatelessWidget {
  final RxList<bool> tapList;
  final RxInt filter;
  final bool randomMode;
  final bool showInterestCategories;
  final bool showSearchButton;
  final Function()? onCreateRandomPressed;
  final Function()? onDetailFilterCompletePressed;
  final Function()? onSearchPressed;
  final RxList? filterCategoryList;
  final bool searchActivated;
  final RxBool? seeClosed;
  final Function(bool)? onSeeClosedChanged;
  const SearchFilter({
    Key? key,
    required this.tapList,
    required this.filter,
    this.randomMode = true,
    this.showInterestCategories = false,
    this.showSearchButton = false,
    this.onCreateRandomPressed,
    this.onDetailFilterCompletePressed,
    this.onSearchPressed,
    this.filterCategoryList,
    this.searchActivated = false,
    this.seeClosed,
    this.onSeeClosedChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: (showSearchButton || seeClosed != null)
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.start,
                    children: [
                      const Text(
                        '필터',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: darkPrimaryColor,
                        ),
                      ),
                      if (seeClosed != null && !showSearchButton)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              '마감된 질문들 보기',
                              style: TextStyle(
                                color: deepGrayColor,
                                fontSize: 13,
                              ),
                            ),
                            Switch(
                              value: seeClosed!.value,
                              onChanged: onSeeClosedChanged,
                              activeColor: brightSecondaryColor,
                            ),
                          ],
                        ),
                      if (showSearchButton)
                        Row(
                          children: [
                            if (seeClosed != null)
                              const Text(
                                '마감된 질문들 보기',
                                style: TextStyle(
                                  color: deepGrayColor,
                                  fontSize: 13,
                                ),
                              ),
                            if (seeClosed != null)
                              Switch(
                                value: seeClosed!.value,
                                onChanged: onSeeClosedChanged,
                                activeColor: softBlueColor,
                              ),
                            TextActionButton(
                              height: 40,
                              buttonText: '검색 ',
                              textColor: brightPrimaryColor,
                              fontWeight: FontWeight.bold,
                              onPressed: () => onSearchPressed!(),
                              isUnderlined: false,
                              activated: searchActivated,
                              icon: Icon(
                                Icons.search_rounded,
                                color: searchActivated
                                    ? brightPrimaryColor
                                    : lightGrayColor,
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    height: 50,
                    child: GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        tapList[0] = true;
                      },
                      onTapUp: (TapUpDetails details) {
                        tapList[0] = false;
                      },
                      onTapCancel: () {
                        tapList[0] = false;
                      },
                      onTap: () {
                        filter.value = 0;
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.check_rounded,
                                color: filter.value == 0
                                    ? brightPrimaryColor
                                    : deepGrayColor,
                              ),
                            ),
                            Text(
                              '전체 카테고리 탐색',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: filter.value == 0 || tapList[0]
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: filter.value == 0
                                    ? brightPrimaryColor
                                    : deepGrayColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    height: 50,
                    child: GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        tapList[1] = true;
                      },
                      onTapUp: (TapUpDetails details) {
                        tapList[1] = false;
                      },
                      onTapCancel: () {
                        tapList[1] = false;
                      },
                      onTap: () {
                        filter.value = 1;
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.check_rounded,
                                color: filter.value == 1
                                    ? brightPrimaryColor
                                    : deepGrayColor,
                              ),
                            ),
                            Text(
                              '내 관심 카테고리 내에서 탐색',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: filter.value == 1 || tapList[1]
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: filter.value == 1
                                    ? brightPrimaryColor
                                    : deepGrayColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (showInterestCategories && filter.value == 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Wrap(
                      spacing: 6,
                      children:
                          List.generate(filterCategoryList!.length, (index) {
                        print(filterCategoryList);
                        return Chip(
                          backgroundColor: backgroundColor,
                          label: Text(
                            questionCategoryIntToStr[
                                filterCategoryList![index]]!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: darkPrimaryColor,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    height: 50,
                    child: GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        tapList[2] = true;
                      },
                      onTapUp: (TapUpDetails details) {
                        tapList[2] = false;
                      },
                      onTapCancel: () {
                        tapList[2] = false;
                      },
                      onTap: () {
                        filter.value = 2;
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.check_rounded,
                                color: filter.value == 2
                                    ? brightPrimaryColor
                                    : deepGrayColor,
                              ),
                            ),
                            Text(
                              randomMode ? '무작위 카테고리 탐색' : '카테고리 상세 설정',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: filter.value == 2 || tapList[2]
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: filter.value == 2
                                    ? brightPrimaryColor
                                    : deepGrayColor,
                              ),
                            ),
                            if (randomMode && filter.value == 2)
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: IconButton(
                                      onPressed: onCreateRandomPressed,
                                      splashRadius: 15,
                                      iconSize: 20,
                                      icon: const Icon(
                                        Icons.replay_rounded,
                                        color: brightPrimaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (!randomMode &&
                                filter.value == 2 &&
                                !showSearchButton)
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextActionButton(
                                  buttonText: '탐색 >',
                                  onPressed: () =>
                                      onDetailFilterCompletePressed!(),
                                  activated: searchActivated,
                                  fontWeight: FontWeight.bold,
                                  textColor: brightPrimaryColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (!randomMode && filter.value == 2)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, bottom: 10, top: 5),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 8,
                      children: List.generate(questionCategoryIntToStr.length,
                          (index) {
                        bool _activated = filterCategoryList!.contains(index);

                        return ChoiceChip(
                          onSelected: (bool sel) {
                            if (sel) {
                              filterCategoryList!.add(index);
                            } else {
                              filterCategoryList!.remove(index);
                            }
                          },
                          selected: filterCategoryList!.contains(index),
                          selectedColor: brightPrimaryColor,
                          disabledColor: Colors.white,
                          backgroundColor: Colors.white,
                          side: _activated
                              ? const BorderSide(color: brightPrimaryColor)
                              : const BorderSide(color: deepGrayColor),
                          elevation: 0,
                          pressElevation: 3,
                          label: Text(
                            questionCategoryIntToStr[index]!,
                            style: TextStyle(
                              fontSize: 14,
                              color: _activated ? Colors.white : deepGrayColor,
                              fontWeight: _activated
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }),
                    ),
                  )
              ],
            );
          }),
        ),
      ],
    );
  }
}
