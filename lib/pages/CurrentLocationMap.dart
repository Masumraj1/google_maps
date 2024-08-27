import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_by_masum/controller/maps_controller.dart';
import 'package:google_map_by_masum/pages/polyline_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationMap extends StatelessWidget {
   CurrentLocationMap({super.key});


  final MapsController mapsController = Get.put(MapsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Current Location '),centerTitle: true,),
      body: Obx(() => GoogleMap(
        onMapCreated:mapsController.onMapCreated,
        initialCameraPosition: CameraPosition(
          target: mapsController.currentPosition.value,
          zoom: 10.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        cameraTargetBounds: CameraTargetBounds.unbounded,
        markers: mapsController.currentMarkerLocation.value != null
            ? {mapsController.currentMarkerLocation.value!}
            : {},
      )),

      ///================================PolyLine Screen=================
      floatingActionButton:
      TextButton(
        onPressed: () {
          Get.to( PolylineScreen());
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue, // Text color
        ),
        child: const Text('PolyLine Screen'),
      )

    );
  }

}
