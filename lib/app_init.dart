import 'dart:async';

import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart'; // Brings functionality to execute code after the first layout of a widget has been performed
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:responsive_builder/responsive_builder.dart';

import './screens/reusuable/loading/loading_screen.dart';
import './screens/start/start_screen.dart';

class AppInit extends StatefulWidget {
  AppInit({this.onNext});

  final Function onNext;

  @override
  _AppInitState createState() => _AppInitState();
}

class _AppInitState extends State<AppInit> with AfterLayoutMixin<AppInit> {
  bool isLoading = true;
  bool isStartSlide = false;
  Map appConfig = {};

  @override
  void afterFirstLayout(BuildContext context) async {
    await loadInitData();
    Timer(Duration(seconds: 3), () { // Not necessary
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> loadInitData() async {
    print("[APP INIT] Initial Data");
    await DotEnv().load('.env');

    // appConfig = await Provider.of<AppConfig>(context, listen: false).loadAppConfig();

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if(prefs.getString('userData') != null){
    //   print(prefs.getString('userData'));
    // } else {
    //   print('no login data');
    // }

    if (mounted) {
      print('Mounted !');
      // Load all necessary
    }
  }

  void _slideStartBtn() {
    setState(() {
      isStartSlide = true;
    });
  }

  Widget onNextScreen() {
    if (!isStartSlide) {
      return ScreenTypeLayout(
        mobile: StartScreenM(slideStartBtn: _slideStartBtn),
        tablet: StartScreenT(slideStartBtn: _slideStartBtn)
      );
    }

    return widget.onNext(appConfig);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen();
    }
    return onNextScreen();
  }
}