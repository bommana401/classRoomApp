import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:classroomapp/announcements/announcementPage.dart';

// import 'eventCheckList.dart';

class EditEventsPage extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> event;

  EditEventsPage({required this.event});

  @override
  _EditEventsPageState createState() => _EditEventsPageState();
}

class _EditEventsPageState extends State<EditEventsPage> {
  // final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  List<dynamic> volunteersSignedUp = <dynamic>[];
  Map<String, bool> attendanceStatus = {};
  // final TextEditingController _signedUpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.event['name'];
    _locationController.text = widget.event['location'];
    _dateController.text = widget.event['date'];
    _startTimeController.text = widget.event['start'];
    _endTimeController.text = widget.event['end'];
    volunteersSignedUp = widget.event['signedUp'];
    print('in here');
    print("volunteersSignedUp: $volunteersSignedUp");
    // _signedUpController.text = widget.event['signedUp'];
  }

  //need to add time, location to events page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter event name',
              ),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Enter event location',
              ),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                hintText: 'Enter event date',
              ),
            ),
            TextField(
              controller: _startTimeController,
              decoration: InputDecoration(
                hintText: 'Enter start time',
              ),
            ),
            TextField(
              controller: _endTimeController,
              decoration: InputDecoration(
                hintText: 'Enter start time',
              ),
            ),
            ElevatedButton(
              child: Text('Update Event'),
              onPressed: () async {
                await widget.event.reference.update({
                  'name': _nameController.text,
                  'location': _locationController.text,
                  'date': _dateController.text,
                  'start': _startTimeController.text,
                  'end': _endTimeController.text,
                  'timestamp': DateTime.now().toUtc(),
                });
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('Delete Event'),
              onPressed: () async {
                await widget.event.reference.delete();
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: volunteersSignedUp.isEmpty
                  ? Center(
                      child: Text('No sign ups'),
                    )
                  : ListView.builder(
                      itemCount: volunteersSignedUp.length,
                      itemBuilder: (BuildContext context, int index) {
                        // Get the name of the volunteer
                        String volunteerName =
                            volunteersSignedUp[index]['volunteer'];

                        // Initialize the attendance status for this volunteer if it hasn't been set yet
                        attendanceStatus.putIfAbsent(
                            volunteerName, () => false);

                        return ListTile(
                          leading: Checkbox(
                            value: attendanceStatus[volunteerName],
                            onChanged: (newValue) {
                              setState(() {
                                // Update the attendance status for this volunteer
                                attendanceStatus[volunteerName] = newValue!;
                                // Update the 'attended' field in the volunteersSignedUp list
                                volunteersSignedUp[index]['attended'] =
                                    newValue ? '1' : '0';
                              });
                            },
                          ),
                          title: Text(volunteerName),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
