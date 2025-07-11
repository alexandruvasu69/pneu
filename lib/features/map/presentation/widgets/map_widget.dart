import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:pneu/core/utils/conversions.dart';
import 'package:pneu/features/map/data/models/mapbox_controller.dart';
import 'package:pneu/features/map/domain/entities/abstract_map_controller.dart';
import 'package:pneu/features/map/enums/panel_content_type.dart';
import 'package:pneu/features/map/presentation/stores/events_store.dart';
import 'package:pneu/features/map/presentation/stores/location_popup_store.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/presentation/stores/panel_store.dart';
import 'package:pneu/features/map/presentation/stores/position_store.dart';
import 'package:pneu/features/map/presentation/stores/route_store.dart';
import 'package:pneu/features/map/presentation/widgets/location_popup.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    EventsStore eventsStore = context.read<EventsStore>();
    MapStore mapStore = context.read<MapStore>();

    void handleCameraChange(
        mb.CameraChangedEventData cameraChangedEventData) async {
      print("IS LOCKED: ${context.read<PanelStore>().isPanelLocked}");
      print("PANEL TYPE: ${context.read<PanelStore>().panelContentType}");
      print("IS OPENING: ${context.read<PanelStore>().isPanelOpening}");
      final zoom = cameraChangedEventData.cameraState.zoom;
      if (zoom.floor() != mapStore.zoom.floor()) {
        mapStore.drawEvents(eventsStore.shownEvents, zoom);
      }

      mapStore.zoom = zoom;

      mb.Position position =
          cameraChangedEventData.cameraState.center.coordinates;

      mapStore.updateCurrentCameraPostition(position.toCustomLatLng());

      if (context.read<LocationPopupStore>().isLocationPopupActive) {
        mapStore.updatePopUpScreenLocation();
      }

      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 200), () async {
        final cs = cameraChangedEventData.cameraState;

        final co = MapCameraOptions(
          center: cs.center.coordinates.toCustomLatLng(), // Point
          zoom: cs.zoom, // double
          bearing: cs.bearing, // double
          pitch: cs.pitch, // double
          padding: MapEdgeInsets(
            top: cs.padding.top,
            left: cs.padding.left,
            bottom: cs.padding.bottom,
            right: cs.padding.right,
          ), // EdgeInsets?
        );

        print("ZOOM: ${cs.zoom}");

        final bounds = await mapStore.getBounds(co);
        if (bounds.isNotEmpty) {
          await eventsStore.getEventsForBounds(bounds[0].latitude,
              bounds[0].longitude, bounds[1].latitude, bounds[1].longitude);

          await mapStore.drawEvents(eventsStore.shownEvents, cs.zoom);
        }
      });
    }

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        context.read<MapStore>().isAutoCentering = false;
      },
      child: Stack(
        children: <Widget>[
          mb.MapWidget(
            textureView: true,
            styleUri:
                'mapbox://styles/alexandruvasu69/cm9ez0nrk00j401sb2659bjxu',
            cameraOptions: mb.CameraOptions(
              center: mb.Point(
                  coordinates: context
                      .read<PositionStore>()
                      .currentPosition!
                      .toMapboxPosition()),
              zoom: 16,
            ),
            onMapCreated: (mb.MapboxMap mapController) async {
              await context
                  .read<MapStore>()
                  .initController(MapboxController(mapController));
            },
            onCameraChangeListener: handleCameraChange,
            onLongTapListener: (mb.MapContentGestureContext mapContext) {
              context.read<MapStore>().centerMapOnLocationPopupWithCoords(
                    mapContext.point.coordinates.toCustomLatLng(),
                    mapContext.touchPosition.toCustomScreenPosition(),
                  );
            },
            onTapListener: (mb.MapContentGestureContext mapContext) {
              context.read<LocationPopupStore>().isLocationPopupActive = false;
              context.read<MapStore>().isCentering = false;
            },
          ),
          LocationPopup(
            onCancel: () {
              context.read<LocationPopupStore>().isLocationPopupActive = false;
            },
            onRoutes: () async {
              PanelStore panelStore = context.read<PanelStore>();
              final currentPosition =
                  context.read<PositionStore>().currentPosition;
              final selectedLocation = context
                  .read<LocationPopupStore>()
                  .locationPopupRealCoordinate;

              await context.read<RouteStore>().fetchRoutes(
                  currentPosition!.latitude,
                  currentPosition.longitude,
                  selectedLocation!.latitude,
                  selectedLocation.longitude);

              await context
                  .read<MapStore>()
                  .drawRoutes(context.read<RouteStore>().routeOptions!);
            },
          ),
          if (context.watch<RouteStore>().isLoading)
            Positioned.fill(
              child: AbsorbPointer(
                // poți colore containerul semi-transparent ca feedback vizual
                child: Container(color: Colors.transparent),
              ),
            ),

          // 4) Spinner-ul centrat
          if (context.watch<RouteStore>().isLoading)
            const Positioned.fill(
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
