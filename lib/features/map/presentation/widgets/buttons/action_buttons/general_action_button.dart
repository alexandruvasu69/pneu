import 'package:flutter/material.dart';
import 'package:pneu/core/themes/app_colors.dart';
import 'package:pneu/shared/widgets/buttons/custom_icon_button.dart';

class GeneralActionButton extends StatelessWidget {
  const GeneralActionButton(
      {super.key, required this.onTap, required this.assetLocation, this.buttonWidth = 80, this.buttonHeight = 50});
  final VoidCallback onTap;
  final String assetLocation;
  final double buttonWidth;
  final double buttonHeight;

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
        onTap: onTap,
        assetLocation: assetLocation,
        iconWidth: 48,
        iconHeight: 48,
        buttonWidth: buttonWidth,
        buttonHeight: buttonHeight,
        padding: const Padding(padding: EdgeInsets.symmetric(vertical: 1, horizontal: 16)),
        backgroundColor: AppColors.secondaryAccent);
  }
}
