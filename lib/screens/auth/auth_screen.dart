import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/auth/auth_model.dart';
import '../reusuable/loading/loading_screen.dart';
import '../../services/hex_color.dart';
import '../../model/appconfig/app_locale.dart';

enum AuthMode { Signup, Login }

class AuthScreenM extends StatefulWidget {
  @override
  _AuthScreenMState createState() => _AuthScreenMState();
}

class _AuthScreenMState extends State<AuthScreenM> {
  AuthMode _authMode = AuthMode.Login;

  bool isLoading = false;
  bool isValidating = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _authFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _saveForm() async {
    final validation = _authFormKey.currentState.validate();

    if (!isValidating) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    if (_authMode == AuthMode.Login) {
      Provider.of<AuthModel>(context, listen: false)
          .authLogin(
              _emailController.text.trim(), _passwordController.text.trim())
          .then((err) {
        if (err == null) return;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(err),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        ));
        setState(() {
          isLoading = false;
        });
      });
    } else {
      Provider.of<AuthModel>(context, listen: false)
          .authSignUp(_emailController.text.trim(),
              _passwordController.text.trim(), _usernameController.text.trim())
          .then((err) {
        if (err == null) return;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(err),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        ));
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  void _switchAuthMode() {
    _emailController.clear();
    _passwordController.clear();
    _usernameController.clear();

    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        resizeToAvoidBottomInset:
            false, // Prevent push contents when the keyboard shows up
        body: isLoading
            ? LoadingScreen()
            : LayoutBuilder(builder: (context, deviceSize) {
                return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Stack(
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(top: screenSize.height * 0.05),
                            width: double.infinity,
                            height: screenSize.height * 0.4,
                            child: Image.asset(
                              'assets/images/auth_image.png',
                            )),
                        Container(
                            // color: Colors.black.withOpacity(0.2),
                            ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: screenSize.height * 0.8,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: const Radius.circular(40)),
                                color: Color.fromRGBO(240, 240, 240, 0.9)),
                            child: SingleChildScrollView(
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenSize.width * 0.1),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: screenSize.height * 0.1),
                                      if (_authMode == AuthMode.Login)
                                        Container(
                                            height: 50,
                                            alignment: Alignment.centerRight,
                                            child: FlatButton(
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'forgotPassword'),
                                                  style: TextStyle(
                                                      // fontFamily: 'Questrial',
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    '/forgotpassword');
                                              },
                                            )),
                                      if (_authMode == AuthMode.Signup)
                                        Container(
                                          height: 50,
                                        ),
                                      SizedBox(
                                          height: screenSize.height * 0.008),
                                      Form(
                                          key: _authFormKey,
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                width: double.infinity,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    color: Colors.white
                                                    // gradient: LinearGradient(
                                                    //   begin: Alignment.topRight,
                                                    //   end: Alignment.bottomLeft,
                                                    //   colors: [Colors.grey[400], Colors.grey[200]]
                                                    // ),
                                                    ),
                                                child: TextFormField(
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  cursorColor: Colors.black,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  autocorrect: false,
                                                  textCapitalization:
                                                      TextCapitalization.none,
                                                  enableSuggestions: false,
                                                  key: ValueKey('email'),
                                                  validator: (value) {
                                                    if (value.isEmpty ||
                                                        !value.contains('@')) {
                                                      Scaffold.of(context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .translate(
                                                                    'emailErrorMsg')),
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .errorColor,
                                                        duration:
                                                            const Duration(
                                                                seconds: 2),
                                                      ));
                                                      setState(() {
                                                        isValidating = false;
                                                      });
                                                      return null;
                                                    }
                                                    setState(() {
                                                      isValidating = true;
                                                    });
                                                    return null;
                                                  },
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  decoration: InputDecoration(
                                                    hintText: AppLocalizations
                                                            .of(context)
                                                        .translate(
                                                            'emailHintText'),
                                                    hintStyle: TextStyle(
                                                        color: Colors.black),
                                                    border: InputBorder.none,
                                                    prefixIcon: Icon(
                                                      Icons.alternate_email,
                                                      size: 18,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  controller: _emailController,
                                                ),
                                              ),
                                              SizedBox(height: 25),
                                              Container(
                                                width: double.infinity,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    color: Colors.white
                                                    // gradient: LinearGradient(
                                                    //   begin: Alignment.topRight,
                                                    //   end: Alignment.bottomLeft,
                                                    //   colors: [Colors.grey[400], Colors.grey[200]]
                                                    // ),
                                                    ),
                                                child: TextFormField(
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  cursorColor: Colors.black,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  autocorrect: false,
                                                  textCapitalization:
                                                      TextCapitalization.none,
                                                  enableSuggestions: false,
                                                  key: ValueKey('password'),
                                                  validator: (value) {
                                                    if (value.isEmpty ||
                                                        value.length < 7) {
                                                      Scaffold.of(context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .translate(
                                                                    'passwordErrorMsg')),
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .errorColor,
                                                        duration:
                                                            const Duration(
                                                                seconds: 2),
                                                      ));
                                                      setState(() {
                                                        isValidating = false;
                                                      });
                                                      return null;
                                                    }
                                                    setState(() {
                                                      isValidating = true;
                                                    });
                                                    return null;
                                                  },
                                                  obscureText: true,
                                                  decoration: InputDecoration(
                                                    hintText: AppLocalizations
                                                            .of(context)
                                                        .translate(
                                                            'passwordHintText'),
                                                    hintStyle: TextStyle(
                                                        color: Colors.black),
                                                    border: InputBorder.none,
                                                    prefixIcon: Icon(
                                                      Icons.lock,
                                                      size: 18,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  controller:
                                                      _passwordController,
                                                ),
                                              ),
                                              if (_authMode == AuthMode.Signup)
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 25),
                                                  width: double.infinity,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      color: Colors.white
                                                      // gradient: LinearGradient(
                                                      //   begin: Alignment.topRight,
                                                      //   end: Alignment.bottomLeft,
                                                      //   colors: [Colors.grey[400], Colors.grey[200]]
                                                      // ),
                                                      ),
                                                  child: TextFormField(
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    cursorColor: Colors.black,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                    autocorrect: false,
                                                    textCapitalization:
                                                        TextCapitalization.none,
                                                    enableSuggestions: false,
                                                    key: ValueKey('username'),
                                                    validator: (value) {
                                                      if (value.isEmpty ||
                                                          value.length < 4) {
                                                        Scaffold.of(context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .translate(
                                                                      'usernameErrorMsg')),
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .errorColor,
                                                          duration:
                                                              const Duration(
                                                                  seconds: 2),
                                                        ));
                                                        setState(() {
                                                          isValidating = false;
                                                        });
                                                        return null;
                                                      }
                                                      setState(() {
                                                        isValidating = true;
                                                      });
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: AppLocalizations
                                                              .of(context)
                                                          .translate(
                                                              'usernameHintText'),
                                                      hintStyle: TextStyle(
                                                          color: Colors.black),
                                                      border: InputBorder.none,
                                                      prefixIcon: Icon(
                                                        Icons.person,
                                                        size: 18,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    controller:
                                                        _usernameController,
                                                  ),
                                                ),
                                              SizedBox(height: 25),
                                              GestureDetector(
                                                onTap: _saveForm,
                                                child: Container(
                                                    width: double.infinity,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      color:
                                                          HexColor('#d90429'),
                                                      // boxShadow: [
                                                      //   BoxShadow(
                                                      //     color: Colors.grey.withOpacity(0.5),
                                                      //     spreadRadius: 3,
                                                      //     blurRadius: 10,
                                                      //     offset: Offset(0, 4),
                                                      //   ),
                                                      // ],
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      _authMode ==
                                                              AuthMode.Login
                                                          ? AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'loginText')
                                                          : AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'signupText'),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )),
                                              ),
                                              if (_authMode == AuthMode.Login)
                                                // GestureDetector(
                                                //   onTap: () { Provider.of<AuthModel>(context, listen: false).authGoogleSignIn(); },
                                                //   child: Container(
                                                //     margin: EdgeInsets.only(top: 25),
                                                //     width: double.infinity,
                                                //     height: 50,
                                                //     decoration: BoxDecoration(
                                                //       borderRadius: BorderRadius.all(Radius.circular(20)),
                                                //       border: Border.all(width: 2, color: HexColor('#d90429')),
                                                //       color: Color.fromRGBO(240, 240, 240, 0.9)
                                                //       // boxShadow: [
                                                //       //   BoxShadow(
                                                //       //     color: Colors.grey.withOpacity(0.5),
                                                //       //     spreadRadius: 3,
                                                //       //     blurRadius: 10,
                                                //       //     offset: Offset(0, 4),
                                                //       //   ),
                                                //       // ],
                                                //     ),
                                                //     alignment: Alignment.center,
                                                //     child: Row(
                                                //       mainAxisAlignment: MainAxisAlignment.center,
                                                //       children: <Widget>[
                                                //         Container(
                                                //           width: 25,
                                                //           height: 25,
                                                //           alignment: Alignment.center,
                                                //           child: Image.asset('assets/images/google-logo.jpg', color: HexColor('#d90429'), fit: BoxFit.cover),
                                                //         ),
                                                //         SizedBox(width: 10),
                                                //         Text(
                                                //           AppLocalizations.of(context).translate('googleLogin'),
                                                //           style: TextStyle(
                                                //             color: HexColor('#d90429'),
                                                //             fontSize: 17,
                                                //             fontWeight: FontWeight.bold,
                                                //             // fontFamily: 'Questrial',
                                                //           ),
                                                //         )
                                                //       ],
                                                //     )
                                                //   ),
                                                // ),
                                                SizedBox(
                                                    height: screenSize.height *
                                                        0.02),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  if (_authMode ==
                                                      AuthMode.Signup)
                                                    SizedBox(
                                                        height:
                                                            screenSize.height *
                                                                0.09),
                                                  Text(
                                                    '${_authMode == AuthMode.Login ? AppLocalizations.of(context).translate('dontHaveAccount') : AppLocalizations.of(context).translate('alreadyHaveAccount')}',
                                                    style: TextStyle(
                                                        // fontFamily: 'Questrial',
                                                        fontSize: 16),
                                                  ),
                                                  FlatButton(
                                                    child: Text(
                                                      '${_authMode == AuthMode.Login ? AppLocalizations.of(context).translate('signupText') : AppLocalizations.of(context).translate('loginText')}',
                                                      style: TextStyle(
                                                          // fontFamily: 'Questrial',
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    onPressed: _switchAuthMode,
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  height:
                                                      screenSize.height * 0.3),
                                            ],
                                          )),
                                    ],
                                  )),
                            ),
                          ),
                        )
                      ],
                    ));
              }));
  }
}

class AuthScreenT extends StatefulWidget {
  @override
  _AuthScreenTState createState() => _AuthScreenTState();
}

class _AuthScreenTState extends State<AuthScreenT> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
