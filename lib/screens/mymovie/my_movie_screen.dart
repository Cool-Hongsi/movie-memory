import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyMovieScreenM extends StatefulWidget {
  @override
  _MyMovieScreenMState createState() => _MyMovieScreenMState();
}

class _MyMovieScreenMState extends State<MyMovieScreenM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('Sign Out'),
          onPressed: () { FirebaseAuth.instance.signOut(); },
        ),
      ),
    );
  }
}

class MyMovieScreenT extends StatefulWidget {
  @override
  _MyMovieScreenTState createState() => _MyMovieScreenTState();
}

class _MyMovieScreenTState extends State<MyMovieScreenT> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}