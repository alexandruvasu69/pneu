import 'package:flutter/material.dart';
import 'package:pneu/core/result/exceptions.dart';
import 'package:pneu/features/map/domain/entities/route.dart' as r;
import 'package:pneu/features/map/domain/usecases/get_calculated_routes.dart';
import 'package:pneu/features/map/presentation/stores/modal_store.dart';

class RouteStore extends ChangeNotifier {
  RouteStore(
      {required GetCalculatedRoutes getRoutes, required ModalStore modalStore})
      : _getRoutes = getRoutes,
        _modalStore = modalStore;

  GetCalculatedRoutes _getRoutes;
  ModalStore _modalStore;

  List<r.Route>? routeOptions;
  r.Route? selectedRoute;
  bool isLoading = false;
  String? error;

  Future<void> fetchRoutes(
      double startLat, double startLng, double endLat, double endLng) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      routeOptions = await _getRoutes(startLat, startLng, endLat, endLng);
      selectedRoute = routeOptions?.first;
    } on AppException catch (e) {
      _modalStore.openModalForWarning(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
