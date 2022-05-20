import 'package:escore/api/rest_api.dart';
import 'package:escore/helper/loading.dart';
import 'package:escore/helper/session.dart';
import 'package:escore/screens/login_screen.dart';
import 'package:escore/widgets/app_button.dart';
import 'package:escore/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  logout() async {
    Loading.show(context);
    await RestApi(context).logout(
        onResponse: (data) async {
          await Session().logout();
          Loading.hide(context);
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const LoginScreen()
          ));
        },
        onError: (error) {
          debugPrint(error);
          Loading.hide(context);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        child: AppButton(
          text: "Logout",
          onClick: () async {
            await logout();
          },
        ),
      ),
    );
  }
}
