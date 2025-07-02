import 'package:flutter/material.dart';
import 'package:pneu/core/themes/app_colors.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/presentation/stores/position_store.dart';
import 'package:pneu/shared/widgets/buttons/dotted_border_button.dart';
import 'package:provider/provider.dart';

class CenterButton extends StatefulWidget {
  const CenterButton({super.key});

  @override
  State<CenterButton> createState() => _CenterButtonState();
}

class _CenterButtonState extends State<CenterButton> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return DottedBorderButton(
      onTap: () {
        context.read<MapStore>().isAutoCentering = true;
        context.read<MapStore>().centerMapOnCurrentLocation(
            context.read<PositionStore>().currentPosition!);
      },
      assetLocation: 'assets/icons/Center.svg',
      assetColor: AppColors.primaryAccent,
      borderColor: AppColors.primaryAccent,
      iconSize: 36,
      padding: const Padding(padding: EdgeInsets.all(6)),
    );
  }
}
