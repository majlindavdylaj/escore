import 'package:escore/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetMessage {

  static snackbarMessage(String title, String message){
    Get.snackbar(title, message, leftBarIndicatorColor: Colors.transparent, colorText: Colors.white);
  }
}