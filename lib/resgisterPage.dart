// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({required this.showLoginPage, super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordsController = TextEditingController();
    final _firstName = TextEditingController();
    final _lastName = TextEditingController();
    final _roleController = TextEditingController();

    // List of items in our dropdown menu
    var options = [
      //items
      'Volunteer',
      'Admin',
      'Parent',
      'Student',
    ];

    String _currentItemSelected = 'Volunteer';
    FirebaseAuth auth = FirebaseAuth.instance;

    Future<void> signUp() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      try {
        UserCredential result = await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordsController.text.trim(),
        );

        User? user = result.user;
        if (user != null) {
          await firestore.collection("users").doc(user.uid).set({
            "firstName": _firstName.text.trim(),
            "lastName": _lastName.text.trim(),
            "email": _emailController.text.trim(),
            "role": _currentItemSelected,
            "password": _passwordsController.text.trim()
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          devtools.log('Weak Password. Enter again');
        } else if (e.code == 'email-already-in-use') {
          devtools.log('Email already in use.');
        } else if (e.code == 'invalid-email') {
          devtools.log('Invalid email entered');
        }
      }
    }

    void dispose() {
      _emailController.dispose();
      _passwordsController.dispose();
      super.dispose();
    }

    return Scaffold(
      backgroundColor: Colors.orange[600],
      // ignore: prefer_const_literals_to_create_immutables
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(
                //   Icons.phone_android,
                //   size: 100,
                // ),

                SizedBox(height: 25),
                Text(
                  'Register below with you details.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _firstName,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            'First Name', //the wierd input in the text before anyone types in anything
                      ),
                    ),
                  ),
                ),

                //last name
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _lastName,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            'Last Name', //the wierd input in the text before anyone types in anything
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                //email text field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            'Email', //the wierd input in the text before anyone types in anything
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                //password text field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _passwordsController, //holds the value.
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            'Password', //the wierd input in the text before anyone types in anything
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return DropdownButton(
                      value: _currentItemSelected,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: options.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentItemSelected = newValue!;
                        });
                      },
                    );
                  },
                ),

                //sign up box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: GestureDetector(
                    onTap: signUp, //on tap, calles the sign up method
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                //already a member, then log in
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
