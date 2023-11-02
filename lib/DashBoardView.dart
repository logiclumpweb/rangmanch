import 'dart:async';
import 'dart:io';

// import 'package:champcash/tab/HomeView.dart';
import 'package:champcash/tab/ProfileView.dart';
import 'package:champcash/tab/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Color? homeIConColor = Colors.black,
      hashIconColor,
      chatIconColor,
      profileIconColor;

  int index = 0;
  final List<Widget> _children = [
    const HomeView(),
    const HomeView(),
    //CMessageView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return WillPopScope(
      onWillPop: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xff262424),
              title: Text("Exit?",
                  style:
                      GoogleFonts.inter(color: Colors.white, fontSize: 15.0)),
              content: Text("Are you sure you want to exit?",
                  style:
                      GoogleFonts.inter(color: Colors.white, fontSize: 15.0)),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Helvetica Neue',
                      fontSize: 14.899999618530273,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),

                TextButton(
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Helvetica Neue',
                      fontSize: 14.899999618530273,
                    ),
                  ),
                  onPressed: () {
                    exit(0);
                  },
                ),
                // usually buttons at the bottom of the dialog
              ],
            );
          },
        );
        return Future.value(false);
      },
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: 70,
          child: BottomNavigationBar(
            onTap: onTabTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            backgroundColor: const Color(0xffFE9B0E),
            showSelectedLabels: true,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            currentIndex: index,
            items: [
              BottomNavigationBarItem(
                label: "",
                icon: Image.asset(
                  "assets/homeicon.png",
                  height: 25,
                  color: homeIConColor,
                ),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: Image.asset("assets/hashicon.png",
                    height: 25, color: hashIconColor),
              ),
              // BottomNavigationBarItem(
              //   label: 'Shopping',
              //   icon: Icon(FontAwesomeIcons.shoppingBag),
              // ),
              /*BottomNavigationBarItem(
                label: "",
                icon: Image.asset(
                  "assets/chaticon.png",
                  height: 25,
                  color: chatIconColor,
                ),
              ),*/
              //TextStyle(fontWeight: FontWeight.w500,
              //   fontSize: 15)
              BottomNavigationBarItem(
                label: "",
                icon: Image.asset(
                  "assets/profileicon.png",
                  height: 25,
                  color: profileIconColor,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        body: _children[index],
      ),
    );
  }

  void onTabTapped(int index1) {
    setState(() {
      index = index1;

      if (index == 0) {
        homeIConColor = Colors.black;
        hashIconColor = Colors.white60;
        chatIconColor = Colors.white60;
        profileIconColor = Colors.white60;
      } else if (index == 1) {
        homeIConColor = Colors.white60;
        hashIconColor = Colors.black;
        chatIconColor = Colors.white60;
        profileIconColor = Colors.white60;
      } else if (index == 2) {
        homeIConColor = Colors.white60;
        hashIconColor = Colors.white60;
        chatIconColor = Colors.black;
        profileIconColor = Colors.white60;
      } else if (index == 3) {
        homeIConColor = Colors.white60;
        hashIconColor = Colors.white60;
        chatIconColor = Colors.white60;
        profileIconColor = Colors.black;
      }
    });
  }
}
