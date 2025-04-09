import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/services/map_controller_service.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getCenterCoordinate(CameraPosition cameraPosition) async {
    LatLng cameraLatLng = cameraPosition.target;
    context.read<MapStore>().updateCurrentCameraPostition(cameraLatLng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: context.read<MapStore>().currentPosition!,
          zoom: 18,
        ),
        onMapCreated: (GoogleMapController controller) {
          MapControllerService.instance.setController(controller);
        },
        onLongPress: (LatLng position) {
          print(position);
        },
        onCameraMove: (CameraPosition position) {
          _getCenterCoordinate(position);
        },
      ),
    );
  }
}
