import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? mapController;
  final LatLng _initialPosition = const LatLng(44.4268, 26.1025); // Centrat pe București
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        onLongPress: (LatLng position) {
          setState(() {
            _selectedLocation = position;
          });
          mapController?.animateCamera(CameraUpdate.newLatLngZoom(_selectedLocation!, 15));
        },
      ),
    );
  }
}
