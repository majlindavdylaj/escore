import 'package:escore/api/rest_api.dart';
import 'package:escore/screens/main_screen.dart';
import 'package:escore/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  checkLogin() async{
    await RestApi(context).updateToken(
      onResponse: (data) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MainScreen()
        ));
      },
      onError: (error) {
        debugPrint(error);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      isBackgroundDark: false,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
