import 'package:flutter/material.dart';
import 'package:pneu/features/login/presentation/notifiers/user_notifier.dart';
import 'package:pneu/shared/stores/user_store.dart';
import 'package:pneu/shared/svg_icon_button.dart';
import 'package:provider/provider.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      focusNode: _searchFocusNode,
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry?>(EdgeInsets.symmetric(vertical: 6, horizontal: 10)),
      leading: SvgIconButton(
        asset: 'assets/icons/Account.svg',
        onPressed: () {
          _searchFocusNode.unfocus();
          Navigator.of(context).pushNamed('/login');
        },
      ),
      trailing: <Widget>[
        SvgIconButton(
          asset: 'assets/icons/Search.svg',
          onPressed: () {
            print(context.read<UserStore>().currentUser?.id);
          },
        ),
      ],
      hintText: context.watch<UserNotifier>().user?.id ?? 'Caută',
      overlayColor: const WidgetStatePropertyAll<Color?>(Colors.transparent),
    );
  }
}
