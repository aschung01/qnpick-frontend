import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/community_write_controller.dart';
import 'package:qnpick/core/services/amplify_service.dart';
import 'package:qnpick/core/services/community_api_service.dart';
import 'package:video_player/video_player.dart';

class CommunityController extends GetxController {
  static CommunityController to = Get.find<CommunityController>();

  final ImagePicker mediaPicker = ImagePicker();
  FocusNode commentFocusNode = FocusNode();

  RxBool loading = false.obs;
  RxBool initialLoading = true.obs;

  TextEditingController commentTextController = TextEditingController();

  ScrollController questionListScrollController = ScrollController();
  RefreshController questionListRefreshController = RefreshController();

  PainterController painterController = PainterController();
  VideoPlayerController? videoPlayerController;
  XFile? commentMediaFile;
  RxInt commentMediaFileType = 0.obs;
  RxInt focusedComment = (-1).obs;
  RxInt focusedReply = (-1).obs;

  RxList<bool> filterCategoryTapList = [false, false, false].obs;
  RxInt filter = 0.obs;
  RxList filterCategoryList = [].obs;
  RxList<dynamic> textQuestionList = [].obs;
  RxList<dynamic> imageQuestionList = [].obs;
  RxList<dynamic> videoQuestionList = [].obs;
  RxMap<String, dynamic> questionData = <String, dynamic>{}.obs;
  RxMap<String, dynamic> questionCountData = <String, dynamic>{}.obs;
  RxList<dynamic> comments = [].obs;
  RxList<dynamic> optionCountData = [].obs;

  RxInt mediaType = 0.obs;
  RxBool seeClosed = false.obs;
  RxBool commentSelectMode = false.obs;
  RxBool replyMode = false.obs;
  RxList<int> selectedComments = <int>[].obs;
  RxInt selectedOption = (-1).obs;
  RxInt questionListStartIndex = 0.obs;
  RxList reportCategoryList = [].obs;

  @override
  void onInit() async {
    questionListScrollController.addListener(onQuestionListScroll);
    filter.listen(onFilterChanged);
    super.onInit();
  }

  @override
  void onClose() {
    questionListScrollController.removeListener(onQuestionListScroll);
    questionListScrollController.dispose();
    super.onClose();
  }

  void reset() {
    loading.value = false;
    initialLoading.value = true;
    commentTextController.clear();
    commentMediaFile = null;
    commentMediaFileType.value = 0;

    filterCategoryTapList.value = [false, false, false];
    filter.value = 0;
    filterCategoryList.value = [];
    textQuestionList.value = [];
    imageQuestionList.value = [];
    videoQuestionList.value = [];
    questionData.clear();
    questionCountData.clear();
    comments.value = [];
    optionCountData.value = [];

    selectedOption.value = -1;
    focusedComment.value = -1;
    commentFocusNode.unfocus();
    questionListStartIndex.value = 0;
  }

  void resetQuestionPage() {
    loading.value = false;
    commentTextController.clear();
    commentMediaFile = null;
    commentMediaFileType.value = 0;

    questionData.clear();
    questionCountData.clear();
    comments.value = [];
    optionCountData.value = [];

    selectedOption.value = -1;
    focusedComment.value = -1;
    commentFocusNode.unfocus();
  }

  void onFilterChanged(int val) async {
    if (val == 0) {
      initialLoading.value = true;
      questionListStartIndex.value = 0;
      filterCategoryList.value = [for (var i = 0; i < 26; i++) i];
      Get.back();
      if (mediaType.value == 0) {
        textQuestionList.clear();
      } else if (mediaType.value == 1) {
        imageQuestionList.clear();
      } else {
        videoQuestionList.clear();
      }
      await getQuestionList();
      initialLoading.value = false;
    } else if (val == 1) {
      Get.back();
      if (AuthController.to.isAuthenticated.value) {
        initialLoading.value = true;
        questionListStartIndex.value = 0;
        await AuthController.to.getUserInfoIfEmpty();
        filterCategoryList.clear();
        filterCategoryList
            .addAll(AuthController.to.userInfo['interest_categories']);
        if (mediaType.value == 0) {
          textQuestionList.clear();
        } else if (mediaType.value == 1) {
          imageQuestionList.clear();
        } else {
          videoQuestionList.clear();
        }
        await getQuestionList();
        initialLoading.value = false;
      } else {
        filter.value = 0;
        Get.toNamed('/auth');
      }
    } else {}
  }

