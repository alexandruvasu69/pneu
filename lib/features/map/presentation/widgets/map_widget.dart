import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:pneu/core/utils/conversions.dart';
import 'package:pneu/features/map/adapters/mapbox_controller.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    void handleCameraChange(mb.CameraChangedEventData cameraChangedEventData) {
      mb.Position position = cameraChangedEventData.cameraState.center.coordinates;

      context.read<MapStore>().updateCurrentCameraPostition(position.toCustomLatLng());
    }

    return Scaffold(
      body: mb.MapWidget(
        textureView: false,
        styleUri: 'mapbox://styles/alexandruvasu69/cm9ez0nrk00j401sb2659bjxu',
        cameraOptions: mb.CameraOptions(
          center: mb.Point(coordinates: context.read<MapStore>().currentPosition!.toMapboxPosition()),
          zoom: 16,
        ),
        onMapCreated: (mb.MapboxMap mapController) {
          MapboxController.getInstance().initController(mapController).updateSettings();
        },
        onCameraChangeListener: handleCameraChange,
      ),
    );
  }
}
