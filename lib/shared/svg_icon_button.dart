import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIconButton extends StatelessWidget {
  const SvgIconButton({
    super.key,
    required this.asset,
    this.onPressed,
    this.padding = EdgeInsets.zero,
    this.width = 0,
    this.height = 0,
  });

  final void Function()? onPressed;
  final String asset;
  final EdgeInsets padding;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: SizedBox(
        child: IconButton(
          padding: padding,
          onPressed: onPressed,
          icon: SvgPicture.asset(asset),
          highlightColor: Colors.transparent,
        ),
      ),
    );
  }
}
