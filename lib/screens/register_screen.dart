import 'dart:async';

import 'package:escore/api/rest_api.dart';
import 'package:escore/helper/colors.dart';
import 'package:escore/helper/get_message.dart';
import 'package:escore/helper/loading.dart';
import 'package:escore/screens/main_screen.dart';
import 'package:escore/widgets/app_button.dart';
import 'package:escore/widgets/app_scaffold.dart';
import 'package:escore/widgets/app_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiver/async.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  int start = 60;
  int current = 60;
  StreamSubscription? sub;
  bool resendActive = true;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  register() async {
    Loading.show(context);
    Map<String, String> params = {
      "username": usernameController.text.toString(),
      "email": emailController.text.toString(),
      "password": passwordController.text.toString(),
      "code": verificationCodeController.text.toString()
    };

    await RestApi(context).register(
        params,
        onResponse: (data) {
          Loading.hide(context);

          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const MainScreen()
          ));
        },
        onError: (error) {
          Loading.hide(context);
          GetMessage.snackbarMessage('Error', error);
        }
    );
  }

  verifyEmail() async {
    Loading.show(context);
    Map<String, String> params = {
      "email": emailController.text.toString()
    };
    debugPrint(params.toString());

    await RestApi(context).verifyEmail(
        params,
        onResponse: (data) {
          Loading.hide(context);
          GetMessage.snackbarMessage('Success', 'Code sent! Please check your email');
          setState(() {
            resendActive = false;
          });
          startTimer();
        },
        onError: (error) {
          Loading.hide(context);
          GetMessage.snackbarMessage('Error', error);
        }
    );
  }

  void startTimer() {
    CountdownTimer countDownTimer = CountdownTimer(
      Duration(seconds: start),
      const Duration(seconds: 1),
    );

    sub = countDownTimer.listen(null);
    sub!.onData((duration) {
      setState(() {
        current = start - duration.elapsed.inSeconds as int;
      });
    });

    sub!.onDone(() {
      setState(() {
        resendActive = true;
      });
      sub!.cancel();
    });
  }

  @override
  void dispose() {
    if(sub != null){
      sub?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasAppBar: true,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15),
                width: double.infinity,
                child: const Text(
                  "Sign up with your email",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    color: textColorDark,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      controller: usernameController,
                      hint: "Username",
                      keyboardType: TextInputType.text,
                      icon: Icons.person,
                      validator: (value){
                        if(value.toString().isEmpty){
                          return "Username is required\n";
                        }
                        return null;
                      },
                    ),
                    AppTextField(
                      controller: emailController,
                      hint: "Email",
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email,
                      validator: (value){
                        if(!GetUtils.isEmail(value.toString())){
                          return "Email is required\n";
                        }
                        return null;
                      },
                    ),
                    AppTextField(
                      controller: passwordController,
                      hint: "Password",
                      keyboardType: TextInputType.text,
                      icon: Icons.lock,
                      isSecure: true,
                      validator: (value){
                        if(value.toString().length < 6){
                          return "The password must be at least 6 characters\n";
                        }
                        return null;
                      },
                    ),
                    AppTextField(
                      controller: confirmPasswordController,
                      hint: "Confirm Password",
                      keyboardType: TextInputType.text,
                      icon: Icons.lock,
                      isSecure: true,
                      validator: (value){
                        if(value.toString() != passwordController.text.toString()){
                          return "Password and Confirm password must match\n";
                        }
                        return null;
                      },
                    ),
                    AppTextField(
                      controller: verificationCodeController,
                      hint: "Verification Code",
                      keyboardType: TextInputType.number,
                      icon: Icons.mark_email_read,
                      suffixIcon: TextButton(
                        child: Text(
                            resendActive ? 'Send Code' : 'Resend ${current < 10 ? '00:0$current' : '00:$current'}'
                        ),
                        onPressed: () async {
                          if(resendActive) {
                            if (GetUtils.isEmail(
                                emailController.text.toString())) {
                              await verifyEmail();
                            } else {
                              GetMessage.snackbarMessage('Info',
                                  'Before send the code please first write your email');
                            }
                          }
                        },
                      ),
                      validator: (value){
                        if(value.toString().isEmpty){
                          return "Verification Code is required\n";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                child: AppButton(
                  text: "Sign up",
                  backgroundColor: Colors.white,
                  onClick: () async {
                    if(_formKey.currentState!.validate()){
                      await register();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
