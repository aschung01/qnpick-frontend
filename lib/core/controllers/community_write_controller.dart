import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:qnpick/core/controllers/community_controller.dart';
import 'package:qnpick/core/controllers/map_controller.dart';
import 'package:qnpick/core/services/amplify_service.dart';
import 'package:qnpick/core/services/community_api_service.dart';
import 'package:qnpick/helpers/animated_list_model.dart';
import 'package:qnpick/ui/widgets/input_fields.dart';
import 'package:video_player/video_player.dart';

class CommunityWriteController extends GetxController {
  static CommunityWriteController to = Get.find<CommunityWriteController>();

  PainterController painterController = PainterController();
  late ProfanityFilter profanityFilter;
  final ImagePicker mediaPicker = ImagePicker();
  final GlobalKey<AnimatedListState> optionListKey =
      GlobalKey<AnimatedListState>();
  late ListModel<TextEditingController> optionList;
  TextEditingController titleTextController = TextEditingController();
  TextEditingController contentTextController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  VideoPlayerController? videoPlayerController;
  List<TextEditingController> options = [
    TextEditingController(),
    TextEditingController(),
  ];

  int type = 0; //0: 선다형, 1: 댓글형
  RxInt category = (-1).obs;
  RxInt point = 100.obs;
  RxInt closureRequirement = 10.obs;
  RxBool seeCategory = false.obs;
  Rx<DateTime?> dueDateTime = Rx<DateTime?>(null);
  List<String> initialTags = <String>[];
  XFile? mediaFile;
  RxInt mediaFileType = 0.obs;
  Rx<String?> mediaKey = Rx<String?>(null);
  RxList<String?> optionMediaKeyList = <String?>[].obs;
  List<List<dynamic>> optionMediaFileList = [
    [null, 0],
    [null, 0]
  ];
  Map<int, VideoPlayerController> optionVideoPlayerControllerMap = {};

  @override
  void onInit() async {
    super.onInit();
    optionList = ListModel<TextEditingController>(
      listKey: optionListKey,
      initialItems: options,
      removedItemBuilder: _buildRemovedOptionItem,
    );
    String _fwordListStr = await rootBundle.loadString('assets/fword_list.txt');
    List<String> _fwordList =
        const LineSplitter().convert(_fwordListStr).map((s) => s).toList();
    profanityFilter = ProfanityFilter.filterAdditionally(_fwordList);
  }

  @override
  void onClose() {
    tagsController.dispose();
    super.onClose();
  }

