import 'package:pneu/shared/models/custom_lat_lng.dart';

abstract class AbstractMapController<T> {
  late final T _controller;

  AbstractMapController<T> initController(T controller) {
    this._controller = controller;

    return this;
  }

  T? getController() {
    return this._controller;
  }

  Future<void> animateCamera(CustomLatLng position, double zoom);

  Future<void> updateSettings();

  Future<void> animateCameraToBound(List<CustomLatLng> boundingBox);
}
