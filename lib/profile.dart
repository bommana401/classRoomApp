// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'announcements/announcementPage.dart';
import 'events/eventsPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;
  late String email;
  late String firstName;
  late String lastName;
  late String phoneNumber;
  late String bio;
  // need the hours variable

  Future<void> loadData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      email = userData.get('email');
      firstName = userData.get('firstName');
      lastName = userData.get('lastName');
      // phoneNumber = userData.get('phoneNumber');
      // bio = userData.get('bio');
    });
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    loadData();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        //backgroundColor: Color.fromARGB(255, 255, 159, 91),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 46, 123, 191),
                Colors.white,
              ],
              stops: [0.25, 0.25],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50, // adjust the size of the profile photo
                    backgroundImage: NetworkImage(
                        'https://example.com/profile-image.jpg'), // replace with the URL of the profile photo
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  // Display the Email & Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(firstName),
                      SizedBox(width: 5),
                      Text(lastName),
                    ],
                  ),
                  Text(email),
                  SizedBox(
                    height: 16,
                  ),
                  // Box that will hold the volunteer hours
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 46, 123, 191),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Volunteer hours"),
                        SizedBox(width: 20),
                        // the volunteer hours
                        Container(
                          height: 45,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromARGB(255, 252, 138, 85),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(0.8),
                                child: Text("0"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // space between the hours and events
                  SizedBox(
                    height: 16,
                  ),

                  // second container that will hold the next events
                  Container(
                    //color: Colors.indigoAccent,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //border: Border.all(
                      color: Color.fromARGB(255, 46, 123, 191),
                      //width: 1,
                      // ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Events"),
                        SizedBox(width: 5),
                        // the volunteer hours
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.announcement_outlined),
              label: 'Announcements',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              label: 'Events',
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
            } else if (index == 2) {
              // add this else-if block
              // checks if profile button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventsPage()),
              );
            } else if (index == 3) {
              // add this else-if block
              // checks if profile button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            }

            // update the selected index to change the highlighted tab
            setState(() {
              _selectedIndex = index;
            });
          },
        ));
  }
}
