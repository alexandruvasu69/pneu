import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pneu/core/themes/app_text_styles.dart';
import 'package:pneu/features/login/presentation/login_screen.dart';
import 'package:pneu/features/login/presentation/notifiers/user_notifier.dart';
import 'package:pneu/shared/styled_text.dart';
import 'package:pneu/shared/svg_icon_button.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  static const routeName = '/account';

  @override
  Widget build(BuildContext context) {
    final userStore = context.watch<UserNotifier>();
    final user = userStore.user;

    if (user == null) {
      return Scaffold(
          appBar: AppBar(
        title: Text("Account"),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/Account.svg',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 10),
            StyledHeading(userStore.user!.id),
            SizedBox(height: 10),
            StyledText(userStore.user!.role),
            SizedBox(height: 10),
            if (user.isGuest)
              FloatingActionButton(
                child: Text("Login"),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
              ),
            if (!user.isGuest)
              FloatingActionButton(
                child: Text("Log out"),
                onPressed: () async {
                  await userStore.signOut();
                },
              ),
          ],
        ),
      ),
    );
  }
}
