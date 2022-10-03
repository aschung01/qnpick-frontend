import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/map_controller.dart';
import 'package:qnpick/core/controllers/settings_controller.dart';
import 'package:qnpick/helpers/utils.dart';
import 'package:qnpick/ui/widgets/buttons.dart';
import 'package:qnpick/ui/widgets/header.dart';
import 'package:qnpick/ui/widgets/input_fields.dart';

const String _titleText = '새 닉네임을 입력해 주세요';
const String _textFieldLabelText = '닉네임';
const String _completeButtonText = '완료';

class UpdateInterestLocalPage extends GetView<MapController> {
  const UpdateInterestLocalPage({Key? key}) : super(key: key);

  void _onBackPressed() {
    Get.back();
  }

  void _onCompletePressed() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            GetX<MapController>(builder: (_) {
              return NaverMap(
                useSurface: kReleaseMode,
                initLocationTrackingMode: controller.trackingMode,
                initialCameraPosition: !hasLocationPermission(_.permission)
                    ? CameraPosition(
                        target: _.initLocation!,
                        zoom: 11,
                      )
                    : null,
                locationButtonEnable: true,
                onMapCreated: (NaverMapController ct) async {
                  if (_.initLocation == null) {
                    var cp = await ct.getCameraPosition();
                    _.circlePosition = cp.target.obs;
                  }

                  ct.setLocationTrackingMode(LocationTrackingMode.NoFollow);
                },
                contentPadding: const EdgeInsets.only(bottom: 55),
                onCameraChange: (latLng, reason, isAnimated) {
                  _.circlePosition.value = latLng ?? _.initLocation;
                },
                tiltGestureEnable: false,
                symbolScale: 1.1,
                circles: [
                  CircleOverlay(
                    overlayId: 'circle',
                    center: _.circlePosition.value,
                    radius: 5000,
                    color: brightPrimaryColor.withOpacity(0.3),
                    outlineColor: brightPrimaryColor,
                    outlineWidth: 3,
                  )
                ],
              );
            }),
            Positioned(
              top: 0,
              child: SizedBox(
                height: 56,
                width: context.width,
                child: Header(
                  onPressed: _onBackPressed,
                  title: '관심 지역 설정',
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              child: Center(
                child: GetX<SettingsController>(
                  builder: (_) {
                    if (_.loading.value) {
                      return const CircularProgressIndicator(
                          color: brightPrimaryColor);
                    } else {
                      return ElevatedActionButton(
                        buttonText: _completeButtonText,
                        onPressed: _onCompletePressed,
                        width: 330,
                        height: 50,
                        backgroundColor: brightPrimaryColor,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        activated: _.isUsernameValid.value &&
                            _.isUsernameAvailable.value,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
