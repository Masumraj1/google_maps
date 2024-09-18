import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_by_masum/controller/live_location_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveLocation extends StatelessWidget {
  final LiveLocationController locationController = Get.put(LiveLocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Location on Google Map'),
      ),
      body: Obx(() {
        // Show Google Map and update it with current location
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: locationController.currentLocation.value,
            zoom: 14.0,
          ),
          markers: {
            Marker(
              markerId: MarkerId('currentLocation'),
              position: locationController.currentLocation.value,
              infoWindow: InfoWindow(title: 'You are here'),
            ),
          },
          onMapCreated: (GoogleMapController controller) {
            // Move the camera to the current location when map is created
            controller.animateCamera(
              CameraUpdate.newLatLng(locationController.currentLocation.value),
            );
          },
        );
      }),
    );
  }
}
