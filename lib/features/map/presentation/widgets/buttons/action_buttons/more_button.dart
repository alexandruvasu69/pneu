import 'package:flutter/material.dart';
import 'package:pneu/core/themes/app_colors.dart';
import 'package:pneu/shared/widgets/buttons/custom_icon_button.dart';

class MoreButton extends StatelessWidget {
  const MoreButton(
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
        iconWidth: 22.75,
        iconHeight: 5.25,
        buttonWidth: buttonWidth,
        buttonHeight: buttonHeight,
        backgroundColor: AppColors.secondaryAccent);
  }
}
