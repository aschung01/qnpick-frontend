import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/store_controller.dart';
import 'package:qnpick/helpers/utils.dart';
import 'package:qnpick/ui/widgets/buttons.dart';

class PointPage extends GetView<StoreController> {
  const PointPage({Key? key}) : super(key: key);

  void rebuildAllChildren(BuildContext context) {
    print('point page rebuild');
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
    controller.rebuild = false;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      AuthController.to.getUserInfoIfEmpty();
      if (AuthController.to.isAuthenticated.value) {
        controller.getPointStatus();
      }
    });

    void _onBuyPointPressed() {
      Get.toNamed('/purchase');
    }

    void _onEarnPointsPressed() {
      // Get.toNamed('/auth');
    }

    void _onGetPointsPressed() {
      Get.toNamed('/auth');
    }

    void _onPointInfoPressed() {
      Get.dialog(
        Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Text(
                    'QP포인트',
                    style: TextStyle(
                      color: darkPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Text(
                  'QP포인트란 질문 작성시 정해진 포인트가 사용되며 답변채택시 설정한 QP포인트가 답변자에게 지급되고 채택자에게 설정한 포인트가 적립됩니다.',
                  style: TextStyle(
                    color: darkPrimaryColor,
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextActionButton(
                    buttonText: '확인',
                    fontWeight: FontWeight.bold,
                    textColor: brightPrimaryColor,
                    onPressed: () {
                      Get.back();
                    },
                    isUnderlined: false,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: softYellowColor,
          ),
          height: 160,
          width: context.width - 50,
          margin: const EdgeInsets.fromLTRB(25, 30, 25, 20),
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: GetBuilder<StoreController>(
            builder: (__) {
              if (__.rebuild) {
                Future.delayed(Duration.zero, () {
                  rebuildAllChildren(context);
                });
                print('called rebuild point');
              }
              print('hi');
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        PhosphorIcons.coins,
                        size: 40,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: Text(
                          '내 포인트',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            color: darkPrimaryColor,
                          ),
                        ),
                      ),
                      Icon(
                        PhosphorIcons.coins,
                        size: 40,
                      ),
                    ],
                  ),
                  GetX<StoreController>(
                    builder: (_) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${_.pointStatus.isNotEmpty ? formatNumberFromInt(_.pointStatus['count_points']) : '0'} QP',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              color: darkPrimaryColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
        ...[
          GetX<AuthController>(builder: (_) {
            if (_.isAuthenticated.value) {
              return ElevatedActionButton(
                buttonText: '포인트 얻으러 가기',
                width: context.width - 50,
                height: (context.width - 50) * 50 / 340,
                backgroundColor: darkPrimaryColor,
                borderRadius: 10,
                onPressed: _onBuyPointPressed,
              );
            } else {
              return ElevatedActionButton(
                buttonText: '회원가입하고 1,000QP 받기 >',
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                width: context.width - 50,
                height: (context.width - 50) * 50 / 340,
                backgroundColor: brightSecondaryColor,
                borderRadius: 10,
                onPressed: _onGetPointsPressed,
              );
            }
          }),
          GetX<AuthController>(builder: (_) {
            if (_.isAuthenticated.value) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextActionButton(
                  buttonText: '포인트가 무엇인가요?',
                  width: context.width - 50,
                  height: (context.width - 50) * 50 / 340,
                  onPressed: _onPointInfoPressed,
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
        Expanded(
          child: GetX<StoreController>(builder: (_) {
            return ListView(
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
                      '${_.pointStatus.isNotEmpty ? formatNumberFromInt(_.pointStatus['count_used_points']) : '0'} QP',
                      style: const TextStyle(
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
                        '${_.pointStatus.isNotEmpty ? formatNumberFromInt(
                            _.pointStatus['count_gained_points_ad'] +
                                _.pointStatus['count_gained_points_comment'] +
                                _.pointStatus['count_gained_points_invite'],
                          ) : '0'} QP',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: darkPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '광고, 댓글 등으로 획득',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          color: darkPrimaryColor,
                        ),
                      ),
                      Text(
                        '${_.pointStatus.isNotEmpty ? formatNumberFromInt(
                            _.pointStatus['count_gained_points_ad'] +
                                _.pointStatus['count_gained_points_comment'],
                          ) : '0'} QP',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: darkPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20, left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '친구 초대로 획득',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          color: darkPrimaryColor,
                        ),
                      ),
                      Text(
                        '${_.pointStatus.isNotEmpty ? formatNumberFromInt(
                            _.pointStatus['count_gained_points_invite'],
                          ) : '0'} QP',
                        style: const TextStyle(
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
                      '${_.pointStatus.isNotEmpty ? formatNumberFromInt(_.pointStatus['count_purchased_points']) : '0'} QP',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: darkPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
