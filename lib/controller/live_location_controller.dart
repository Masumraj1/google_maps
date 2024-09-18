import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveLocationController extends GetxController {
  var currentLocation = const LatLng(0.0, 0.0).obs; // Observable for location
  final Location location = Location();

  @override
  void onInit() {
    super.onInit();
    _initLocationService();
  }
  void _initLocationService() async {
    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
    }

    // Check if permission is granted
    if (permission == PermissionStatus.granted) {
      // Listen to location changes
      location.onLocationChanged.listen((LocationData locationData) {
        currentLocation.value = LatLng(
          locationData.latitude ?? 0.0,
          locationData.longitude ?? 0.0,
        );

        // Print the location data for debugging
        print('Latitude:================== ${locationData.latitude}, '
            'Longitude:========================= ${locationData.longitude}');
      });
    }
  }

}
