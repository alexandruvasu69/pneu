import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:pneu/core/utils/conversions.dart';
import 'package:pneu/features/map/domain/abstract_map_controller.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

class MapboxController extends AbstractMapController<MapboxMap> {
  MapboxController._internal();

  static MapboxController? _instance;

  static MapboxController getInstance() {
    _instance ??= MapboxController._internal();

    return _instance!;
  }

  @override
  Future<void> animateCamera(CustomLatLng position, double zoom) async {
    await getController()!.flyTo(
      CameraOptions(
        center: Point(
          coordinates: position.toMapboxPosition(),
        ),
        zoom: zoom,
        bearing: 0,
      ),
      MapAnimationOptions(duration: 1500, startDelay: 0),
    );
  }

  @override
  Future<void> updateSettings() async {
    await getController()!.scaleBar.updateSettings(
          ScaleBarSettings(
            enabled: false,
          ),
        );
    await getController()!.location.updateSettings(LocationComponentSettings(
          enabled: true,
          pulsingEnabled: true,
        ));
  }
}
