import 'package:escore/api/rest_api.dart';
import 'package:escore/helper/loading.dart';
import 'package:escore/helper/session.dart';
import 'package:escore/screens/login_screen.dart';
import 'package:escore/widgets/app_button.dart';
import 'package:escore/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

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
          text: "Log Out",
          onClick: () async {
            await logout();
          },
        ),
      ),
    );
  }
}
