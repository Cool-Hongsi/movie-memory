import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreenM extends StatefulWidget {
  @override
  _ProfileScreenMState createState() => _ProfileScreenMState();
}

class _ProfileScreenMState extends State<ProfileScreenM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FlatButton(
          child: Text('Sign Out'),
          onPressed: () { FirebaseAuth.instance.signOut(); },
        ),
      ),
    );
  }
}

class ProfileScreenT extends StatefulWidget {
  @override
  _ProfileScreenTState createState() => _ProfileScreenTState();
}

class _ProfileScreenTState extends State<ProfileScreenT> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}