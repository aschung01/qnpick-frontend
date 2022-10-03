import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_template.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/services/store_api_service.dart';
import 'package:qnpick/ui/widgets/custom_snackbar.dart';

// const String unitId = 'ca-app-pub-4190097104200746/2910913141';
String unitId = kReleaseMode
    ? (GetPlatform.isAndroid
        ? 'ca-app-pub-4190097104200746/2910913141'
        : 'ca-app-pub-4190097104200746/3114858437')
    : 'ca-app-pub-3940256099942544/5224354917';

const int _maxFailedLoadAttempts = 3;

const _qnpickImageUrl =
    'https://qnpick-media180601-dev.s3.ap-northeast-2.amazonaws.com/public/2022-08-08+16%3A08%3A52.918262';

const _qnpickStoreUrl =
    'https://play.google.com/store/apps/details?id=com.exonverse.exon_app';

class StoreController extends GetxController {
  static StoreController to = Get.find<StoreController>();

  late StreamSubscription<dynamic> _subscription;
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> productDetails = [];
  List<PurchaseParam> purchaseParams = [];
  RxList pastPurchaseList = [].obs;
  RxMap pointStatus = {}.obs;
  int _numRewardedLoadAttempts = 0;
  RewardedAd? rewardedAd;
  AdRequest request = AdRequest();
  bool rebuild = false;

  @override
  void onInit() async {
    fetchProducts();
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    _createRewardedAd();
    super.onInit();
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }

  Future<void> _createRewardedAd() async {
    log('trying to create ad');
    log(unitId);
    await RewardedAd.load(
      adUnitId: unitId,
      request: request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('$ad loaded');
          rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
          update();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error.');
          rewardedAd = null;
          if (_numRewardedLoadAttempts < _maxFailedLoadAttempts) {
            _createRewardedAd();
            _numRewardedLoadAttempts++;
          }
        },
      ),
    );
  }

  Future<bool> showRewardedAd() async {
    if (rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return true;
    }
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) async {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        await _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) async {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        await _createRewardedAd();
      },
    );
    await rewardedAd!.show(onUserEarnedReward: _onUserEarnedReward);
    rewardedAd = null;
    return true;
  }

  Future<void> _onUserEarnedReward(AdWithoutView ad, RewardItem reward) async {
    inspect(reward);
    bool success = false;

    Future.delayed(const Duration(seconds: 2), () async {
      if (kReleaseMode) {
        success = await StoreApiService.postAdReward(reward.amount.toInt());
      } else {
        success = await StoreApiService.postAdReward(50);
      }
      if (success) {
        await StoreApiService.getPointStatus();
        Get.showSnackbar(PointSnackbar(
          text: "+ 50 QP",
        ));
      } else {
        Get.showSnackbar(BottomSnackbar(text: '오류가 발생했습니다'));
      }
    });
    update();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach(
      (PurchaseDetails purchaseDetails) async {
        print(
            "📌 EVENT $purchaseDetails ${purchaseDetails.status} ${purchaseDetails.productID} ${purchaseDetails.pendingCompletePurchase}");
        inspect(purchaseDetails);
        if (purchaseDetails.status == PurchaseStatus.error) {
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          inspect(purchaseDetails);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
          Get.showSnackbar(BottomSnackbar(text: '포인트를 구매해주셔서 감사합니다'));
        }
      },
    );
  }

  Future<void> shareKakaoLink() async {
    try {
      FeedTemplate shareText = FeedTemplate(
        content: Content(
            title:
                '${AuthController.to.userInfo['username']}님이 당신을 큐앤픽에 초대했어요!',
            description:
                '회원가입 후 [초대 유저] 입력란에 ${AuthController.to.userInfo['username']}를 입력해주세요',
            imageUrl: Uri.parse(_qnpickImageUrl),
            link: Link(webUrl: Uri.parse(_qnpickStoreUrl))),
        buttons: [
          Button(
            title: '앱 다운받기',
            link: Link(webUrl: Uri.parse(_qnpickStoreUrl)),
          ),
        ],
      );

      Uri uri = await ShareClient.instance.shareDefault(template: shareText);
      await ShareClient.instance.launchKakaoTalk(uri);
      print('카카오톡 공유 완료');
    } catch (error) {
      print('카카오톡 공유 실패 $error');
    }
  }

  Future<void> fetchProducts() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (available) {
      Set<String> ids = <String>{
        "1100_point",
        "3300_point",
        "5500_point",
      };

      ProductDetailsResponse res = await inAppPurchase.queryProductDetails(ids);
      inspect(res);
      inAppPurchase.restorePurchases();

      productDetails = res.productDetails;
      productDetails.forEach((pd) {
        purchaseParams.add(PurchaseParam(productDetails: pd));
      });
    }
  }

  Future<void> purchaseProduct(int idx) async {
    try {
      if (purchaseParams.isEmpty) {
        await fetchProducts();
      }
      await InAppPurchase.instance
          .buyConsumable(purchaseParam: purchaseParams[idx]);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPastPurchases() async {
    pastPurchaseList.value = await StoreApiService.getPastPurchases();
  }

  Future<void> getPointStatus() async {
    pointStatus.value = await StoreApiService.getPointStatus();
  }

  void reset() {
    productDetails.clear;
    purchaseParams.clear;
    pastPurchaseList.clear;
    pointStatus.clear();
    _numRewardedLoadAttempts = 0;
    rebuild = false;
    update();
  }
}
