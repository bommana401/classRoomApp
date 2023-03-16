// import 'dart:async';

// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'EditAnnouncementPage .dart';
import 'package:intl/intl.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  //this saves the user role and email.
  String role = "";
  String email = "";
  String firstName = "";
  String lastName = "";

  Future<void> _submitAnnouncement() async {
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
    });
    //do I need to do this for _descriptionController
    if (_subjectController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('announcements').add({
        'subject': _subjectController.text, //this was 'text'
        'description': _descriptionController.text,
        'timestamp': DateTime.now().toUtc(),
        'userId': user.uid,
        'name': firstName + lastName,
      });
      _subjectController.clear();
      _descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'), //title
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore
                  .instance //does this add the annoucement into the firebase?
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
                //this is where the error is occuring most likley.
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final announcement = snapshot.data!.docs[index];
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(announcement['name'] + ":",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 89, 0),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(
                                  DateFormat.yMd().add_jm().format(
                                      announcement['timestamp'].toDate()),
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 89, 0),
                                      fontSize: 15),
                                ),
                              ]),
                          SizedBox(height: 4),
                          Text(announcement['subject'],
                              style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                          Text(announcement['description'],
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      onTap: () {
                        if (role == 'Admin') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAnnouncementPage(
                                  announcement: announcement),
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
          if (role == 'Admin')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        hintText: 'subject',
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'description',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _submitAnnouncement,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
