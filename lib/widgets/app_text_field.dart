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
  final int? maxLines;
  final int? maxLength;
  final int? minLines;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.keyboardType,
    this.icon,
    this.isSecure = false,
    this.validator,
    this.suffixIcon,
    this.maxLines,
    this.maxLength,
    this.minLines,
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
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          contentPadding: (icon == null) ? const EdgeInsets.all(20) : null,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: textColorDark
          ),
          errorStyle: const TextStyle(
            color: Colors.deepOrange
          ),
          prefixIcon: (icon != null) ? Icon(icon!, color: textColorDark) : null,
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
