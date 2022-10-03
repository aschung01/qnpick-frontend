import 'package:intl/intl.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/services/api_service.dart';
import 'package:qnpick/core/services/user_api_service.dart';

class CommunityApiService extends ApiService {
  static Future<dynamic> getHomeQuestionPreview(
      bool seeClosed, int filter, List<dynamic>? categoryList) async {
    String path = AuthController.to.isAuthenticated.value
        ? '/community/home_question_preview/auth'
        : '/community/home_question_preview';

    print(categoryList?.toString().runtimeType);
    Map<String, dynamic> parameters = {
      'see_closed': seeClosed,
      'filter': filter,
      'categories': categoryList?.toString(),
    };

    try {
      var res = AuthController.to.isAuthenticated.value
          ? await ApiService.get(path, parameters)
          : await ApiService.getWithoutToken(path, parameters);
      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getQuestionPreviewList(int startIndex, bool seeClosed,
      int filter, int mediaType, List<dynamic>? categoryList) async {
    String path = AuthController.to.isAuthenticated.value
        ? '/community/question_preview_list/auth'
        : '/community/question_preview_list';

    Map<String, dynamic> parameters = {
      'start_index': startIndex,
      'see_closed': seeClosed,
      'filter': filter,
      'media_type': mediaType, // 0: text, 1: image, 2: video
      'categories': categoryList?.toString(),
    };

    try {
      var res = AuthController.to.isAuthenticated.value
          ? await ApiService.get(path, parameters)
          : await ApiService.getWithoutToken(path, parameters);
      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> search(int startIndex, String text, bool seeClosed,
      int filter, List<dynamic>? categoryList) async {
    String path = AuthController.to.isAuthenticated.value
        ? '/community/search/auth'
        : '/community/search';

    Map<String, dynamic> parameters = {
      'start_index': startIndex,
      'text': text,
      'see_closed': seeClosed,
      'filter': filter,
      'categories': categoryList?.toString(),
    };

    try {
      var res = AuthController.to.isAuthenticated.value
          ? await ApiService.get(path, parameters)
          : await ApiService.getWithoutToken(path, parameters);
      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getUserCreatedQuestionPreview(int startIndex) async {
    String path = '/community/user_created_questions_preview';

    Map<String, dynamic> parameters = {
      'start_index': startIndex,
    };

    try {
      var res = await ApiService.get(path, parameters);
      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getUserAnsweredQuestionPreview(int startIndex) async {
    String path = '/community/user_answered_questions_preview';

    Map<String, dynamic> parameters = {
      'start_index': startIndex,
    };

    try {
      var res = await ApiService.get(path, parameters);
      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getTextQuestionPreview(
      int indexNum, int startIndex, int type) async {
    String path = '/community/text_question_preview';

    Map<String, dynamic> parameters = {'categories': []};

    try {
      var res = await ApiService.getWithoutToken(path, parameters);
      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> postQuestion(
    String title,
    String content,
    List<String>? tags,
    String? mediaKey,
    int? mediaType,
    int type,
    List<String>? options,
    List<String?>? optionMediaKeyList,
    List<int?>? optionMediaTypeList,
    int category,
    int point,
    int closureRequirement,
    DateTime? dueDate, {
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    String path = '/community/post_question';

    Map<String, dynamic> data = {
      'title': title,
      'content': content,
      'tags': tags,
      'media_key': mediaKey,
      'media_type': mediaType,
      'type': type,
      'options': options,
      'option_media_key_list': optionMediaKeyList,
      'option_media_type_list': optionMediaTypeList,
      'category': category,
      'point': point,
      'closure_requirement': closureRequirement,
      'due_date': dueDate != null
          ? DateFormat('yyyy-MM-dd-H:mm').format(dueDate)
          : null,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> updateQuestion(
    int id,
    String title,
    String content,
    List<String>? tags,
    String? mediaKey,
    int? mediaType,
    int type,
    List<String>? options,
    List<String?>? optionMediaKeyList,
    List<int?>? optionMediaTypeList,
    int category,
    int point,
    int closureRequirement,
    DateTime? dueDate,
  ) async {
    String path = '/community/update_question';

    Map<String, dynamic> data = {
      'id': id,
      'title': title,
      'content': content,
      'tags': tags,
      'media_key': mediaKey,
      'media_type': mediaType,
      'type': type,
      'options': options,
      'option_media_key_list': optionMediaKeyList,
      'option_media_type_list': optionMediaTypeList,
      'category': category,
      'point': point,
      'closure_requirement': closureRequirement,
      'due_date': dueDate != null
          ? DateFormat('yyyy-MM-dd-H:mm').format(dueDate)
          : null,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getQuestion(int id) async {
    String path = '/community/get_question';

    Map<String, dynamic> parameters = {
      'id': id,
    };

    try {
      var res = await ApiService.getWithoutToken(path, parameters);
      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      print(e);
      return {};
    }
  }

  static Future<dynamic> getQuestionCount(int id) async {
    String path = '/community/get_question_count';

    Map<String, dynamic> parameters = {
      'id': id,
    };

    try {
      var res = await ApiService.getWithoutToken(path, parameters);
      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      print(e);
      return {};
    }
  }

  static Future<dynamic> getOptionAnswers(int id) async {
    String path = '/community/get_option_answers';

    Map<String, dynamic> parameters = {
      'id': id,
    };

    try {
      var res = await ApiService.get(path, parameters);
      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      print(e);
      return {};
    }
  }

  static Future<dynamic> getCommentAnswers(int id) async {
    String path = AuthController.to.isAuthenticated.value
        ? '/community/get_comment_answers/auth'
        : '/community/get_comment_answers';

    Map<String, dynamic> parameters = {
      'id': id,
    };

    try {
      var res = AuthController.to.isAuthenticated.value
          ? await ApiService.get(path, parameters)
          : await ApiService.getWithoutToken(path, parameters);
      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      print(e);
      return {};
    }
  }

  static Future<dynamic> postOptionAnswer(int optionId) async {
    String path = '/community/post_option_answer';

    Map<String, dynamic> data = {
      'option_id': optionId,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> postSelectedComments(List commentIds) async {
    String path = '/community/post_selected_comments';

    Map<String, dynamic> data = {
      'comment_ids': commentIds,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> postComment(
      int questionId, String content, String? mediaKey, int? mediaType) async {
    String path = '/community/post_comment';

    Map<String, dynamic> data = {
      'question_id': questionId,
      'content': content,
      'media_key': mediaKey,
      'media_type': mediaType,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> postReply(
      int commentId, String content) async {
    String path = '/community/post_reply';

    Map<String, dynamic> data = {
      'comment_id': commentId,
      'content': content,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> updateComment(
      int commentId, String content, String? mediaKey, int? mediaType) async {
    String path = '/community/update_comment';

    Map<String, dynamic> data = {
      'comment_id': commentId,
      'content': content,
      'media_key': mediaKey,
      'media_type': mediaType,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> updateReply(
      int replyId, String content) async {
    String path = '/community/update_reply';

    Map<String, dynamic> data = {
      'reply_id': replyId,
      'content': content,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> delete(int id, String category) async {
    String path = '/community/delete';

    Map<String, dynamic> data = {'id': id, 'instance': category};

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> report(
      int id, String instance, List categoryList) async {
    String path = '/community/report';

    Map<String, dynamic> data = {
      'id': id,
      'instance': instance,
      'categories': categoryList,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> reportUser(String username) async {
    String path = '/community/report_user';

    Map<String, dynamic> data = {'username': username};

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> block(String username) async {
    String path = '/community/block_user';

    Map<String, dynamic> data = {'username': username};

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
