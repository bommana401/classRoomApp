// import 'dart:async';

// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'EditEventsPage .dart';

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
  final TextEditingController _timeController = TextEditingController();

  //this saves the user role and email.
  String role = "";
  String email = "";
  String firstName = "";
  String lastName = "";

  Future<void> _submitEvent() async {
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
    });
    //need to edit this part
    if (_nameController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('events').add({
        'name': _nameController.text,
        'location': _locationController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'userId': user.uid,
        'createdby': firstName + lastName,
        'signedUp': <String>[],
        'attended': <String>[],
        'timestamp': DateTime.now().toUtc(),
      });
      _nameController.clear();
      _locationController.clear();
      _dateController.clear();
      _timeController.clear();
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
                    return ListTile(
                      title: Text(event['name']), //this was 'text'
                      leading: Text(event['location']),
                      subtitle: Text(firstName + " " + lastName),
                      trailing: Text(event['timestamp'].toDate().toString()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditEventsPage(event: event),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: 'Location',
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      hintText: 'Date',
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: TextField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      hintText: 'Time',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _submitEvent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
