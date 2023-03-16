import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditEventsPage extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> event;

  EditEventsPage({required this.event});

  @override
  _EditEventsPageState createState() => _EditEventsPageState();
}

class _EditEventsPageState extends State<EditEventsPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _subjectController.text = widget.event['subject'];
    _descriptionController.text = widget.event['description'];
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
              controller: _subjectController,
              decoration: InputDecoration(
                hintText: 'Enter your subject',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Enter your description',
              ),
            ),
            //need to add a sign up button
            ElevatedButton(
              child: Text('Update Event'),
              onPressed: () async {
                await widget.event.reference.update({
                  'subject': _subjectController.text,
                  'description': _descriptionController.text,
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
          ],
        ),
      ),
    );
  }
}
