import 'package:escore/api/rest_api.dart';
import 'package:escore/helper/get_message.dart';
import 'package:escore/helper/loading.dart';
import 'package:escore/screens/main_screen.dart';
import 'package:escore/screens/register_screen.dart';
import 'package:escore/widgets/app_button.dart';
import 'package:escore/widgets/app_scaffold.dart';
import 'package:escore/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login() async {
    Loading.show(context);
    String username = usernameController.text.trim();

    Map<String, String> params = {
      if(GetUtils.isEmail(username))
        "email": username,
      if(!GetUtils.isEmail(username))
        "username": username,
      "password": passwordController.text
    };

    await RestApi(context).login(
        params,
        onResponse: (data) {
          debugPrint(data.toString());
          Loading.hide(context);

          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const MainScreen()
          ));
        },
        onError: (error) {
          Loading.hide(context);
          GetMessage.snackbarMessage('Errorr', error);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    context = context;
    return AppScaffold(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: usernameController,
                hint: "Username or Email",
                keyboardType: TextInputType.text,
                icon: Icons.person,
              ),
              AppTextField(
                controller: passwordController,
                hint: "Password",
                keyboardType: TextInputType.text,
                icon: Icons.lock,
                isSecure: true,
                maxLines: 1,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                child: AppButton(
                  text: "Log In",
                  backgroundColor: Colors.white,
                  onClick: () async {
                    await login();
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                child: AppButton(
                  text: "Sign Up",
                 onClick: (){
                   Navigator.push(
                       context, MaterialPageRoute(builder: (context) => const RegisterScreen()
                   ));
                 },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
