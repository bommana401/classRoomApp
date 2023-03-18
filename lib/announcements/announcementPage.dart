// import 'dart:async';

// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'EditAnnouncementPage .dart';
import 'package:intl/intl.dart';
import 'package:classroomapp/profile.dart';
import 'package:classroomapp/homePage.dart';
import 'package:classroomapp/events/eventsPage.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final user = FirebaseAuth.instance.currentUser!; // this had !

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  //this saves the user role and email.
  String role = "";
  String email = "";
  String firstName = "";
  String lastName = "";
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _fetchUserRole() async {
    var data = (await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get())
        .data()!;

    setState(() {
      role = data['role']; //gets the role field
      email = data['email']; //gets the email field
      firstName = data['firstName'];
      lastName = data['lastName'];
      isAdmin = role == "Admin";
    });
  }

  Future<void> _submitAnnouncement() async {
    if (_subjectController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('announcements').add({
        'subject': _subjectController.text, //this was 'text'
        'description': _descriptionController.text,
        'timestamp': DateTime.now().toUtc(),
        'userId': user.uid,
        'name': firstName + lastName,
        'role': role,
      });
      _subjectController.clear();
      _descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Announcements',
            style: TextStyle(color: Colors.black),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(10.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 1.0, color: Color.fromARGB(255, 252, 138, 85)),
                  left: BorderSide(width: 8.0, color: Colors.transparent),
                  right: BorderSide(width: 8.0, color: Colors.transparent),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('announcements')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final announcement = snapshot.data!.docs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      announcement['name'],
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 255, 89, 0),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      DateFormat.yMd().add_jm().format(
                                            announcement['timestamp'].toDate(),
                                          ),
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 255, 89, 0),
                                        fontSize: 8,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  announcement['subject'],
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  announcement['description'],
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (isAdmin == true) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditAnnouncementPage(
                                      announcement: announcement,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            /* ADMIN VIEW & CONTROL */
            if (isAdmin)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextField(
                        controller: _subjectController,
                        decoration: InputDecoration(
                          hintText: 'subject',
                        ),
                        enabled: isAdmin,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: 'description',
                        ),
                        enabled: isAdmin,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: isAdmin ? _submitAnnouncement : null,
                    ),
                  ],
                ),
              ),
          ],
        ),
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
              icon: Icon(Icons.calendar_today_outlined),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          unselectedItemColor: Color.fromARGB(255, 15, 76, 129),
          selectedItemColor: Colors.orange,
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (index == 0) {
              // check if the Announcements tab is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            } else if (index == 1) {
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            }

            // update the selected index to change the highlighted tab
            setState(() {
              _selectedIndex = 1;
            });
          },
        ));
  }
}
