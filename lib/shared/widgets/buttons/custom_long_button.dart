import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomLongButton extends StatelessWidget {
  const CustomLongButton({
    super.key,
    required this.onTap,
    required this.assetPath,
    required this.padding,
  });
  final VoidCallback onTap;
  final String assetPath;
  final Padding padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: SvgPicture.asset(assetPath),
      ),
    );
  }
}
