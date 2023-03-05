// ignore_for_file: prefer_interpolation_to_compose_strings, use_function_type_syntax_for_parameters, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'announcements/announcementPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  //this saves the user role and email.
  String role = "";
  String email = "";
  String firstName = "";

  Future<void> loadData() async {
    var data = (await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get())
        .data()!;

    setState(() {
      role = data['role']; //gets the role field
      email = data['email']; //gets the email field
      firstName = data['firstName'];
    });
  }

  //The loadData() function is an asynchronous function that retrieves data from
  //Firebase and updates the state of the widget with the retrieved data.
  // By calling loadData() in initState(), the widget is initialized with the
  //data from Firebase before it is displayed to the user.
  @override
  void initState() {
    super.initState();
    loadData();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //this code displays the messages on the home screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Role: ' + role),
            Text('email: ' + email), //'Signed in as: ' + user.displayName!
            Text('firstName: ' + firstName),
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              color: Colors.red,
              child: Text('Sign out'),
            )
          ],
        ),
      ),
      // bottom navigation bar.

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            // check if the Announcements tab is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AnnouncementPage()),
            );
          }
          // update the selected index to change the highlighted tab
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
