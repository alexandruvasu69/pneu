import 'package:flutter/material.dart';
import 'package:pneu/core/constants/app/footer_constants.dart';
import 'package:pneu/features/map/enums/panel_content_type.dart';
import 'package:pneu/features/map/managers/location_manager.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/presentation/stores/panel_store.dart';
import 'package:pneu/features/map/presentation/widgets/buttons/action_buttons_panel.dart';
import 'package:pneu/features/map/presentation/widgets/buttons/center_button.dart';
import 'package:pneu/features/map/presentation/widgets/footer.dart';
import 'package:pneu/features/map/presentation/widgets/location/location_card.dart';
import 'package:pneu/features/map/presentation/widgets/map_widget.dart';
import 'package:pneu/shared/svg_icon_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double _panelPosition = 0.0;
  final PanelController _panelController = PanelController();

  @override
  void initState() {
    super.initState();

    Future<Null>.microtask(() {
      if (!mounted) return;
      final LocationManager manager = context.read<LocationManager>();
      manager.initializeCurrentLocation();
    });
  }

  bool _compareCameraPosition(MapStore value) {
    if (value.currentCameraPostion == null || value.currentPosition == null) {
      return true;
    }

    final double distance = Geolocator.distanceBetween(
      value.currentCameraPostion!.latitude,
      value.currentCameraPostion!.longitude,
      value.currentPosition!.latitude,
      value.currentPosition!.longitude,
    );

    return distance < 1;
  }

  @override
  Widget build(BuildContext context) {
    MapStore mapStore = context.read<MapStore>();

    return Scaffold(
      body: context.watch<MapStore>().currentPosition == null
          ? const Center(
              child: Text('Loading'),
            )
          : Stack(children: <Widget>[
              Consumer<PanelStore>(
                builder: (BuildContext context, PanelStore panelStore, _) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_panelController.isAttached && panelStore.openPanel) {
                      _panelController.animatePanelToPosition(
                          panelStore.panelContentType.snapPoint);
                    }
                  });

                  return SlidingUpPanel(
                    controller: _panelController,
                    minHeight: BarDimensions.closedPanelHeight,
                    maxHeight: MediaQuery.of(context).size.height * 0.95,
                    snapPoint: panelStore.panelContentType.snapPoint,
                    borderRadius: BorderRadius.circular(10),
                    // TO-DO: Add container for location widgets
                    panel: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: BarDimensions.pullIconContainerHeight,
                          width: MediaQuery.of(context).size.width,
                          child: SvgIconButton(
                            asset: 'assets/icons/Pull.svg',
                            onPressed: () {},
                          ),
                        ),
                        // TO-DO: Add Locations container when panel is Open
                        // and PullIcon container is over the footer height

                        _panelPosition > 1 / 36
                            ? Builder(
                                builder: (context) {
                                  final mapStore = context.watch<MapStore>();

                                  switch (panelStore.panelContentType) {
                                    case PanelContentType.events:
                                      return const Text('Evenimente în zona');
                                    case PanelContentType.locations:
                                      return const Text('Locatiile tale');
                                    case PanelContentType.routeDetails:
                                      print("CURRENT LOCATION: " +
                                          mapStore.currentLocation!.address1);
                                      return LocationCard(
                                        address1: mapStore
                                                .currentLocation?.address1 ??
                                            'error',
                                        address2: mapStore
                                                .currentLocation?.address2 ??
                                            'error',
                                      );
                                    default:
                                      return const SizedBox.shrink();
                                  }
                                },
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    body: const MapWidget(),
                    footer: Footer(panelPosition: _panelPosition),
                    onPanelClosed: () {
                      if (!panelStore.openPanel) {
                        panelStore.panelContentType =
                            PanelContentType.locations;
                        panelStore.isPanelSnapped = false;
                        panelStore.isClosing = false;
                        panelStore.isOpening = false;
                      } else {
                        panelStore.openPanel = false;
                      }
                    },
                    onPanelSlide: (double position) {
                      if (position > panelStore.position) {
                        panelStore.isClosing = false;
                        panelStore.isOpening = true;
                        panelStore.isPanelSnapped = false;
                      } else if (position < panelStore.position) {
                        panelStore.isClosing = true;
                        panelStore.isOpening = false;
                        panelStore.isPanelSnapped = false;
                      }

                      if (position == panelStore.panelContentType.snapPoint &&
                          position == panelStore.position) {
                        print('PANEL IS SNAPPED');
                        panelStore.isPanelSnapped = true;
                        panelStore.isClosing = false;
                        panelStore.isOpening = false;
                      }

                      if (position == 0 && panelStore.isClosing) {
                        panelStore.isClosing = false;
                        panelStore.isOpening = false;
                      }

                      panelStore.position = position;

                      setState(() {
                        _panelPosition = position;
                      });

                      //   PanelControllerManager panelManager = context.read<PanelControllerManager>();

                      //   _panelPosition > 0 ? panelManager.openPanel() : panelManager.closePanel();
                    },
                  );
                },
              ),
              Consumer<MapStore>(
                builder: (BuildContext context, MapStore value, Widget? child) {
                  return !_compareCameraPosition(value)
                      ? Positioned(
                          bottom: BarDimensions.closedPanelHeight +
                              44 +
                              _panelPosition *
                                  (MediaQuery.of(context).size.height * 0.95 -
                                      BarDimensions.closedPanelHeight),
                          left: 30,
                          child: const CenterButton(),
                        )
                      : Container();
                },
              ),
              Positioned(
                bottom: BarDimensions.closedPanelHeight +
                    44 +
                    _panelPosition *
                        (MediaQuery.of(context).size.height * 0.95 -
                            BarDimensions.closedPanelHeight),
                right: 30,
                child: const ActionButtonsPanel(),
              ),
            ]),
    );
  }
}
