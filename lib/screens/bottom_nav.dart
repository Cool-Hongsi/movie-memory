import 'dart:io';

import 'package:flutter/material.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';

import './mymovie/my_movie_screen.dart';
import './searchmovie/search_movie_screen.dart';
import './profile/profile_screen.dart';
import '../services/hex_color.dart';

class BottomNavM extends StatefulWidget {

  int bottomNavIndex;

  BottomNavM({ this.bottomNavIndex = 0 });

  @override
  _BottomNavMState createState() => _BottomNavMState();
}

class _BottomNavMState extends State<BottomNavM> {

  // Page List
  final pageList = <dynamic>[
    MyMovieScreenM(), // 0
    SearchMovieScreenM(), // 1
    ProfileScreenM(), // 2
  ];

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, deviceSize) {
        int iosWithEarBodyHeight = (Platform.isIOS && deviceSize.maxHeight >= 737) ? 30 : 0;
        
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: NavigationScreen(
            pageList[widget.bottomNavIndex]
          ),
          bottomNavigationBar: Container( 
            height: screenSize.height * .1 + iosWithEarBodyHeight,
            child: BottomAppBar(
              child: Container(
                child: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  selectedItemColor: HexColor('#d90429'),
                  unselectedItemColor: Colors.grey[400],
                  onTap: (index) => setState(() => widget.bottomNavIndex = index),
                  currentIndex: widget.bottomNavIndex,
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.movie_creation, size: 24), title: Container()),
                    BottomNavigationBarItem(icon: Icon(Icons.search, size: 24), title: Container()),
                    BottomNavigationBarItem(icon: Icon(Icons.person, size: 24), title: Container()),
                  ]
                ),
              ),
            )
          ),
        );
      }
    );
  }
}

class NavigationScreen extends StatefulWidget {
  final Widget pageData;

  NavigationScreen(this.pageData) : super();

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void didUpdateWidget(NavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageData != widget.pageData) {
      _startAnimation();
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    super.initState();
  }

  _startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.black26],
        ),
      ),
      child: Center(
        child: CircularRevealAnimation(
          animation: animation,
          centerOffset: Offset(0, 0),
          maxRadius: MediaQuery.of(context).size.longestSide * 1.1,
          child: widget.pageData
        ),
      ),
    );
  }
}

class BottomNavT extends StatefulWidget {
  @override
  _BottomNavTState createState() => _BottomNavTState();
}

class _BottomNavTState extends State<BottomNavT> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}