import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineScreen extends StatefulWidget {
  const PolylineScreen({super.key});

  @override
  _PolylineScreenState createState() => _PolylineScreenState();
}

class _PolylineScreenState extends State<PolylineScreen> {
  late GoogleMapController _mapController;

  // Coordinates for the driver and user locations
  final LatLng _driverLocation = const LatLng(37.7749, -122.4194); // San Francisco
  final LatLng _userLocation = const LatLng(34.0522, -118.2437); // Los Angeles

  // Polyline
  final Polyline _polyline = const Polyline(
    polylineId: PolylineId('route'),
    color: Colors.blue,
    width: 5,
    points: [
      LatLng(37.7749, -122.4194), // San Francisco
      LatLng(34.0522, -118.2437), // Los Angeles
    ],
  );

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            min(_driverLocation.latitude, _userLocation.latitude),
            min(_driverLocation.longitude, _userLocation.longitude),
          ),
          northeast: LatLng(
            max(_driverLocation.latitude, _userLocation.latitude),
            max(_driverLocation.longitude, _userLocation.longitude),
          ),
        ),
        50.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polyline Example'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            (_driverLocation.latitude + _userLocation.latitude) / 2,
            (_driverLocation.longitude + _userLocation.longitude) / 2,
          ),
          zoom: 10,
        ),
        polylines: {
          _polyline,
        },
        markers: {
          Marker(
            markerId: MarkerId('driver'),
            position: _driverLocation,
            infoWindow: InfoWindow(title: 'Driver'),
          ),
          Marker(
            markerId: MarkerId('user'),
            position: _userLocation,
            infoWindow: InfoWindow(title: 'User'),
          ),
        },
      ),
    );
  }
}