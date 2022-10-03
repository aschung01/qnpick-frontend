import 'dart:developer';

import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/services/api_service.dart';
import 'package:qnpick/helpers/parse_jwt.dart';
import 'package:qnpick/helpers/transformers.dart';

class UserApiService extends ApiService {
  static Future<bool> checkUsernameAvailable(String username) async {
    String path = '/users/check_username';
    Map<String, dynamic> parameters = {
      'username': username,
    };

    try {
      var res = await ApiService.getWithoutToken(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> checkUserInfo() async {
    String path = '/users/check_user_info';
    try {
      var res = await ApiService.get(path, null);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getUserInfo() async {
    String path = '/users/user_info';
    var res = await ApiService.get(path, null);
    if (res != null) {
      if (res.data != null) {
        return res.data;
      } else {
        return res;
      }
    }
  }

  static Future<dynamic> getNeighborsByLocation(
      double latitude, double longitude, double radius) async {
    String path = '/users/neighbors';
    Map<String, dynamic> parameters = {
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
    };

    var res = await ApiService.getWithoutToken(path, parameters);
    if (res != null) {
      if (res.data != null) {
        return res.data;
      } else {
        return res;
      }
    }
  }

  static Future<dynamic> registerUserInfo(
    String username,
    String? inviteUsername,
    List<int>? interestCategories,
  ) async {
    String path = '/users/register_user_info';

    Map<String, dynamic> _idTokenData = await AuthController.to.readIdToken();

    inspect(_idTokenData);

    Map<String, dynamic> data = {
      'auth_provider': authProviderStrToInt[_idTokenData['auth_provider']],
      'username': username,
      'email': _idTokenData['email'],
      'interest_categories': interestCategories,
      'invite_username': inviteUsername,
    };

    try {
      var res = await ApiService.post(path, data);
      print(res);
      return res.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> updateUsername(String username) async {
    String path = '/users/update_username';

    Map<String, dynamic> data = {
      'username': username,
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

  static Future<dynamic> updateInterestCategories(
      List interestCategories) async {
    String path = '/users/update_interest_categories';

    Map<String, dynamic> data = {
      'interest_categories': interestCategories,
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

  static Future<bool> postUserLocation(
      double latitude, double longitude) async {
    String path = '/users/location';

    Map<String, dynamic> data = {
      'latitude': latitude,
      'longitude': longitude,
    };

    try {
      var res = await ApiService.post(path, data);
      print(res);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> postFcmToken(String token) async {
    String path = '/users/fcm_token';

    Map<String, dynamic> data = {
      'token': token,
    };

    try {
      var res = await ApiService.post(path, data);
      print(res);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> deleteAccount() async {
    String path = '/users/delete_account';

    try {
      var res = await ApiService.post(path, null);
      print(res);
      return res.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> getUserNotiReception() async {
    String path = '/users/noti_reception';

    try {
      var res = await ApiService.get(path, null);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> postUserNotiReception(bool notiReception) async {
    String path = '/users/noti_reception';

    Map<String, dynamic> data = {
      'noti_reception': notiReception,
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
