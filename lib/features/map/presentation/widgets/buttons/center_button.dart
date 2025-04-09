import 'package:flutter/material.dart';
import 'package:pneu/core/themes/app_colors.dart';
import 'package:pneu/features/map/managers/map_controller_manager.dart';
import 'package:pneu/shared/widgets/buttons/dotted_border_button.dart';
import 'package:provider/provider.dart';

class CenterButton extends StatelessWidget {
  const CenterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorderButton(
      onTap: () => context.read<MapControllerManager>().centerMapOnCurrentLocation(),
      assetLocation: 'assets/icons/Center.svg',
      assetColor: AppColors.primaryAccent,
      borderColor: AppColors.primaryAccent,
      iconSize: 36,
      padding: const Padding(padding: EdgeInsets.all(6)),
    );
  }
}
