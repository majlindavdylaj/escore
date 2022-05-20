import 'package:escore/helper/colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {

  IconData? icon;
  String? text;
  Color? backgroundColor;
  VoidCallback onClick;

  AppButton({
    Key? key,
    this.icon,
    this.text,
    this.backgroundColor,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: backgroundColor ?? buttonColor,
        onPrimary: backgroundColor != null ? backgroundLight : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0)
        )
      ),
      onPressed: () {
        onClick();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(icon != null)
            Icon(icon, size: 22),
          if(icon != null)
            const SizedBox(width: 10),
          if(text != null)
            Text(text!.toUpperCase())
        ],
      ),
    );
  }
}
