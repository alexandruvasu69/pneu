import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pneu/core/themes/app_colors.dart';

class DottedBorderButton extends StatelessWidget {
  const DottedBorderButton(
      {super.key,
      required this.onTap,
      required this.assetLocation,
      this.assetColor = Colors.black,
      this.borderColor = Colors.black,
      this.iconSize = 36,
      this.padding = const Padding(padding: EdgeInsets.all(0))});

  final VoidCallback onTap;
  final String assetLocation;
  final Color assetColor;
  final Color borderColor;
  final double iconSize;
  final Padding padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        color: borderColor,
        borderType: BorderType.RRect,
        strokeWidth: 2.5,
        dashPattern: const <double>[6, 2],
        radius: const Radius.circular(10),
        child: Container(
            width: iconSize + padding.padding.horizontal,
            height: iconSize + padding.padding.vertical,
            decoration: ShapeDecoration(
              color: AppColors.centerButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadows: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 7,
                  offset: Offset(2, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                assetLocation,
                height: 36,
                width: 36,
                colorFilter: ColorFilter.mode(assetColor, BlendMode.srcIn),
              ),
            )),
      ),
    );
  }
}
