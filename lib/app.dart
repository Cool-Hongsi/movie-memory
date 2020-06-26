import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_builder/responsive_builder.dart';

import './navigation/routes/routes.dart';
import './app_init.dart';
import './model/lifecycle.dart';
import './model/appconfig/app_config_model.dart';
import './model/auth/auth_model.dart';
import './model/search/search_model.dart';
import './screens/auth/auth_screen.dart';
import './screens/bottom_nav.dart';

class App extends StatelessWidget {

  final _appConfigModel = AppConfigModel();
  final _authModel = AuthModel();
  final _searchModel = SearchModel();

  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
      child: ChangeNotifierProvider(
        create: (context) => _appConfigModel,
        child: Consumer<AppConfigModel>( // AppConfigModel Rebuild Point
          builder: (context, value, child) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: _authModel),
                ChangeNotifierProvider.value(value: _searchModel),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                builder: DevicePreview.appBuilder,
                title: 'Movie Memory',
                theme: ThemeData(),
                home: AppInit(
                  onNext: (appConfig) {  
                    print('Loaded All AppInit Data Successfully');         
                    print(appConfig);           
                    return StreamBuilder(
                      stream: FirebaseAuth.instance.onAuthStateChanged, // Call when the state of auth is changed
                      builder: (context, userSnapshot) {
                        if(userSnapshot.connectionState == ConnectionState.waiting) {
                          return Scaffold(
                            backgroundColor: Colors.grey[400],
                            body: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SpinKitFoldingCube(
                                    color: Colors.white70,
                                    size: 70.0,
                                  ),
                                  SizedBox(height: 45),
                                  Text(
                                    'Checking Sign In Information',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Questrial',
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              )
                            ),
                          );
                        }
                        if(userSnapshot.hasData) { // There is token data
                          return ScreenTypeLayout(
                            mobile: BottomNavM(),
                            tablet: BottomNavT(),
                          );
                        } else { // There is no token data
                          return ScreenTypeLayout(
                            mobile: AuthScreenM(),
                            tablet: AuthScreenT(),
                          );
                        }
                      },
                    );
                  } 
                ),
                // routes: {},
                onGenerateRoute: Routes.generateRoute,
                // onUnknownRoute: (settings) {},
              )
            );
          },
        ),
      ),
    );
  }
}