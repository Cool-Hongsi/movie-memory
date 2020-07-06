import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as service;
import 'package:device_preview/device_preview.dart';

import './app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    // Set Prefer Portrait Mode
    service.SystemChrome.setPreferredOrientations(
      [service.DeviceOrientation.portraitUp, service.DeviceOrientation.portraitDown]
    );

    service.SystemChrome.setSystemUIOverlayStyle(
      service.SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );
  }
  
  runApp(
    DevicePreview(
      enabled: kReleaseMode, // !kReleaseMode (open device preview) , kReleaseMode (close device preview)
      builder: (context) => App()
    ),
  );
}