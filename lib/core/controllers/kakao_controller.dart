import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_navi.dart';

class KakaoController extends GetxController {
  static KakaoController to = Get.find<KakaoController>();
  
  
  bool isKakaoInstalled = false;

  @override
  void onInit() {
    _initKakaoTalkInstalled();
    super.onInit();
  }

  void _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print('kakao Install: ' + installed.toString());
    isKakaoInstalled = installed;
    update();
  }
}
