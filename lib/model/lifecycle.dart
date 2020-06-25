import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;

  LifeCycleManager({Key key, this.child}) : super(key: key);
  
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}
class _LifeCycleManagerState extends State<LifeCycleManager> with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // When LifeCycle is changed, it will be called
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    if(state == AppLifecycleState.inactive) {
      print('Inactive');
    }
    else if(state == AppLifecycleState.paused){
      print('Paused');
    }
    else if(state == AppLifecycleState.resumed){
      print('Resume');
    }
    else if(state == AppLifecycleState.detached){
      print('Detached');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}