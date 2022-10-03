import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/ui/widgets/buttons.dart';

class InitialHelpPage extends StatelessWidget {
  const InitialHelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkPrimaryColor.withOpacity(0.3),
      body: Stack(
        children: [
          Positioned(
            top: context.mediaQueryPadding.top + 10,
            right: 10,
            child: TextActionButton(
              buttonText: '시작하기',
              fontFamily: 'handwriting',
              textColor: Colors.white,
              fontSize: 26,
              onPressed: () {
                Get.back();
              },
            ),
          ),
          Positioned(
            top: context.mediaQueryPadding.top + 55,
            right: 30,
            child: const Text(
              '검색',
              style: TextStyle(
                  fontFamily: 'handwriting',
                  color: Colors.orange,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: context.mediaQueryPadding.top + 90,
            child: Container(
              width: context.width - 20,
              height: 56,
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow),
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            top: context.mediaQueryPadding.top + 155,
            child: IntrinsicWidth(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        height: 45,
                        margin: const EdgeInsets.only(left: 10, right: 50),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.yellow),
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      Container(
                        width: 170,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.yellow),
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      '카테고리, 마감 필터',
                      style: TextStyle(
                          fontFamily: 'handwriting',
                          color: Colors.orange,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: context.mediaQueryPadding.bottom + 25 + 56,
            right: 25,
            child: Column(
              children: [
                const Text(
                  '질문 작성',
                  style: TextStyle(
                      fontFamily: 'handwriting',
                      color: Colors.orange,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 70,
                  height: 70,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.yellow),
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: context.mediaQueryPadding.bottom - 5,
            left: context.width / 4 - 25,
            child: Column(
              children: [
                Text(
                  '특정 지역에 질문하기',
                  style: TextStyle(
                      fontFamily: 'handwriting',
                      color: Colors.orange,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 70,
                  height: 70,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.yellow),
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
