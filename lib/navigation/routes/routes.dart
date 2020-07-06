import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../effect/fade_transition.dart';
import '../../const/const_routes/const_routes.dart';
import '../../screens/auth/forgotpassword_screen.dart';
import '../../screens/searchmovie/detail_movie_screen.dart';
import '../../screens/mymovie/my_movie_detail_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // print(settings.name); // url
    // print(settings.arguments); // parameter
    
    switch (settings.name) {
      case ConstRoutes.forgotpassword:
        return FadeRoute(
          page: ScreenTypeLayout(
            mobile: ForgotPasswordScreenM(),
            tablet: ForgotPasswordScreenT(),
          ),
        );
      case ConstRoutes.detailmovie:
        var argMap = settings.arguments as Map;
        return FadeRoute(
          page: ScreenTypeLayout(
            mobile: DetailMovieScreenM(argMap: argMap),
            tablet: DetailMovieScreenT(argMap: argMap),
          )
        );
      case ConstRoutes.mymoviedetail:
        var argMap = settings.arguments as Map;
        return FadeRoute(
          page: ScreenTypeLayout(
            mobile: MyMovieDetailScreenM(argMap: argMap),
            tablet: MyMovieDetailScreenT(argMap: argMap),
          )
        );
      default: return null;
    }
  }
}
