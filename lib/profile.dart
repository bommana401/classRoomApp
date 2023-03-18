// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'announcements/announcementPage.dart';
import 'events/eventsPage.dart';
import 'homePage.dart';

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

  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 252, 138, 85),
          title: Text('Profile'),
        ),
        body: Stack(
          // add a Stack widget here
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 15, 76, 129),
                    Color.fromARGB(132, 255, 255, 255),
                  ],
                  stops: [0.2, 3],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // SizedBox(height: 50),

/* THE PROFILE */
                            CircleAvatar(
                              radius: 70,
                              //backgroundImage: AssetImage('images/cal.png'),
                            ),
                            SizedBox(height: 16),

/* THE BOX WITH FIRST & LAST NAME */
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  firstName,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  lastName,
                                  style: TextStyle(
                                      fontSize: 24.0, color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              email,
                              style: TextStyle(
                                color: Color.fromARGB(255, 217, 217, 217),
                              ),
                            ),
                            SizedBox(height: 16),
/* THE SPACE BETWEEN THE BLUE LINE AND THE BOX */
                            // SizedBox(height: 50),
                            Expanded(
                              // evenly spaces the widgets inside it while also stretching it
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 15, 76, 129),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(
                                          10.0), // add 10 pixel margin on all sides

                                      child: Text(
                                        'Service Hours',
                                        style: TextStyle(
                                          color: Colors.white,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              14,
                                          fontFamily: 'Playfair Display',
                                        ),
                                      ),
                                    ),
                                    //SizedBox(width: 20),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 60,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color:
                                              Color.fromARGB(255, 252, 138, 85),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(0.8),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text("0",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            14,
                                                    fontFamily:
                                                        'Playfair Display',
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 50),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 15, 76, 129),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        'images/cal.png',
                                        height: 50.0,
                                        width: 50.0,
                                      ),
                                    ),
                                    //SizedBox(width: 10),
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Column(
                                          // makes it in the center
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // WILL DISPLAY THE EVENT NAME
                                            //Padding(
                                            //padding: EdgeInsets.all(8.0),
                                            //child:
// The sizing of the event name (FIX LATER)
                                            Container(
                                              width: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                //color: Color.fromARGB(255, 252, 138, 85),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(0.8),
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                        "Your next event",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              14,
                                                          fontFamily:
                                                              'Playfair Display',
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            //),

                                            // WILL HAVE THE LOCATION AND DATE
                                            Row(
                                              children: [
                                                // Location
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "Location",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              26,
                                                      fontFamily:
                                                          'Playfair Display',
                                                    ),
                                                  ),
                                                ),
                                                // Date
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "Date",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              26,
                                                      fontFamily:
                                                          'Playfair Display',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 5),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Add the object(s) you want to display on top
            Positioned(
              top: 50,
              left: 0,
              right: 340,
              child: Transform.rotate(
                angle: 140, // specify the angle of rotation in degrees
                child: Image(
                  image: AssetImage('images/paper1.png'),
                  width: 35,
                  height: 35,
                ),
              ),
            ),

            Positioned(
              top: 100,
              left: 0,
              right: 200,
              child: Transform.rotate(
                angle:
                    110, // specify the angle of rotation in degrees // 20 is downright 30 is upleft 50 is up right
                child: Image(
                  image: AssetImage('images/paper2.png'),
                  width: 40,
                  height: 40,
                ),
              ),
            ),

            Positioned(
              top: 30,
              left: 0,
              right: 10,
              child: Transform.rotate(
                angle: 0, // specify the angle of rotation in degrees
                child: Image(
                  image: AssetImage('images/paper1.png'),
                  width: 75,
                  height: 75,
                ),
              ),
            ),

            Positioned(
              top: 110,
              left: 180,
              right: 0,
              child: Transform.rotate(
                angle: 20, // specify the angle of rotation in degrees
                child: Image(
                  image: AssetImage('images/paper2.png'),
                  width: 45,
                  height: 45,
                ),
              ),
            ),

            Positioned(
              top: 160,
              left: 330,
              right: 0,
              child: Transform.rotate(
                angle: 25, // specify the angle of rotation in degrees
                child: Image(
                  image: AssetImage('images/paper1.png'),
                  width: 35,
                  height: 35,
                ),
              ),
            ),
          ],
        ),

/* THE NAVIGATION BAR*/

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
              _selectedIndex = 3;
            });
          },
        ));
  }
}
