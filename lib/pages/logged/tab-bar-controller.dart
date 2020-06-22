import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  int selectedPos;
  GlobalKey bottomNavigationKey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedPos = 0;
  }

  @override
  Widget build(BuildContext context) {
    List<TabData> fancyTabItems = [
      TabData(iconData: FontAwesomeIcons.home, title: 'Início'),
      TabData(iconData: FontAwesomeIcons.syringe, title: 'Infusões'),
      TabData(iconData: FontAwesomeIcons.fileMedicalAlt, title: 'Relatório'),
    ];
    return Scaffold(
      body: Container(
        child: Center(
          child: _getPage(selectedPos),
        ),
      ),
      bottomNavigationBar: Container(
        child: SafeArea(
            child: FancyBottomNavigation(
          tabs: fancyTabItems,
          circleColor: ColorTheme.lightPurple,
          activeIconColor: Colors.white,
          inactiveIconColor: Colors.grey,
          textColor: Colors.black,
          onTabChangedListener: (position) {
            setState(() {
              selectedPos = position;
            });
          },
        )),
      ),
    );
  }

  StatefulWidget _getPage(int page) {
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
