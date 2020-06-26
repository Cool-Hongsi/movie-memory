import 'package:flutter/material.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';

import './mymovie/my_movie_screen.dart';
import './searchmovie/search_movie_screen.dart';
import './profile/profile_screen.dart';

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

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: NavigationScreen(
            pageList[widget.bottomNavIndex]
          ),
          bottomNavigationBar: Container( 
            height: screenSize.height * 0.13,
            child: BottomAppBar(
              child: Container(
                child: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  selectedItemColor: Colors.black87,
                  unselectedItemColor: Colors.grey[400],
                  onTap: (index) => setState(() => widget.bottomNavIndex = index),
                  currentIndex: widget.bottomNavIndex,
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.movie, size: 24), title: Text('MyMovie', style: TextStyle(height: 1.5, fontSize: 14))),
                    BottomNavigationBarItem(icon: Icon(Icons.search, size: 24), title: Text('Search', style: TextStyle(height: 1.5, fontSize: 14))),
                    BottomNavigationBarItem(icon: Icon(Icons.person, size: 24), title: Text('Profile', style: TextStyle(height: 1.5, fontSize: 14))),
                  ]
                ),
              ),
            )
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.grey[700],
            child: Icon(Icons.add),
            onPressed: () {  },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          colors: [Colors.grey[100], Colors.grey[800]],
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