import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../effect/fade_transition.dart';
import '../../const/const_routes/const_routes.dart';
import '../../screens/auth/forgotpassword_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // print(settings.name); // url
    switch (settings.name) {
      // var argMap = settings.arguments as Map;  
      case ConstRoutes.forgotpassword:
        return FadeRoute(
          page: ScreenTypeLayout(
            mobile: ForgotPasswordScreenM(),
            tablet: ForgotPasswordScreenT(),
          ),
        );
      default: return null;
    }
  }
}