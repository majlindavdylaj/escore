import 'package:escore/helper/colors.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {

  final bool isBackgroundDark;
  final Widget child;
  final Widget? bottomNavigationBar;
  final bool hasAppBar;

  const AppScaffold({
    Key? key,
    this.isBackgroundDark = true,
    required this.child,
    this.bottomNavigationBar,
    this.hasAppBar = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hasAppBar ? AppBar(
        elevation: 0,
        backgroundColor: isBackgroundDark ? backgroundDark : backgroundMediumDark,
        iconTheme: const IconThemeData(
          color: textColorMedium, //change your color here
        ),
      ) : PreferredSize(preferredSize: const Size(0.0, 0.0),child: Container(),),
      backgroundColor: isBackgroundDark ? backgroundDark : backgroundMediumDark,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
