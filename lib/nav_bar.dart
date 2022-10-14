import 'package:eat_for_kids/choose_user.dart';
import 'package:eat_for_kids/create_menu.dart';
import 'package:eat_for_kids/firebase/select_statements.dart';
import 'package:eat_for_kids/values/child_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sizer/sizer.dart';

import 'home.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  bool firstStarted = true;
  List<ChildValue> currentUser = [];

  @override
  void initState() {
    super.initState();
    getDataFromServer();
    //setData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getDataFromServer() async {
    if (firstStarted) {
      currentUser = await SelectStatements().selectAllUserOfCompany();

      firstStarted = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      HomeWidget(currentUser),
      ChooseUser(currentUser),
      CreateMenu(currentUser),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.refresh,
                size: 30,
              ),
              onPressed: (() => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NavBar()))),
            )
          ],
          elevation: 20,
          title: const Text('Kinder brauchen essen'),
        ),
        body: FutureBuilder(
            future: getDataFromServer(),
            builder: (context, dataSnapshot) {
              // ignore: unused_local_variable
              List<Widget> children;
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (dataSnapshot.error != null || currentUser.isEmpty) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                        child: CupertinoButton.filled(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const NavBar()));
                          },
                          child: const Text('Refresh'),
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text('Ein Fehler ist aufgetreten'),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: widgetOptions.elementAt(_selectedIndex),
                  );
                }
              }
            }),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: GNav(
                  rippleColor: Colors.grey[300]!,
                  hoverColor: Colors.grey[100]!,
                  gap: 8,
                  activeColor: Colors.black,
                  iconSize: 24,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: const Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.grey[100]!,
                  color: Colors.black,
                  tabs: const [
                    GButton(
                      icon: Icons.home,
                      text: 'Home-Screen',
                    ),
                    GButton(
                      icon: Icons.child_care,
                      text: 'Kinder anzeigen',
                    ),
                    GButton(
                      icon: Icons.list,
                      text: 'Mögliches Essen',
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              ),
            )));
  }
}
