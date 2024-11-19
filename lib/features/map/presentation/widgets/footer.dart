import 'package:flutter/material.dart';
import 'package:pneu/shared/widgets/custom_search_bar.dart';
import 'package:pneu/core/themes/app_colors.dart';

class Footer extends StatelessWidget {
  const Footer({super.key, required this.panelPosition});

  final double panelPosition;
  final double pullBarContainerHeight = 36;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: pullBarContainerHeight,
          color: panelPosition > 1 / pullBarContainerHeight ? AppColors.primaryColor : Colors.transparent,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 36),
          decoration: ShapeDecoration(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            color: AppColors.primaryColor,
          ),
          child: const CustomSearchBar(),
        ),
      ],
    );
  }
}
