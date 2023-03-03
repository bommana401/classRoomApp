import 'package:classroomapp/authPage.dart';
import 'package:classroomapp/homePage.dart';
import 'package:classroomapp/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance
              .authStateChanges(), //checks if the user is logged in or not
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //if we have a user, then return home_page. Return home page for Admins and volunteers.
              return HomePage();
            } else {
              return AuthPage();
            }
          }),
    );
  }
}
