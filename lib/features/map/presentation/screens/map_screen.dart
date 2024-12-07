import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pneu/core/constants/app/footer_constants.dart';
import 'package:pneu/features/map/presentation/widgets/footer.dart';
import 'package:pneu/features/map/presentation/widgets/map_widget.dart';
import 'package:pneu/shared/svg_icon.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double _panelPosition = 0.0;
  LatLng? _initialPosition;

  @override
  void initState() {
    super.initState();
    _fetchInitialPosition();
  }

  Future<void> _fetchInitialPosition() async {
    if (await Geolocator.isLocationServiceEnabled() == false) {
      throw Exception('Location Service not enabled!');
    }

    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialPosition == null
          ? const Center(
              child: Text('Loading'),
            )
          : SlidingUpPanel(
              minHeight: BarDimensions.closedPanelHeight,
              maxHeight: MediaQuery.of(context).size.height * 0.95,
              snapPoint: 0.5,
              borderRadius: BorderRadius.circular(10),
              // TO-DO: Add container for location widgets
              panel: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: BarDimensions.pullIconContainerHeight,
                    width: MediaQuery.of(context).size.width,
                    child: const SvgIcon('assets/icons/Pull.svg'),
                  ),
                  // TO-DO: Add Locations container when panel is Open
                  // and PullIcon container is over the footer height
                  _panelPosition > 1 / 36
                      ? const SizedBox(
                          child: Text('TEST'),
                        )
                      : Container(),
                ],
              ),
              body: MapWidget(_initialPosition),
              footer: Footer(panelPosition: _panelPosition),
              onPanelSlide: (double position) {
                setState(() {
                  _panelPosition = position;
                });
              },
            ),
    );
  }
}
