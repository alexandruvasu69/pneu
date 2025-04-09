import 'package:flutter/material.dart';
import 'package:pneu/shared/widgets/buttons/custom_icon_button.dart';

class SpecificActionButton extends StatelessWidget {
  const SpecificActionButton(
      {super.key, required this.assetLocation, required this.iconWidth, required this.iconHeight});
  final String assetLocation;
  final double iconWidth;
  final double iconHeight;

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      onTap: () {}, // TO-DO: add API request for adding events to the database,
      assetLocation: assetLocation,
      buttonWidth: 80,
      buttonHeight: 80,
      iconWidth: iconWidth,
      iconHeight: iconHeight,
      padding: const Padding(padding: EdgeInsets.all(10)),
      backgroundColor: Colors.white,
    );
  }
}