  Widget _buildRemovedOptionItem(int index, TextEditingController controller,
      BuildContext context, Animation<double> animation) {
    return OptionInputField(
      onChanged: (p0) {
        CommunityWriteController.to.update();
      },
      index: index + 1,
      animation: animation,
      controller: controller,
      onDeletePressed: () {},
      onAddMediaPressed: () {},
      onRemoveMediaPressed: () => removeOptionMediaFile(index),
      mediaFile: null,
      videoPlayerController: optionVideoPlayerControllerMap[index],
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  void reset() {
    titleTextController.clear();
    contentTextController.clear();
    tagsController.clear();
    CommunityController.to.questionData.remove('delete_media');
    if (CommunityController.to.questionData['options'] != null) {
      CommunityController.to.questionData['options'].forEach((option) {
        option.remove('delete_media');
      });
    }
    initialTags.clear();
    options = [
      TextEditingController(),
      TextEditingController(),
    ];
    optionList = ListModel<TextEditingController>(
      listKey: optionListKey,
      initialItems: options,
      removedItemBuilder: _buildRemovedOptionItem,
    );
    type = 0;
    category.value = -1;
    point.value = 100;
    closureRequirement.value = 10;
    dueDateTime.value = null;
    videoPlayerController = null;
    mediaFile = null;
    mediaFileType.value = 0;
    optionMediaFileList = [
      [null, 0],
      [null, 0]
    ];
    mediaKey.value = null;
    optionMediaKeyList.value = <String?>[];
  }

  void updateType(int val) {
    type = val;
    update();
  }

  void onDrawComplete(File file) {
    mediaFile = XFile(file.path);
    mediaFileType.value = 0;
    update();
  }

  Future<void> pickImageFile() async {
    mediaFile = await mediaPicker.pickImage(source: ImageSource.gallery);
    mediaFileType.value = 0;
    update();
  }

  Future<void> pickVideoFile() async {
    mediaFile = await mediaPicker.pickVideo(source: ImageSource.gallery);
    videoPlayerController = VideoPlayerController.file(
      File(mediaFile!.path),
    );
    await videoPlayerController!.initialize();
    mediaFileType.value = 1;
    update();
  }

  void removeMediaFile() async {
    mediaFile = null;
    videoPlayerController?.pause();
    videoPlayerController?.dispose();
    update();
  }

  void addOption() {
    options.add(TextEditingController());
    optionMediaFileList.add([null, 0]);
    optionMediaKeyList.add(null);
    optionList.insert(options.last);
    update();
  }

  void deleteOption(int index) {
    options.removeAt(index);
    optionList.removeAt(index);
    optionMediaFileList.removeAt(index);
    optionMediaKeyList.removeAt(index);
    update();
  }

  void onOptionDrawComplete(int index, File file) {
    var _file = XFile(file.path);
    optionMediaFileList[index][0] = _file;
    optionMediaFileList[index][1] = 0;
    update();
  }

  Future<void> pickOptionImageFile(int index) async {
    var _file = await mediaPicker.pickImage(source: ImageSource.gallery);
    optionMediaFileList[index][0] = _file;
    optionMediaFileList[index][1] = 0;
    update();
  }

  Future<void> pickOptionVideoFile(int index) async {
    var _file = await mediaPicker.pickVideo(source: ImageSource.gallery);
    optionMediaFileList[index][0] = _file;
    optionMediaFileList[index][1] = 1;
    optionVideoPlayerControllerMap[index] =
        VideoPlayerController.file(File(_file!.path));
    await optionVideoPlayerControllerMap[index]!.initialize();
    update();
  }

  void removeOptionMediaFile(int index) async {
    optionMediaFileList[index] = [null, 0];
    optionVideoPlayerControllerMap[index]?.pause();
    optionVideoPlayerControllerMap[index]?.dispose();
    optionVideoPlayerControllerMap.remove(index);
    update();
  }

  Future<bool> postQuestion() async {
    EasyLoading.show();
    List<String>? _options =
        type == 0 ? options.map((element) => element.text).toList() : null;
    String? _mediaKey;
    List<String?>? _optionMediaKeyList;
    List<int?>? _optionMediaTypeList;
    try {
      titleTextController.text =
          profanityFilter.censor(titleTextController.text);
      contentTextController.text =
          profanityFilter.censor(contentTextController.text);

      if (mediaFile != null) {
        _mediaKey =
            await AmplifyService.uploadFile(mediaFile!, mediaFileType.value);
        if (_mediaKey == null) {
          EasyLoading.showError("미디어 파일 업로드에 실패했습니다");
        }
      }

      if (type == 0) {
        _optionMediaKeyList = [];
        _optionMediaTypeList = [];
        for (int i = 0; i < optionMediaFileList.length; i++) {
          if (optionMediaFileList[i][0] != null) {
            _optionMediaKeyList.add(await AmplifyService.uploadFile(
                optionMediaFileList[i][0]!, optionMediaFileList[i][1]!));
            _optionMediaTypeList.add(optionMediaFileList[i][1]);
          } else {
            _optionMediaKeyList.add(null);
            _optionMediaTypeList.add(null);
          }
        }
      }

      List<String>? tagsList;

      if (tagsController.text.isNotEmpty) {
        tagsList = tagsController.text.split(' ');
        String _newStr = '';
        for (int i = 0; i < tagsList.length; i++) {
          if (tagsList[i].isNotEmpty) {
            if (!tagsList[i].contains('#')) {
              tagsList[i] = '#${tagsList[i]}';
            }
            _newStr += '${tagsList[i]} ';
          }
        }
        tagsController.text = _newStr;
        tagsController.selection = TextSelection.fromPosition(
            TextPosition(offset: tagsController.text.length));
      }

      print(MapController.to.useLocation);
      var success = await CommunityApiService.postQuestion(
        titleTextController.text,
        contentTextController.text,
        tagsList?.isNotEmpty != true ? null : tagsList,
        _mediaKey,
        _mediaKey != null ? mediaFileType.value : null,
        type,
        _options,
        _optionMediaKeyList,
        _optionMediaTypeList,
        category.value,
        point.value,
        closureRequirement.value,
        dueDateTime.value,
        latitude: MapController.to.useLocation
            ? MapController.to.circlePosition.value?.latitude
            : null,
        longitude: MapController.to.useLocation
            ? MapController.to.circlePosition.value?.longitude
            : null,
        radius:
            MapController.to.useLocation ? MapController.to.radius.value : null,
      );

      if (success) {
        EasyLoading.showSuccess("질문이 게시되었습니다");
        return true;
      } else {
        EasyLoading.showError("오류가 발생했습니다.\n잠시 후 다시 시도해 주세요");
        return false;
      }
    } catch (e) {
      EasyLoading.showError("오류가 발생했습니다.\n잠시 후 다시 시도해 주세요");
      print(e);
    }
    EasyLoading.dismiss();
    return false;
  }

  Future<bool> updateQuestion(int id) async {
    EasyLoading.show();
    List<String>? _options =
        type == 0 ? options.map((element) => element.text).toList() : null;
    String? _mediaKey = CommunityController.to.questionData['media_key'];
    mediaFileType.value =
        CommunityController.to.questionData['media_type'] ?? 0;
    List<String?>? _optionMediaKeyList;
    List<int?>? _optionMediaTypeList;

    titleTextController.text = profanityFilter.censor(titleTextController.text);
    contentTextController.text =
        profanityFilter.censor(contentTextController.text);

    if (mediaFile != null) {
      if (CommunityController.to.questionData['media_key'] != null) {
        var removeRes = await AmplifyService.removeFile(
            CommunityController.to.questionData['media_key']);
        if (!removeRes) {
          EasyLoading.showError("미디어 파일 삭제에 실패했습니다");
        }
      }
      _mediaKey =
          await AmplifyService.uploadFile(mediaFile!, mediaFileType.value);
      if (_mediaKey == null) {
        EasyLoading.showError("미디어 파일 업로드에 실패했습니다");
      }
    }
    if (CommunityController.to.questionData['delete_media'] == true) {
      var removeRes = await AmplifyService.removeFile(
          CommunityController.to.questionData['media_key']);

      if (removeRes) {
        _mediaKey = null;
      } else {
        EasyLoading.showError("미디어 파일 삭제에 실패했습니다");
      }
    }

    if (type == 0) {
      _optionMediaKeyList = [];
      _optionMediaTypeList = [];
      for (int i = 0; i < optionMediaFileList.length; i++) {
        if (optionMediaFileList[i][0] != null) {
          _optionMediaKeyList.add(await AmplifyService.uploadFile(
              optionMediaFileList[i][0]!, optionMediaFileList[i][1]!));
          _optionMediaTypeList.add(optionMediaFileList[i][1]);
        } else if (optionMediaKeyList[i] != null) {
          _optionMediaKeyList.add(optionMediaKeyList[i]);
          _optionMediaTypeList.add(optionMediaFileList[i][1]);
        } else {
          _optionMediaKeyList.add(null);
          _optionMediaTypeList.add(null);
        }

        if (CommunityController.to.questionData['options'][i]['delete_media'] ==
            true) {
          var removeRes = await AmplifyService.removeFile(
              CommunityController.to.questionData['options'][i]['media_key']);

          if (removeRes) {
            _optionMediaKeyList[i] = null;
            _optionMediaTypeList[i] = null;
          } else {
            EasyLoading.showError("미디어 파일 삭제에 실패했습니다");
          }
        }
      }
    }

    List<String>? tagsList;

    if (tagsController.text.isNotEmpty) {
      tagsList = tagsController.text.split(' ');
      String _newStr = '';
      for (int i = 0; i < tagsList.length; i++) {
        if (tagsList[i].isNotEmpty) {
          if (!tagsList[i].contains('#')) {
            tagsList[i] = '#${tagsList[i]}';
          }
          _newStr += '${tagsList[i]} ';
        }
      }
      tagsController.text = _newStr;
      tagsController.selection = TextSelection.fromPosition(
          TextPosition(offset: tagsController.text.length));
    }

    var success = await CommunityApiService.updateQuestion(
      id,
      titleTextController.text,
      contentTextController.text,
      tagsList?.isNotEmpty != true ? null : tagsList,
      _mediaKey,
      _mediaKey != null ? mediaFileType.value : null,
      type,
      _options,
      _optionMediaKeyList,
      _optionMediaTypeList,
      category.value,
      point.value,
      closureRequirement.value,
      dueDateTime.value,
    );

    if (success) {
      EasyLoading.showSuccess("질문이 수정되었습니다");
      EasyLoading.dismiss();
      return true;
    } else {
      EasyLoading.showError("오류가 발생했습니다.\n잠시 후 다시 시도해 주세요");
      EasyLoading.dismiss();
      return false;
    }
  }
}
