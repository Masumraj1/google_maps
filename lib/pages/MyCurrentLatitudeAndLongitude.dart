import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_by_masum/controller/location_controller.dart';

class MyCurrentLatitudeAndLongitude extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Location Update'),
      ),
      body: Center(
        child: Obx(() {
          if (!locationController.permissionGranted.value) {
            return Text('Location permission not granted');
          }
          if (!locationController.isLocationServiceEnabled.value) {
            return Text('Location service is disabled');
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Latitude: ${locationController.latitude.value}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                'Longitude: ${locationController.longitude.value}',
                style: TextStyle(fontSize: 20),
              ),
            ],
          );
        }),
      ),
    );
  }
}
