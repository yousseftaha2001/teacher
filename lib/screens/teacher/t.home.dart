import 'package:chatapp/providers/authprovider.dart';
import 'package:chatapp/providers/firestoreprovider.dart';
import 'package:chatapp/screens/teacher/t.assignments.dart';
import 'package:chatapp/screens/teacher/t.room.dart';
import 'package:chatapp/screens/teacher/t.profile.dart';
import 'package:chatapp/screens/teacher/t.tasks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherHome extends StatefulWidget {
  static const routeName = "/T.Home";

  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {

  int _selectedIndex = 0;
  final List<Widget> pages = [
    TTasks(),
    Rooms(),

    TProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.work,
            ),
            label: "My tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.school,
            ),
            label: "Rooms",
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            label: "My Profile",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white30,
        selectedFontSize: 14,
        unselectedFontSize: 11,
        backgroundColor: Color(0xff132743),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
