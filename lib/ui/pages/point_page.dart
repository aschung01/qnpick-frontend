import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/ui/widgets/buttons.dart';

class PointPage extends StatelessWidget {
  const PointPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onBuyPointPressed() {}

    void _onPointInfoPressed() {}

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: softYellowColor,
          ),
          height: 200,
          width: context.width - 50,
          margin: const EdgeInsets.fromLTRB(25, 30, 25, 20),
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              const Text(
                '내 포인트',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  color: darkPrimaryColor,
                ),
              ),
              const Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 30),
                child: Text(
                  '11,000 QP',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: darkPrimaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Colors.white.withOpacity(0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              '이번 달 사용 포인트',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                color: darkPrimaryColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                '600 QP',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  color: darkPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              '이번 달 획득 포인트',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                color: darkPrimaryColor,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                '1,000 QP',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  color: darkPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        ElevatedActionButton(
          buttonText: '포인트 구매하기',
          width: context.width - 50,
          height: (context.width - 50) * 50 / 340,
          backgroundColor: darkPrimaryColor,
          borderRadius: 10,
          onPressed: _onBuyPointPressed,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: TextActionButton(
            buttonText: '포인트가 무엇인가요?',
            onPressed: _onPointInfoPressed,
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 35, left: 35, right: 35),
            physics: const ClampingScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '총 사용한 포인트',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      color: darkPrimaryColor,
                    ),
                  ),
                  Text(
                    '1,500 QP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: darkPrimaryColor,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '총 획득한 포인트',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        color: darkPrimaryColor,
                      ),
                    ),
                    Text(
                      '2,300 QP',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: darkPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '총 구매한 포인트',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      color: darkPrimaryColor,
                    ),
                  ),
                  Text(
                    '200 QP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: darkPrimaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
