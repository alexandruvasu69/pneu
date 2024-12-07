import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(this._initialLocation, {super.key});
  final LatLng? _initialLocation;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? mapController;
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: widget._initialLocation!,
          zoom: 18,
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
