import 'package:flutter/material.dart';
import 'package:pneu/shared/svg_icon.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SearchBar(
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry?>(EdgeInsets.symmetric(vertical: 6, horizontal: 10)),
      leading: SvgIcon('assets/icons/Account.svg'),
      trailing: <Widget>[
        SvgIcon('assets/icons/Search.svg'),
      ],
      hintText: 'Where to?',
      overlayColor: WidgetStatePropertyAll<Color?>(Colors.transparent),
    );
  }
}
