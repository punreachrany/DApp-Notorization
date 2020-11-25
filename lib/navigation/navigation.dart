import 'dart:ui';
import 'package:Notorization/screens/notarization/Notorization.dart';
import 'package:Notorization/screens/developers/developers.dart';
import 'package:Notorization/screens/documents_list/documents_list.dart';
import 'package:Notorization/screens/documents_list/documents_list_wrapper.dart';
import 'package:Notorization/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationWrapper extends StatefulWidget {
  @override
  _NavigationWrapperState createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  int currentTab = 0;
  // initial screen in viewport
  Widget currentScreen = Notorization();
  //Widget currentScreen = UploadSuccessful();

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    //

    return Scaffold(
      backgroundColor: Colors.grey[900],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 5.0,
        child: Container(
          color: Colors.grey[900],
          height: 60,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Home
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentScreen = Notorization();
                    currentTab = 0;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.home,
                      color:
                          currentTab == 0 ? bottomNavigatorColor : Colors.grey,
                    ),
                    Text(
                      "Notarization",
                      style: TextStyle(
                        color: currentTab == 0
                            ? bottomNavigatorColor
                            : Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                minWidth: width / 4,
              ),

              // Document List
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentScreen = DocumentsListWrapper();
                    currentTab = 1;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // SvgPicture.asset(
                    //   'assets/images/dashboard.svg',
                    //   color: currentTab == 2 ? bottomNavigatorColor : null,
                    // ),
                    Icon(
                      // Icons.show_chart,
                      // Icons.dashboard,
                      //Icons.crop_square,
                      Icons.list_alt,
                      color:
                          currentTab == 1 ? bottomNavigatorColor : Colors.grey,
                    ),
                    Text(
                      "Documents",
                      style: TextStyle(
                        color: currentTab == 1
                            ? bottomNavigatorColor
                            : Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                minWidth: width / 4,
              ),
              // Document List
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentScreen = Developers();
                    currentTab = 2;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // SvgPicture.asset(
                    //   'assets/images/dashboard.svg',
                    //   color: currentTab == 2 ? bottomNavigatorColor : null,
                    // ),
                    Icon(
                      // Icons.show_chart,
                      // Icons.dashboard,
                      //Icons.crop_square,
                      Icons.developer_mode,
                      color:
                          currentTab == 2 ? bottomNavigatorColor : Colors.grey,
                    ),
                    Text(
                      "Developers",
                      style: TextStyle(
                        color: currentTab == 2
                            ? bottomNavigatorColor
                            : Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                minWidth: width / 4,
              ),
            ],
          ),
        ),
        shape: CircularNotchedRectangle(),
      ),
    );
  }
}
