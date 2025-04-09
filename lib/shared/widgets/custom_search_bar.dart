import 'package:flutter/material.dart';
import 'package:pneu/shared/svg_icon_button.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry?>(EdgeInsets.symmetric(vertical: 6, horizontal: 10)),
      leading: SvgIconButton(
        asset: 'assets/icons/Account.svg',
        onPressed: () {},
      ),
      trailing: <Widget>[
        SvgIconButton(
          asset: 'assets/icons/Search.svg',
          onPressed: () {},
        ),
      ],
      hintText: 'Where to?',
      overlayColor: const WidgetStatePropertyAll<Color?>(Colors.transparent),
    );
  }
}
