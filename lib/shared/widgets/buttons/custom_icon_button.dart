import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      required this.onTap,
      required this.assetLocation,
      this.iconWidth = 36,
      this.iconHeight = 36,
      this.buttonWidth = 40,
      this.buttonHeight = 40,
      this.padding = const Padding(padding: EdgeInsets.all(0)),
      this.assetColor = Colors.transparent,
      this.backgroundColor = Colors.black});
  final VoidCallback onTap;
  final String assetLocation;
  final double iconWidth;
  final double iconHeight;
  final double buttonWidth;
  final double buttonHeight;
  final Padding padding;
  final Color assetColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: buttonWidth + 1,
          height: buttonHeight + 1,
          decoration: ShapeDecoration(
            color: backgroundColor,
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
              child: assetColor != Colors.transparent
                  ? SvgPicture.asset(
                      assetLocation,
                      width: iconWidth,
                      height: iconWidth,
                      colorFilter: ColorFilter.mode(assetColor, BlendMode.dstIn),
                    )
                  : SvgPicture.asset(
                      assetLocation,
                      width: iconWidth,
                      height: iconHeight,
                    )),
        ));
  }
}