  void onSeeClosedChanged(bool val) async {
    initialLoading.value = true;
    seeClosed.value = val;
    print(seeClosed.value);
    questionListStartIndex.value = 0;
    if (mediaType.value == 0) {
      textQuestionList.clear();
    } else if (mediaType.value == 1) {
      imageQuestionList.clear();
    } else {
      videoQuestionList.clear();
    }
    await getQuestionList();
    Get.back();
    initialLoading.value = false;
  }

  void onDetailFilterCompletePressed() async {
    initialLoading.value = true;
    Get.back();
    if (mediaType.value == 0) {
      textQuestionList.clear();
    } else if (mediaType.value == 1) {
      imageQuestionList.clear();
    } else {
      videoQuestionList.clear();
    }
    await getQuestionList();
    initialLoading.value = false;
  }

  void onQuestionListScroll() {
    if (questionListScrollController.position.extentAfter < 300 &&
        !loading.value) {
      if (mediaType.value == 0) {
        questionListStartIndex.value = textQuestionList.length;
      } else if (mediaType.value == 1) {
        questionListStartIndex.value = imageQuestionList.length;
      } else {
        questionListStartIndex.value = videoQuestionList.length;
      }
    }
    update();
  }

  void onQuestionListLoadMore() async {
    if (mediaType.value == 0) {
      if (textQuestionList.length >= 20) {
        loading.value = true;
        await getQuestionList();
        loading.value = false;
      }
      questionListRefreshController.loadComplete();
    } else if (mediaType.value == 1) {
      if (imageQuestionList.length >= 20) {
        loading.value = true;
        await getQuestionList();
        loading.value = false;
      }
      questionListRefreshController.loadComplete();
    } else {
      if (videoQuestionList.length >= 20) {
        loading.value = true;
        await getQuestionList();
        loading.value = false;
      }
      questionListRefreshController.loadComplete();
    }
  }

  void questionPageInit(int id) async {
    questionData.clear();
    questionCountData.clear();
    loading.value = true;
    Get.toNamed('/question');
    await getQuestion(id);
    await getQuestionCount(id);
    if (questionData['type'] == 1) {
      await getCommentAnswers(id);
    }
    if (AuthController.to.isAuthenticated.value && questionData['type'] == 0) {
      await getOptionAnswers(id);
    }
    loading.value = false;
  }

  void onCommentDrawComplete(File file) {
    commentMediaFile = XFile(file.path);
    commentMediaFileType.value = 0;
    update();
  }

  Future<void> pickCommentImageFile() async {
    commentMediaFile = await mediaPicker.pickImage(source: ImageSource.gallery);
    commentMediaFileType.value = 0;
    update();
  }

  Future<void> pickCommentVideoFile() async {
    commentMediaFile = await mediaPicker.pickVideo(source: ImageSource.gallery);
    videoPlayerController = VideoPlayerController.file(
      File(commentMediaFile!.path),
    );
    await videoPlayerController!.initialize();
    commentMediaFileType.value = 1;
    update();
  }

  void removeCommentMediaFile() async {
    commentMediaFile = null;
    update();
  }

  Future<void> getQuestionList() async {
    var resData = await CommunityApiService.getQuestionPreviewList(
      questionListStartIndex.value,
      seeClosed.value,
      filter.value,
      mediaType.value,
      filter.value == 0 ? null : filterCategoryList.toList(),
    );
    if (mediaType.value == 0) {
      textQuestionList.addAll(resData);
    } else if (mediaType.value == 1) {
      imageQuestionList.addAll(resData);
    } else {
      videoQuestionList.addAll(resData);
    }
  }

