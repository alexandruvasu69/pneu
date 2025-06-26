import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:pneu/core/utils/conversions.dart';
import 'package:pneu/features/map/data/models/mapbox_controller.dart';
import 'package:pneu/features/map/enums/panel_content_type.dart';
import 'package:pneu/features/map/presentation/stores/location_popup_store.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/presentation/stores/panel_store.dart';
import 'package:pneu/features/map/presentation/stores/position_store.dart';
import 'package:pneu/features/map/presentation/widgets/location_popup.dart';
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
      MapStore mapStore = context.read<MapStore>();

      mb.Position position =
          cameraChangedEventData.cameraState.center.coordinates;

      mapStore.updateCurrentCameraPostition(position.toCustomLatLng());

      if (context.read<LocationPopupStore>().isLocationPopupActive) {
        mapStore.updatePopUpScreenLocation();
      }
    }

    return Scaffold(
        body: Stack(
      children: <Widget>[
        mb.MapWidget(
          textureView: false,
          styleUri: 'mapbox://styles/alexandruvasu69/cm9ez0nrk00j401sb2659bjxu',
          cameraOptions: mb.CameraOptions(
            center: mb.Point(
                coordinates: context
                    .read<PositionStore>()
                    .currentPosition!
                    .toMapboxPosition()),
            zoom: 16,
          ),
          onMapCreated: (mb.MapboxMap mapController) {
            context
                .read<MapStore>()
                .initController(MapboxController(mapController));
          },
          onCameraChangeListener: handleCameraChange,
          onLongTapListener: (mb.MapContentGestureContext mapContext) {
            context.read<MapStore>().centerMapOnLocationPopup(
                mapContext.point.coordinates.toCustomLatLng(),
                mapContext.touchPosition.toCustomScreenPosition());
          },
          onTapListener: (mb.MapContentGestureContext mapContext) {
            context.read<LocationPopupStore>().isLocationPopupActive = false;
          },
        ),
        LocationPopup(
          onCancel: () {
            context.read<LocationPopupStore>().isLocationPopupActive = false;
          },
          onRoutes: () async {
            PanelStore panelStore = context.read<PanelStore>();

            await context.read<MapStore>().fetchAndDrawRoute(
                context.read<PositionStore>().currentPosition!);
            panelStore.panelContentType = PanelContentType.routeDetails;
            panelStore.openPanel = true;
          },
        )
      ],
    ));
  }
}
