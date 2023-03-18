// import 'dart:async';

// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'EditEventsPage .dart';
import 'package:intl/intl.dart';
import 'package:classroomapp/profile.dart';
import 'package:classroomapp/homePage.dart';
import 'package:classroomapp/announcements/announcementPage.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _signedUpController = TextEditingController();

  //this saves the user role and email.
  String role = "";
  String email = "";
  String firstName = "";
  String lastName = "";
  bool isAdmin = false;
  Map<String, dynamic> myMap = {};
  List<String> signedUpList = [];
  // bool signedUp = false;
  bool hasSignedUp = false;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  int _selectedIndex = 2;

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
      role = data['role']; //gets the role field77
      email = data['email']; //gets the email field
      firstName = data['firstName'];
      lastName = data['lastName'];
      isAdmin = role == "Admin";
    });
  }

  Future<void> _submitEvent() async {
    if (_nameController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('events').add({
        'name': _nameController.text,
        'location': _locationController.text,
        'date': _dateController.text,
        'start': _startTimeController.text,
        'end': _endTimeController.text,
        'userId': user.uid,
        'createdby': firstName + lastName,
        'signedUp': <dynamic>[],
        'attended': <String>[],
        'timestamp': DateTime.now().toUtc(),
      });
      _nameController.clear();
      _locationController.clear();
      _dateController.clear();
      _startTimeController.clear();
      _endTimeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Events'), //title
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore
                    .instance //does this add the annoucement into the firebase?
                    .collection('events')
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
                  //this is where the error is occuring most likley.
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final event = snapshot.data!.docs[index];
                      final QueryDocumentSnapshot<Object?> currentEvent =
                          snapshot.data!.docs[index];
                      // _signedUpController.text = currentEvent['signedUp'];
                      List<String> signedUpList = List<String>.from(
                          currentEvent['signedUp']
                              .map((dynamic item) => item.toString()));
                      _signedUpController.text = signedUpList.join(', ');

                      final user = FirebaseAuth.instance.currentUser!;
                      final eventId = currentEvent.id;
                      final List<dynamic> signedUp = currentEvent['signedUp'];
                      int lst = signedUp.length;
                      bool isSignedUp = false;
                      if (lst > 0) {
                        Map y = signedUp[lst - 1];
                        var value = y["volunteerUserId"];
                        // print("value: " + value);
                        // print("user ID" + user.uid);
                        if (value == user.uid) {
                          isSignedUp = true;
                        }
                      } else {
                        print("No sign up yet");
                      }

                      // Define a reference to the Firebase database
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(event['createdby'] + ":",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 255, 89, 0),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(
                                    DateFormat.yMd()
                                        .add_jm()
                                        .format(event['timestamp'].toDate()),
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 255, 89, 0),
                                        fontSize: 15),
                                  ),
                                ]),
                            SizedBox(height: 4),
                            Text(event['name'], style: TextStyle(fontSize: 14)),
                            SizedBox(height: 4),
                            Text("Location: " + event['location'],
                                style: TextStyle(fontSize: 12)),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "On " +
                                        event['date'] +
                                        " at: " +
                                        event['start'] +
                                        " from " +
                                        event['end'],
                                    style: TextStyle(fontSize: 12)),
                                SizedBox(height: 4),
                              ],
                            ),
                            isSignedUp
                                ? ElevatedButton(
                                    onPressed: () {},
                                    child: Text('You signed up'),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.green),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () =>
                                        _handleSignUp(currentEvent),
                                    child: Text('Sign up'),
                                  ),
                          ],
                        ),
                        onTap: () {
                          if (isAdmin == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditEventsPage(event: event),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
            //admin can only have these powers.
            if (isAdmin)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Name',
                        ),
                        enabled: isAdmin,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          hintText: 'Location',
                        ),
                        enabled: isAdmin,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: TextField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          hintText: 'Date',
                        ),
                        enabled: isAdmin,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: TextField(
                        controller: _startTimeController,
                        decoration: InputDecoration(
                          hintText: 'Start Time',
                        ),
                        enabled: isAdmin,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: TextField(
                        controller: _endTimeController,
                        decoration: InputDecoration(
                          hintText: 'End Time',
                        ),
                        enabled: isAdmin,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: isAdmin ? _submitEvent : null,
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
              icon: Icon(Icons.calendar_month),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          unselectedItemColor: Colors.blue,
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
              _selectedIndex = 2;
            });
          },
        ));
  }

  void _handleSignUp(QueryDocumentSnapshot<Object?> event) async {
    final eventId = event.id;
    final user = FirebaseAuth.instance.currentUser!;
    final eventRef =
        FirebaseFirestore.instance.collection('events').doc(eventId);

    var data = (await FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .get())
        .data()!;

    Map<String, dynamic> myMap = {};
    myMap["event"] = data['name'];
    myMap["volunteer"] = firstName;
    myMap["volunteerUserId"] = user.uid;
    myMap["attended"] = "0";
    List<dynamic> signedUpList = List.from(data['signedUp']);
    signedUpList.add(myMap);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Sign Up"),
          content: Text("Are you sure you want to sign up for this event?"),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Sign Up"),
              onPressed: () async {
                _handleSignUp(event);
                // Navigator.pop(context);
                await eventRef.update({'signedUp': signedUpList});
                Navigator.pop(context);
                Navigator.pop(context); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("You signed up for the event."),
                ));
              },
            ),
          ],
        );
      },
    );

    // Add the user's ID to the signedUp field of the event in Firebase
    // await eventRef.update({
    //   'signedUp': signedUpList,
    // });

    // Update the UI to show that the user has signed up
    setState(() {
      hasSignedUp = true;
    });
  }
}
