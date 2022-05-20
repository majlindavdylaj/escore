import 'package:escore/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading {

  static show(context){
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const SizedBox(
          height: 120,
          width: 120,
          child: SpinKitCubeGrid(
            color: buttonColor,
          ),
        );
      },
    );
  }

  static hide(context){
    Navigator.of(context).pop();
    FocusScope.of(context).requestFocus(FocusNode());
  }

}