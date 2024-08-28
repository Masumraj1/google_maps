// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class PolylineScreen extends StatefulWidget {
//   const PolylineScreen({super.key});
//
//   @override
//   _PolylineScreenState createState() => _PolylineScreenState();
// }
//
// class _PolylineScreenState extends State<PolylineScreen> {
//   late GoogleMapController _mapController;
//
//   // Coordinates for the driver and user locations
//   final LatLng _driverLocation = const LatLng(37.7749, -122.4194); // San Francisco
//   final LatLng _userLocation = const LatLng(34.0522, -118.2437); // Los Angeles
//
//   // Polyline
//   final Polyline _polyline = const Polyline(
//     polylineId: PolylineId('route'),
//     color: Colors.blue,
//     width: 5,
//     points: [
//       LatLng(37.7749, -122.4194), // San Francisco
//       LatLng(34.0522, -118.2437), // Los Angeles
//     ],
//   );
//
//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//     _mapController.animateCamera(
//       CameraUpdate.newLatLngBounds(
//         LatLngBounds(
//           southwest: LatLng(
//             min(_driverLocation.latitude, _userLocation.latitude),
//             min(_driverLocation.longitude, _userLocation.longitude),
//           ),
//           northeast: LatLng(
//             max(_driverLocation.latitude, _userLocation.latitude),
//             max(_driverLocation.longitude, _userLocation.longitude),
//           ),
//         ),
//         50.0,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Polyline Example'),
//       ),
//       body: GoogleMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: LatLng(
//             (_driverLocation.latitude + _userLocation.latitude) / 2,
//             (_driverLocation.longitude + _userLocation.longitude) / 2,
//           ),
//           zoom: 10,
//         ),
//         polylines: {
//           _polyline,
//         },
//         markers: {
//           Marker(
//             markerId: MarkerId('driver'),
//             position: _driverLocation,
//             infoWindow: InfoWindow(title: 'Driver'),
//           ),
//           Marker(
//             markerId: MarkerId('user'),
//             position: _userLocation,
//             infoWindow: InfoWindow(title: 'User'),
//           ),
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineScreen extends StatefulWidget {
  const PolylineScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}
class _MapScreenState extends State<PolylineScreen> {
  GoogleMapController? mapController;
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final LatLng _startLocation = const LatLng(23.8103, 90.4125); // Dhaka
  final LatLng _endLocation = const LatLng(23.6238, 90.4993); // Narayanganj
  final String googleAPIKey = 'AIzaSyAszXC1be8aJ37eHuNcBm_-O1clWkPUwV4';

  @override
  void initState() {
    super.initState();
    _getPolyline();
  }

  _getPolyline() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(_startLocation.latitude, _startLocation.longitude),
      PointLatLng(_endLocation.latitude, _endLocation.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        polylines.add(
          Polyline(
            polylineId: PolylineId("poly"),
            color: Colors.blue,
            points: polylineCoordinates,
            width: 6,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polyline Example'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _startLocation,
          zoom: 10,
        ),
        polylines: polylines,
        markers: {
          Marker(
            markerId: MarkerId('start'),
            position: _startLocation,
            infoWindow: InfoWindow(title: "Start Location"),
          ),
          Marker(
            markerId: MarkerId('end'),
            position: _endLocation,
            infoWindow: InfoWindow(title: "End Location"),
          ),
        },
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}