  Future<void> getQuestion(int id) async {
    var resData = await CommunityApiService.getQuestion(id);
    questionData.value = resData['question_data'];
    if (questionData['type'] == 0) {
      questionData['options'] = resData['options'];
    }
    questionData['username'] = resData['username'];
  }

  Future<void> getQuestionCount(int id) async {
    var resData = await CommunityApiService.getQuestionCount(id);
    questionCountData.value = resData;
  }

  Future<void> getOptionAnswers(int id) async {
    var resData = await CommunityApiService.getOptionAnswers(id);

    optionCountData.value = resData;
  }

  Future<void> getCommentAnswers(int id) async {
    var resData = await CommunityApiService.getCommentAnswers(id);

    comments.value = resData;
  }

  Future<void> postOptionAnswer() async {
    if (selectedOption.value >= 0) {
      EasyLoading.show();
      var success = await CommunityApiService.postOptionAnswer(
          questionData['options'][selectedOption.value]['id']);
      if (success) {
        await getOptionAnswers(questionData['id']);
        await getQuestionCount(questionData['id']);
        EasyLoading.showSuccess("답변이 업로드되었습니다");
        EasyLoading.dismiss();
        selectedOption.value = -1;
      } else {
        EasyLoading.showError("답변을 업로드하지 못했습니다\n잠시 후 다시 시도해주세요");
        EasyLoading.dismiss();
      }
    }
  }

  Future<void> postCommentSelection() async {
    if (selectedComments.isNotEmpty) {
      EasyLoading.show();
      List idList = [];
      selectedComments.forEach((idx) {
        idList.add(comments[idx]['id']);
      });
      var success = await CommunityApiService.postSelectedComments(idList);
      if (success) {
        await getQuestionCount(questionData['id']);
        EasyLoading.showSuccess("질문이 마감되었습니다");
        EasyLoading.dismiss();
        selectedComments.clear();
        commentSelectMode.value = false;
      } else {
        EasyLoading.showError("오류가 발생했습니다.\n잠시 후 다시 시도해주세요");
        EasyLoading.dismiss();
      }
    }
  }

  Future<void> postComment() async {
    if (commentTextController.text.isNotEmpty || commentMediaFile != null) {
      EasyLoading.show();
      String? _commentMediaKey;

      commentTextController.text = CommunityWriteController.to.profanityFilter
          .censor(commentTextController.text);

      if (commentMediaFile != null) {
        _commentMediaKey = await AmplifyService.uploadFile(
            commentMediaFile!, commentMediaFileType.value);
        if (_commentMediaKey == null) {
          EasyLoading.showError("미디어 파일 업로드에 실패했습니다");
        }
      }
      var success = await CommunityApiService.postComment(
        questionData['id'],
        commentTextController.text,
        _commentMediaKey,
        commentMediaFileType.value,
      );

      if (success) {
        await getCommentAnswers(questionData['id']);
        await getQuestionCount(questionData['id']);
        EasyLoading.showSuccess("답변이 업로드되었습니다");
        EasyLoading.dismiss();
        commentTextController.clear();
        removeCommentMediaFile();
      } else {
        EasyLoading.showError("답변을 업로드하지 못했습니다\n잠시 후 다시 시도해주세요");
        EasyLoading.dismiss();
      }
    }
  }

  Future<void> postReply() async {
    if (commentTextController.text.isNotEmpty) {
      EasyLoading.show();

      commentTextController.text = CommunityWriteController.to.profanityFilter
          .censor(commentTextController.text);

      var success = await CommunityApiService.postReply(
        comments[focusedComment.value]['id'],
        commentTextController.text,
      );

      if (success) {
        await getCommentAnswers(questionData['id']);
        await getQuestionCount(questionData['id']);
        EasyLoading.showSuccess("대댓글이 업로드되었습니다");
        EasyLoading.dismiss();
        commentTextController.clear();
      } else {
        EasyLoading.showError("대댓글을 업로드하지 못했습니다\n잠시 후 다시 시도해주세요");
        EasyLoading.dismiss();
      }
    }
  }

