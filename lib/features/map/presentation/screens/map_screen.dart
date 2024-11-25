import 'package:flutter/material.dart';
import 'package:pneu/core/constants/app/footer_constants.dart';
import 'package:pneu/features/map/presentation/widgets/footer.dart';
import 'package:pneu/shared/svg_icon.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double _panelPosition = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
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
        // TO-DO: Add container for map widget
        body: const Center(
          child: Text('Map widget'),
        ),
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
