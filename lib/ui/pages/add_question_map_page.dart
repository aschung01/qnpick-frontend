import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/controllers/community_write_controller.dart';
import 'package:qnpick/core/controllers/map_controller.dart';
import 'package:qnpick/helpers/utils.dart';
import 'package:qnpick/ui/widgets/buttons.dart';
import 'package:qnpick/ui/widgets/custom_bottom_sheets.dart';

const String _questionButtonText = '이 지역에 질문';

class AddQuestionMapPage extends GetView<MapController> {
  const AddQuestionMapPage({Key? key}) : super(key: key);

  void _onAddQuestionPressed() async {
    getAddMapQuestionSheet(
      onWriteOptionQuestionPressed: _onWriteOptionQuestionPressed,
      onWriteCommentQuestionPressed: _onWriteCommentQuestionPressed,
      onBackPressed: () {
        Get.back();
      },
    );
  }

  void _onWriteOptionQuestionPressed() {
    Get.back();
    if (AuthController.to.isAuthenticated.value) {
      CommunityWriteController.to.updateType(0);
      controller.useLocation = true;
      CommunityWriteController.to.point.value = 10;
      Get.toNamed('/write');
    } else {
      Get.toNamed('/auth');
    }
  }

  void _onWriteCommentQuestionPressed() {
    Get.back();
    if (AuthController.to.isAuthenticated.value) {
      CommunityWriteController.to.updateType(1);
      controller.useLocation = true;
      CommunityWriteController.to.point.value = 100;
      Get.toNamed('/write');
    } else {
      Get.toNamed('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      controller.postUserLocation();
    });

    return Stack(
      alignment: Alignment.center,
      children: [
        GetX<MapController>(builder: (_) {
          return NaverMap(
            useSurface: false,
            initLocationTrackingMode: controller.trackingMode,
            initialCameraPosition: hasLocationPermission(controller.permission)
                ? CameraPosition(
                    target: controller.initLocation ?? const LatLng(37.5, 127),
                    zoom: 11,
                  )
                : null,
            locationButtonEnable: hasLocationPermission(_.permission),
            onMapCreated: (NaverMapController ct) async {
              if (controller.initLocation == null) {
                var cp = await ct.getCameraPosition();
                controller.circlePosition.value = cp.target;
                ct.moveCamera(CameraUpdate.toCameraPosition(
                  CameraPosition(
                    target: cp.target,
                    zoom: 11,
                  ),
                ));
              }
              ct.setLocationTrackingMode(LocationTrackingMode.NoFollow);
            },
            contentPadding: const EdgeInsets.only(bottom: 55),
            onCameraChange: (latLng, reason, isAnimated) {
              if (latLng != null) {
                var distance = getDistanceBetweenPositions(
                    controller.circlePosition.value ?? latLng, latLng);
                if (distance > 500) {
                  controller.circlePosition.value = latLng;
                  controller.getNeighbors();
                  print(latLng);
                  inspect(reason);
                }
              }
            },
            tiltGestureEnable: false,
            symbolScale: 1.1,
            markers: () {
              List<Marker> _markerList = <Marker>[];
              for (int i = 0; i < _.neighbors.length; i++) {
                _markerList.add(
                  Marker(
                    height: 38,
                    width: 27,
                    icon: _.markerImage.value,
                    markerId: i.toString(),
                    position: _.neighbors[i],
                  ),
                );
              }
              return _markerList;
            }(),
            circles: _.circlePosition.value != null
                ? [
                    CircleOverlay(
                      overlayId: 'circle',
                      center: _.circlePosition.value,
                      radius: _.radius.value,
                      color: brightPrimaryColor.withOpacity(0.3),
                      outlineColor: brightPrimaryColor,
                      outlineWidth: 3,
                    )
                  ]
                : [],
          );
        }),
        GetBuilder<MapController>(
          builder: (_) {
            if (!hasLocationPermission(controller.permission)) {
              return Positioned(
                left: 14,
                bottom: 98,
                child: Container(
                  width: 45,
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0.5, 0.5),
                        color: deepGrayColor,
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: InkWell(
                      onTap: () {
                        if (_.permission == LocationPermission.denied) {
                          Permission.location.request();
                        } else {
                          Get.dialog(
                            AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '위치 권한을 허용하려면 휴대폰 설정에서 변경해 주세요',
                                    style: TextStyle(
                                      color: darkPrimaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextActionButton(
                                    buttonText: '설정으로 이동',
                                    onPressed: () async {
                                      openAppSettings();
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      },
                      child: const Icon(
                        PhosphorIcons.crosshairSimpleLight,
                        size: 28,
                      )),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
        Positioned(
          left: 14,
          bottom: 180,
          child: RotatedBox(
            quarterTurns: 3,
            child: GetX<MapController>(builder: (_) {
              return SliderTheme(
                data: SliderThemeData(
                  trackHeight: 3,
                  inactiveTrackColor: Colors.white,
                  activeTrackColor: brightPrimaryColor,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 16),
                  overlayColor: brightPrimaryColor.withOpacity(0.2),
                ),
                child: Slider(
                  value: _.radius.value,
                  onChanged: (value) {
                    print(value);
                    _.radius.value = value;
                  },
                  min: 2500,
                  max: 40000,
                  divisions: 10,
                  thumbColor: brightPrimaryColor,
                ),
              );
            }),
          ),
        ),
        Positioned(
          left: 14,
          bottom: 150,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0.5, 0.5),
                  color: deepGrayColor,
                  blurRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: GetX<MapController>(builder: (_) {
              return Text(
                '${getCleanTextFromDouble(_.radius.value / 1000)}km',
                style: const TextStyle(
                  color: darkPrimaryColor,
                  fontSize: 16,
                ),
              );
            }),
          ),
        ),
        Positioned(
          bottom: 20,
          child: Center(
            child: GetX<MapController>(
              builder: (_) {
                return ElevatedActionButton(
                  buttonText: _questionButtonText,
                  onPressed: _onAddQuestionPressed,
                  width: 330,
                  height: 50,
                  backgroundColor: brightPrimaryColor,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  activated: _.neighbors.isNotEmpty,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
