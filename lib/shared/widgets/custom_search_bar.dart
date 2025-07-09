import 'package:flutter/material.dart';
import 'package:pneu/features/login/presentation/notifiers/user_notifier.dart';
import 'package:pneu/features/map/presentation/stores/position_store.dart';
import 'package:pneu/features/map/presentation/stores/search_store.dart';
import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/search/search_screen.dart';
import 'package:pneu/shared/stores/user_store.dart';
import 'package:pneu/shared/svg_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomSearchBar extends StatefulWidget {
  CustomSearchBar({super.key, this.isInMainScreen = true});
  bool isInMainScreen;

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
      autoFocus: !widget.isInMainScreen,
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry?>(
          EdgeInsets.symmetric(vertical: 6, horizontal: 10)),
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
      onTap: () {
        if (widget.isInMainScreen) {
          _searchFocusNode.unfocus();
          Navigator.of(context).pushNamed('/search');
        }
      },
      onChanged: (String value) {
        final position = context.read<PositionStore>().currentPosition!;
        final user = context.read<UserNotifier>().user!;
        context.read<SearchStore>().suggestLocations(value, user, position);
      },
      onTapOutside: (PointerDownEvent event) {
        _searchFocusNode.unfocus();
      },
    );
  }
}
