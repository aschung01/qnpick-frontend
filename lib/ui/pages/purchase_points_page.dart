import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/store_controller.dart';
import 'package:qnpick/helpers/utils.dart';
import 'package:qnpick/ui/widgets/buttons.dart';
import 'package:qnpick/ui/widgets/header.dart';

class PurchasePointsPage extends GetView<StoreController> {
  const PurchasePointsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      AuthController.to.getUserInfoIfEmpty();
      controller.fetchProducts();
      controller.getPastPurchases();
    });

    void _onBackPressed() {
      Get.back();
    }

    return Scaffold(
      body: SafeArea(
        child: GetBuilder<StoreController>(builder: (__) {
          return Column(
            children: [
              Header(
                onPressed: _onBackPressed,
                title: '포인트 구매',
              ),
              Expanded(
                child: GetX<StoreController>(builder: (_) {
                  return ListView(
                    padding:
                        const EdgeInsets.only(top: 15, left: 30, right: 30),
                    physics: const ClampingScrollPhysics(),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '내 포인트',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              color: darkPrimaryColor,
                            ),
                          ),
                          GetX<StoreController>(builder: (_) {
                            return Text(
                              (_.pointStatus.isNotEmpty
                                      ? formatNumberFromInt(
                                          _.pointStatus['count_points'])
                                      : '0') +
                                  ' QP',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                color: darkPrimaryColor,
                              ),
                            );
                          }),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              GetPlatform.isAndroid ? '+ 1,100 QP' : '+ 1,210p',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                color: darkPrimaryColor,
                              ),
                            ),
                            ElevatedActionButton(
                              buttonText:
                                  GetPlatform.isAndroid ? '￦1,000' : '￦1,200',
                              onPressed: () => controller.purchaseProduct(0),
                              backgroundColor: brightSecondaryColor,
                              width: 80,
                              height: 32,
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              borderRadius: 5,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            GetPlatform.isAndroid ? '+ 2,200 QP' : '+ 2,420p',
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              color: darkPrimaryColor,
                            ),
                          ),
                          ElevatedActionButton(
                            buttonText:
                                GetPlatform.isAndroid ? '￦2,000' : '￦2,420',
                            onPressed: () => controller.purchaseProduct(1),
                            backgroundColor: brightSecondaryColor,
                            width: 80,
                            height: 32,
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            borderRadius: 5,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              GetPlatform.isAndroid
                                  ? '+ 3,300 QP'
                                  : '+ 3,630 QP',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                color: darkPrimaryColor,
                              ),
                            ),
                            ElevatedActionButton(
                              buttonText:
                                  GetPlatform.isAndroid ? '￦3,000' : '￦3,300',
                              onPressed: () => controller.purchaseProduct(2),
                              backgroundColor: brightSecondaryColor,
                              width: 80,
                              height: 32,
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              borderRadius: 5,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextActionButton(
                            buttonText: '광고 보고 포인트 얻기 (+50 QP) >',
                            onPressed: () => _.showRewardedAd(),
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            isUnderlined: false,
                            fontFamily: 'Roboto',
                            textColor: darkPrimaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 30),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextActionButton(
                            buttonText: '친구 초대하고 포인트 얻기 (+500 QP) >',
                            onPressed: () => _.shareKakaoLink(),
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            isUnderlined: false,
                            fontFamily: 'Roboto',
                            textColor: darkPrimaryColor,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          '포인트 구매 내역',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            color: darkPrimaryColor,
                          ),
                        ),
                      ),
                      if (_.pastPurchaseList.isNotEmpty)
                        ...List.generate(
                          _.pastPurchaseList.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat('yyyy. MM. dd').format(
                                          DateTime.parse(
                                              _.pastPurchaseList[index]
                                                  ['created_at'])),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: darkPrimaryColor,
                                      ),
                                    ),
                                    Text(
                                      formatNumberFromInt(
                                              _.pastPurchaseList[index]
                                                  ['points']) +
                                          ' QP 구매',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        height: 1.3,
                                        color: darkPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}