  Future<void> updateComment() async {
    if (commentTextController.text.isNotEmpty || commentMediaFile != null) {
      EasyLoading.show();
      String? _commentMediaKey = comments[focusedComment.value]['media_key'];
      commentMediaFileType.value = comments[focusedComment.value]['media_type'];

      commentTextController.text = CommunityWriteController.to.profanityFilter
          .censor(commentTextController.text);

      if (commentMediaFile != null) {
        if (comments[focusedComment.value]['media_key'] != null) {
          var removeRes = await AmplifyService.removeFile(
              comments[focusedComment.value]['media_key']);
          if (!removeRes) {
            EasyLoading.showError("미디어 파일 삭제에 실패했습니다");
          }
        }
        _commentMediaKey = await AmplifyService.uploadFile(
            commentMediaFile!, commentMediaFileType.value);
        if (_commentMediaKey == null) {
          EasyLoading.showError("미디어 파일 업로드에 실패했습니다");
        }
      }
      if (comments[focusedComment.value]['delete_media'] == true) {
        var removeRes = await AmplifyService.removeFile(
            comments[focusedComment.value]['media_key']);

        if (removeRes) {
          _commentMediaKey = null;
        } else {
          EasyLoading.showError("미디어 파일 삭제에 실패했습니다");
        }
      }
      var success = await CommunityApiService.updateComment(
        comments[focusedComment.value]['id'],
        commentTextController.text,
        _commentMediaKey,
        commentMediaFileType.value,
      );

      if (success) {
        await getCommentAnswers(questionData['id']);
        await getQuestionCount(questionData['id']);
        EasyLoading.showSuccess("답변이 수정되었습니다");
        EasyLoading.dismiss();
        commentTextController.clear();
        removeCommentMediaFile();
      } else {
        EasyLoading.showError("오류가 발생했습니다\n잠시 후 다시 시도해주세요");
        EasyLoading.dismiss();
      }
    }
  }

  Future<void> updateReply() async {
    if (commentTextController.text.isNotEmpty) {
      EasyLoading.show();

      commentTextController.text = CommunityWriteController.to.profanityFilter
          .censor(commentTextController.text);

      var success = await CommunityApiService.updateReply(
        comments[focusedComment.value]['replies'][focusedReply.value]['id'],
        commentTextController.text,
      );

      if (success) {
        await getCommentAnswers(questionData['id']);
        await getQuestionCount(questionData['id']);
        EasyLoading.showSuccess("대댓글이 수정되었습니다");
        EasyLoading.dismiss();
        commentTextController.clear();
      } else {
        EasyLoading.showError("오류가 발생했습니다\n잠시 후 다시 시도해주세요");
        EasyLoading.dismiss();
      }
    }
  }

  Future<bool> report(int id, String instance, List categoryList) async {
    return await CommunityApiService.report(id, instance, categoryList);
  }

  Future<bool> reportUser(String username) async {
    return await CommunityApiService.reportUser(username);
  }

  Future<bool> blockUser(String username) async {
    return await CommunityApiService.block(username);
  }

  Future<void> delete(int id, String instance) async {
    EasyLoading.show();
    var res = await CommunityApiService.delete(id, instance);
    if (instance == 'comment_answer') {
      if (comments[focusedComment.value]['media_key'] != null) {
        var removeRes = await AmplifyService.removeFile(
            comments[focusedComment.value]['media_key']);

        if (!removeRes) {
          EasyLoading.showError("미디어 파일 삭제에 실패했습니다");
        }
      }
      if (res) {
        EasyLoading.showSuccess("댓글을 성공적으로 삭제했습니다");
      }
    } else if (instance == 'comment_reply') {
      if (res) {
        EasyLoading.showSuccess("대댓글을 성공적으로 삭제했습니다");
      }
    } else {
      if (res) {
        EasyLoading.showSuccess("질문을 성공적으로 삭제했습니다");
      }
    }
    EasyLoading.dismiss();
  }
}
