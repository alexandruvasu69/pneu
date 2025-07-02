import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pneu/core/themes/app_colors.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/presentation/stores/panel_store.dart';
import 'package:pneu/features/map/presentation/stores/position_store.dart';
import 'package:provider/provider.dart';

class LocationCard extends StatelessWidget {
  const LocationCard(
      {super.key, required this.address1, required this.address2});
  final String address1;
  final String address2;

  @override
  Widget build(BuildContext context) {
    void handleOnCancelPress() {
      MapStore mapStore = context.read<MapStore>();
      mapStore.centerMapOnCurrentLocation(
          context.read<PositionStore>().currentPosition!);
      mapStore.clearAllRoutes();
      context.read<PanelStore>().panelController?.closePanel();
      context.read<PanelStore>().openPanel = false;
    }

    void handleOnStartPress() {
      context.read<MapStore>().startRoute();
      context.read<PanelStore>().panelController?.closePanel();
      context.read<PanelStore>().openPanel = false;
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.only(top: 20, bottom: 20, right: 36),
          decoration: BoxDecoration(
              color: AppColors.secondaryAccent,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/Heart.svg'),
                highlightColor: Colors.transparent,
              ),
              Container(
                padding: EdgeInsets.only(right: 85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      address1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Text(
                      address2,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 46,
          children: <Widget>[
            ElevatedButton(
              onPressed: handleOnCancelPress,
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: handleOnStartPress,
              child: const Text('Start'),
            ),
          ],
        ),
      ],
    );
  }
}
