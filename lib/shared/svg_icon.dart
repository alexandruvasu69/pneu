import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon(this._asset, {super.key, this.onPressed = _defaultOnPressed});

  final void Function() onPressed;
  final String _asset;

  static void _defaultOnPressed() {}

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: SizedBox(
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          icon: SvgPicture.asset(_asset),
          highlightColor: Colors.transparent,
        ),
      ),
    );
  }
}
