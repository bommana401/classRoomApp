import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditAnnouncementPage extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> announcement;

  EditAnnouncementPage({required this.announcement});

  @override
  _EditAnnouncementPageState createState() => _EditAnnouncementPageState();
}

class _EditAnnouncementPageState extends State<EditAnnouncementPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _subjectController.text = widget.announcement['subject'];
    _descriptionController.text = widget.announcement['description'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Announcement'),
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
            ElevatedButton(
              child: Text('Update Announcement'),
              onPressed: () async {
                await widget.announcement.reference.update({
                  'subject': _subjectController.text,
                  'description': _descriptionController.text,
                  'timestamp': DateTime.now().toUtc(),
                });
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('Delete Announcement'),
              onPressed: () async {
                await widget.announcement.reference.delete();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
