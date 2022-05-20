import 'package:escore/helper/colors.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {

  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hint;
  final IconData? icon;
  final bool isSecure;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.keyboardType,
    this.icon,
    this.isSecure = false,
    this.validator,
    this.suffixIcon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: backgroundLight,
      ),
      child: TextFormField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        obscureText: isSecure,
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: textColorDark
          ),
          errorStyle: const TextStyle(
            color: Colors.deepOrange
          ),
          prefixIcon: Icon(icon!, color: textColorDark),
          suffixIcon: suffixIcon,
        ),
        style: const TextStyle(
            color: textColorWhite
        ),
        validator: validator,
      ),
    );
  }
}
