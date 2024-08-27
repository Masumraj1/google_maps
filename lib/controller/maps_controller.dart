import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsController extends GetxController{
  var currentPosition = const LatLng(23.7586986, 0.42894179999999).obs;
  GoogleMapController? mapController;
  var currentMarkerLocation = Rxn<Marker>();

  // Get permission from user device
  Future<Position> determinePosition() async {
    if (!await Permission.location.isGranted) {
      PermissionStatus status = await Permission.location.request();
      if (status != PermissionStatus.granted) {
        return Future.error('Location permissions are denied');
      }
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await determinePosition();
      currentPosition.value = LatLng(position.latitude, position.longitude);

      // Fetching the address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.value.latitude,
        currentPosition.value.longitude,
      );

      String address = '';
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        address = '${place.subLocality}, ${place.locality}, ${place.country}';
      } else {
        address = 'Unknown location';
      }

      currentMarkerLocation.value = Marker(
        markerId: const MarkerId('currentLocation'),
        position: currentPosition.value,
        infoWindow: InfoWindow(
          title: address,
          snippet: 'Your Current Location', // Displaying the address as the snippet
        ),
      );

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentPosition.value, zoom: 12),
        ),
      );

      print('================================>>>>>Longitude: ${currentPosition.value.longitude}<<<<<================================Longitude');
      print('================================>>>>>Latitude: ${currentPosition.value.latitude}<<<<<================================Latitude');
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  void onMapCreated(GoogleMapController controller) {
   mapController = controller;
  getCurrentLocation();
  }
}