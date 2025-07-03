import 'package:flutter/material.dart';
import 'package:pneu/core/constants/app/footer_constants.dart';
import 'package:pneu/core/themes/app_colors.dart';
import 'package:pneu/features/map/data/models/sliding_panel_controller.dart';
import 'package:pneu/features/map/enums/panel_content_type.dart';
import 'package:pneu/features/map/presentation/stores/location_popup_store.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/presentation/stores/modal_store.dart';
import 'package:pneu/features/map/presentation/stores/panel_store.dart';
import 'package:pneu/features/map/presentation/stores/position_store.dart';
import 'package:pneu/features/map/presentation/stores/saved_locations_store.dart';
import 'package:pneu/features/map/presentation/widgets/buttons/action_buttons/specific_action_button.dart';
import 'package:pneu/features/map/presentation/widgets/buttons/action_buttons_panel.dart';
import 'package:pneu/features/map/presentation/widgets/buttons/center_button.dart';
import 'package:pneu/features/map/presentation/widgets/footer.dart';
import 'package:pneu/features/map/presentation/widgets/general_modal.dart';
import 'package:pneu/features/map/presentation/widgets/location/route_details.dart';
import 'package:pneu/features/map/presentation/widgets/location/saved_locations.dart';
import 'package:pneu/features/map/presentation/widgets/location/saved_locations_tab.dart';
import 'package:pneu/features/map/presentation/widgets/map_widget.dart';
import 'package:pneu/shared/svg_icon_button.dart';
import 'package:pneu/shared/widgets/buttons/custom_icon_button.dart';
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

    context.read<PositionStore>().startPositionStream();
  }

  bool _compareCameraPosition(MapStore mapStore, PositionStore positionStore) {
    if (mapStore.currentCameraPostion == null ||
        positionStore.currentPosition == null) {
      return true;
    }

    final double distance = Geolocator.distanceBetween(
      mapStore.currentCameraPostion!.latitude,
      mapStore.currentCameraPostion!.longitude,
      positionStore.currentPosition!.latitude,
      positionStore.currentPosition!.longitude,
    );

    return distance < 1;
  }

  @override
  Widget build(BuildContext context) {
    MapStore mapStore = context.read<MapStore>();

    return Scaffold(
      body: context.watch<PositionStore>().currentPosition == null
          ? const Center(
              child: Text('Loading'),
            )
          : Stack(children: <Widget>[
              Consumer<PanelStore>(
                builder: (BuildContext context, PanelStore panelStore, _) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (panelStore.panelController!.isPanelAtached &&
                        panelStore.openPanel) {
                      panelStore.panelController!.animatePanelToPosition(
                          panelStore.panelContentType.snapPoint);
                    }
                  });

                  return SlidingUpPanel(
                    controller: (context.read<PanelStore>().panelController
                            as SlidingPanelController)
                        .panelController,
                    minHeight: BarDimensions.closedPanelHeight,
                    maxHeight: MediaQuery.of(context).size.height * 0.95,
                    snapPoint: panelStore.panelContentType.snapPoint,
                    borderRadius: BorderRadius.circular(10),
                    // TO-DO: Add container for location widgets
                    panelBuilder: (sc) {
                      return Column(
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
                          if (_panelPosition > 1 / 36)
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  final locationPopupStore =
                                      context.watch<LocationPopupStore>();
                                  final savedLocationsStore =
                                      context.watch<SavedLocationsStore>();

                                  switch (panelStore.panelContentType) {
                                    case PanelContentType.events:
                                      return const Text('Evenimente în zona');
                                    case PanelContentType.locations:
                                      return SavedLocationsTab(
                                        scrollController: sc,
                                      );
                                    case PanelContentType.routeDetails:
                                      return RouteDetails(
                                        location:
                                            locationPopupStore.selectedLocation,
                                      );
                                    default:
                                      return const SizedBox.shrink();
                                  }
                                },
                              ),
                            )
                        ],
                      );
                    },

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
              Consumer2<MapStore, PositionStore>(
                builder: (BuildContext context, MapStore mapStore,
                    PositionStore posStore, Widget? child) {
                  return (!_compareCameraPosition(mapStore, posStore) &&
                          !mapStore.isAutoCentering)
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
              context.read<MapStore>().isAutoCentering
                  ? Positioned(
                      top: 50,
                      left: 30,
                      child: CustomIconButton(
                        assetLocation: 'assets/icons/Cancel.svg',
                        onTap: () {
                          context.read<MapStore>().cancelRoute();
                        },
                        iconWidth: 20,
                        iconHeight: 20,
                        backgroundColor: AppColors.primaryColor,
                      ),
                    )
                  : SizedBox.shrink(),
              if (context.watch<ModalStore>().isActive)
                GeneralModal(
                    child: Text(context.read<ModalStore>().infoText!),
                    onOkay: () => context.read<ModalStore>().closeModal())
            ]),
    );
  }
}
