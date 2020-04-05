import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
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
  CircularBottomNavigationController _navigationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedPos = 0;
    _navigationController = new CircularBottomNavigationController(selectedPos);
  }

  @override
  Widget build(BuildContext context) {
    List<TabItem> tabItems = List.of([
      TabItem(FontAwesomeIcons.home, "Início", ColorTheme.lightPurple),
      TabItem(FontAwesomeIcons.syringe, "Infusões", ColorTheme.lightPurple),
      TabItem(
          FontAwesomeIcons.fileMedicalAlt, "Relatório", ColorTheme.lightPurple),
    ]);

    return Scaffold(
      body: Container(
        child: Center(
          child: _getPage(selectedPos),
        ),
      ),
      bottomNavigationBar: Container(
        child: SafeArea(
          child: CircularBottomNavigation(
            tabItems,
            iconsSize: 24,
            controller: _navigationController,
            selectedCallback: (int selected) {
              setState(() {
                selectedPos = selected;
                print(_navigationController.value);
              });
            },
          ),
        ),
      ),
    );
  }

  _getPage(int page) {
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
