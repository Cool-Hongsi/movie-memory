import 'package:flutter/material.dart';

class MyMovieDetailScreenM extends StatefulWidget {
  
  final Map argMap;
  MyMovieDetailScreenM({ this.argMap });

  @override
  _MyMovieDetailScreenMState createState() => _MyMovieDetailScreenMState();
}

class _MyMovieDetailScreenMState extends State<MyMovieDetailScreenM> {
  @override
  Widget build(BuildContext context) {

    print(widget.argMap);

    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('Back'),
          onPressed: () { Navigator.of(context).pop(); },
        ),
      ),
    );
  }
}

class MyMovieDetailScreenT extends StatefulWidget {

  final Map argMap;
  MyMovieDetailScreenT({ this.argMap });

  @override
  _MyMovieDetailScreenTState createState() => _MyMovieDetailScreenTState();
}

class _MyMovieDetailScreenTState extends State<MyMovieDetailScreenT> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}