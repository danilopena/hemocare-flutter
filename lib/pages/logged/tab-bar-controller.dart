import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:hemocare/pages/logged/graph.dart';
import 'package:hemocare/pages/logged/new-infusion.dart';
import 'package:hemocare/pages/logged/reports.dart';
import 'package:hemocare/utils/ColorTheme.dart';

class TabBarController extends StatefulWidget {
  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController> {
  int currentPage = 0;
  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        circleColor: ColorTheme.lightPurple,
        inactiveIconColor: Colors.grey,
        tabs: [
          TabData(
              iconData: Icons.graphic_eq,
              title: "Início",
              onclick: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState;
                fState.setPage(0);
              }),
          TabData(
              iconData: Icons.add,
              title: "Infusões",
              onclick: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState;
                fState.setPage(1);
              }),
          TabData(
              iconData: Icons.report,
              title: "Relatórios",
              onclick: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState;
                fState.setPage(2);
              })
        ],
        initialSelection: 0,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          print("Position $position");
          setState(() {
            currentPage = position;
          });
        },
      ),
    );
  }

  _getPage(int page) {
    print("I`m in page $page");
    switch (page) {
      case 0:
        return Graph();
      case 1:
        return Infusions();
      default:
        return Reports();
    }
  }
}
