import 'package:qnpick/core/services/api_service.dart';

class StoreApiService extends ApiService {
  static Future<dynamic> getPastPurchases() async {
    String path = '/points/purchase';

    var res = await ApiService.get(path, null);
    if (res != null) {
      if (res.data != null) {
        return res.data;
      } else {
        return res;
      }
    }
  }

  static Future<dynamic> getPointStatus() async {
    String path = '/points/status';

    var res = await ApiService.get(path, null);
    if (res != null) {
      if (res.data != null) {
        return res.data;
      } else {
        return res;
      }
    }
  }

  static Future<dynamic> postAdReward(
    int points,
  ) async {
    String path = '/points/ad_reward';

    Map<String, dynamic> data = {
      'points': points,
    };

    try {
      var res = await ApiService.post(path, data);
      print(res);
      return res.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> postCompletePurchase(
    int points,
  ) async {
    String path = '/points/purchase';

    Map<String, dynamic> data = {
      'points': points,
    };

    try {
      var res = await ApiService.post(path, data);
      print(res);
      return res.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
