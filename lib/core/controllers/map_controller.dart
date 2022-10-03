import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:qnpick/core/controllers/auth_controller.dart';
import 'package:qnpick/core/services/user_api_service.dart';
import 'package:qnpick/helpers/utils.dart';

const String _markerAsset = "assets/icons/mapOverlayMarker.png";

class MapController extends GetxController {
  static MapController to = Get.find<MapController>();

  late NaverMapController naverMapController;

  late LocationPermission permission;
  Rx<OverlayImage?> markerImage = Rx<OverlayImage?>(null);
  Position? position;
  Rx<LatLng?> circlePosition = Rx<LatLng?>(null);
  RxList<LatLng> neighbors = <LatLng>[].obs;
  RxDouble radius = (2500.0).obs; //
  bool useLocation = false;
  LatLng? initLocation;
  LocationTrackingMode trackingMode = LocationTrackingMode.None;

  @override
  void onInit() async {
    super.onInit();
    position = await determinePosition();
      postUserLocation();
    await createMarkerImage();
    if (position != null) {
      initLocation = LatLng(position!.latitude, position!.longitude);
      circlePosition.value = initLocation;
    }
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position?> determinePosition() async {
    bool _serviceEnabled;

    // Test if location services are enabled.
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      print('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        print('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (hasLocationPermission(permission)) {
      return await Geolocator.getCurrentPosition();
    }
  }

  Future<void> createMarkerImage() async {
    markerImage.value =
        await OverlayImage.fromAssetImage(assetName: _markerAsset);
  }

  Future<void> getNeighbors() async {
    if (circlePosition.value != null) {
      var resData = await UserApiService.getNeighborsByLocation(
          circlePosition.value!.latitude,
          circlePosition.value!.longitude,
          radius.value);
      neighbors.clear();
      if (resData != null) {
        resData.forEach((pos) {
          neighbors.add(LatLng(pos[0], pos[1]));
        });
      }
    }
  }

  Future<void> postUserLocation() async {
    if (AuthController.to.isAuthenticated.value){
    if (position != null) {
      var success = await UserApiService.postUserLocation(
          position!.latitude, position!.longitude);
      print("User location posted: $success");
    }}
  }
}
