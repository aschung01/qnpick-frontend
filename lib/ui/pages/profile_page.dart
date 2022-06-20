import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/profile_controller.dart';
import 'package:qnpick/helpers/mock_data.dart';
import 'package:qnpick/ui/widgets/content_preview_builder.dart';
import 'package:qnpick/ui/widgets/svg_icons.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(
              username: '대박한번내자',
            ),
            const Padding(
              padding: EdgeInsets.only(left: 25, top: 10, bottom: 10),
              child: Text(
                '관심 카테고리',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, bottom: 20),
              child: Row(
                children: List.generate(3 * 2 - 1, (index) {
                  if (index % 2 == 0) {
                    return Badge(text: '요리');
                  } else {
                    return const SizedBox(width: 6);
                  }
                }),
              ),
            ),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TabBar(
                controller: _.profileTabController,
                indicatorColor: brightPrimaryColor,
                automaticIndicatorColorAdjustment: false,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: brightPrimaryColor,
                unselectedLabelColor: darkPrimaryColor,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                tabs: const [
                  Tab(
                    child: Text(
                      '내가 올린 질문',
                    ),
                  ),
                  Tab(
                    child: Text(
                      '내가 응답한 질문',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: TabBarView(
                  physics: const ClampingScrollPhysics(),
                  controller: _.profileTabController,
                  children: [
                    userUploadedQuestionDataList.isNotEmpty
                        ? ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: ContentPreviewBuilder(
                                    data: userUploadedQuestionDataList[index]),
                              );
                            }),
                            itemCount: userUploadedQuestionDataList.length,
                          )
                        : Column(
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(top: 150, bottom: 30),
                                child: FailCharacter(),
                              ),
                              Text(
                                '올린 질문이 없습니다',
                                style: TextStyle(
                                    fontSize: 16, color: lightGrayColor),
                              )
                            ],
                          ),
                    userAnsweredQuestionsDataList.isNotEmpty
                        ? ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: ContentPreviewBuilder(
                                    data: userUploadedQuestionDataList[index]),
                              );
                            }),
                            itemCount: userAnsweredQuestionsDataList.length,
                          )
                        : Column(
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(top: 150, bottom: 30),
                                child: FailCharacter(),
                              ),
                              Text(
                                '응답한 질문이 없습니다',
                                style: TextStyle(
                                    fontSize: 16, color: lightGrayColor),
                              )
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String? username;
  const ProfileHeader({Key? key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onMenuPressed() {
      Get.toNamed('/settings');
    }

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: username != null
          ? Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                username!,
                style: const TextStyle(
                  fontFamily: 'Jalnan',
                  color: lightBrightPrimaryColor,
                  fontSize: 20,
                ),
              ),
            )
          : null,
      actions: username != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: IconButton(
                  onPressed: _onMenuPressed,
                  splashRadius: 25,
                  icon: const Icon(Icons.menu_rounded, size: 30),
                ),
              )
            ]
          : null,
    );
  }
}

class Badge extends StatelessWidget {
  final String text;
  const Badge({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'Roboto',
            color: brightPrimaryColor,
          ),
        ),
      ),
    );
  }
}
