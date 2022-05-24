import 'package:escore/api/rest_api.dart';
import 'package:escore/helper/colors.dart';
import 'package:escore/helper/loading.dart';
import 'package:escore/helper/session.dart';
import 'package:escore/screens/login_screen.dart';
import 'package:escore/screens/main/home_screen.dart';
import 'package:escore/screens/main/profile_screen.dart';
import 'package:escore/screens/register_screen.dart';
import 'package:escore/widgets/app_button.dart';
import 'package:escore/widgets/app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = const <Widget>[
    HomeScreen(),
    LoginScreen(),
    LoginScreen(),
    LoginScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
        backgroundColor: backgroundLight,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: textColorDark,
        selectedItemColor: whiteColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.game_controller),
            activeIcon: Icon(CupertinoIcons.gamecontroller_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_grid_2x2),
            activeIcon: Icon(CupertinoIcons.square_grid_2x2_fill),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add_circled),
            activeIcon: Icon(CupertinoIcons.add_circled_solid),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bell),
            activeIcon: Icon(CupertinoIcons.bell_fill),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
