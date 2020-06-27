import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import './add_my_movie_modal.dart';

class MyMovieScreenM extends StatefulWidget {
  @override
  _MyMovieScreenMState createState() => _MyMovieScreenMState();
}

class _MyMovieScreenMState extends State<MyMovieScreenM> {

  void _showAddMovieModal(BuildContext ctx, Size screenSize) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
      // ),
      builder: (_) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(ctx).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: screenSize.height * .85,
          child: ScreenTypeLayout(
            mobile: AddMyMovieModalM(),
            tablet: AddMyMovieModalT(),
          ),
        )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[700],
        child: Icon(Icons.add),
        onPressed: () { _showAddMovieModal(context, screenSize); },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Center(
        child: Text(
          'Hello'
        )
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