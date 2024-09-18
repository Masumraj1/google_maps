import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isLocationServiceEnabled = false.obs;
  var permissionGranted = false.obs;

  final Location location = Location();

  @override
  void onInit() {
    super.onInit();
    _initLocationService();
  }

  void _initLocationService() async {
    // Check if location service is enabled
    isLocationServiceEnabled.value = await location.serviceEnabled();
    if (!isLocationServiceEnabled.value) {
      isLocationServiceEnabled.value = await location.requestService();
    }

    // Check for permission
    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
    }
    permissionGranted.value = permission == PermissionStatus.granted;

    // Start listening for location updates if permissions are granted
    if (permissionGranted.value && isLocationServiceEnabled.value) {
      location.onLocationChanged.listen((LocationData currentLocation) {
        latitude.value = currentLocation.latitude!;
        longitude.value = currentLocation.longitude!;
      });
    }
  }
}
