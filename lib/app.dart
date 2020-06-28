import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:responsive_builder/responsive_builder.dart';

import './navigation/routes/routes.dart';
import './app_init.dart';
import './model/lifecycle.dart';
import './model/appconfig/app_config_model.dart';
import './model/auth/auth_model.dart';
import './model/search/search_model.dart';
import './model/add/add_model.dart';
import './screens/auth/auth_screen.dart';
import './screens/bottom_nav.dart';

class App extends StatelessWidget {

  final _appConfigModel = AppConfigModel();
  final _authModel = AuthModel();
  final _searchModel = SearchModel();
  final _addModel = AddModel();

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
                ChangeNotifierProvider.value(value: _addModel),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                builder: DevicePreview.appBuilder,
                title: 'Movie Memory',
                theme: ThemeData(
                  fontFamily: 'Quicksand-Medium'
                ),
                home: AppInit(
                  onNext: (appConfig) {  
                    print('Loaded All AppInit Data Successfully');         
                    print(appConfig);           
                    return StreamBuilder(
                      stream: FirebaseAuth.instance.onAuthStateChanged, // Call when the state of auth is changed
                      builder: (context, userSnapshot) {
                        if(userSnapshot.connectionState == ConnectionState.waiting) {
                          return Scaffold(
                            backgroundColor: Colors.white,
                            body: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Checking Sign In Information',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Quicksand-Bold',
                                      color: Colors.black87
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