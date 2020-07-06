import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/auth/auth_model.dart';
import '../../services/hex_color.dart';
import '../../model/appconfig/app_config_model.dart';
import '../../model/appconfig/app_locale.dart';
import '../../model/mymovie/my_movie_model.dart';

class ProfileScreenM extends StatefulWidget {
  @override
  _ProfileScreenMState createState() => _ProfileScreenMState();
}

class _ProfileScreenMState extends State<ProfileScreenM> {

  final _scaffoldProfileKey = GlobalKey<ScaffoldState>();

  bool editProfile = false;
  bool isLoading = false;
  bool isScreenLoading = false;
  dynamic currentUserData;
  File pickedImage;
  String userName;
  int numberOfMyMovie;

  
  Future<void> getCurrentUserData() async {
    dynamic _currentUserData = await Provider.of<AuthModel>(context, listen: false).authGetCurrentUserData();
    
    numberOfMyMovie = await Provider.of<AuthModel>(context, listen: false).numberOfMyMovie();

    if(_currentUserData.runtimeType == String) { // Fail
      _scaffoldProfileKey.currentState.showSnackBar(
        SnackBar(
          content: Text(_currentUserData),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        )
      );
    } else { // Success
      setState(() {
        currentUserData = _currentUserData;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCurrentUserData();
  }
  

  // @override
  // void initState() {
  //   super.initState();
  //   getCurrentUserData();
  // }

  Future<void> _editProfile() async {
    FocusScope.of(context).unfocus();

    if(pickedImage == null && userName == null) {
      _scaffoldProfileKey.currentState.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('profileEditImageOrUsernameErrorMsg')),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        )
      );
      return ;
    }

    if(userName == '') {
      _scaffoldProfileKey.currentState.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('profileEditUsernameErrorMsg')),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        )
      );
      return ;
    }

    print('Validation Done');

    setState(() {
      isLoading = true;
    });

    Provider.of<AuthModel>(context, listen: false).authProfileEdit(pickedImage, userName)
    .then((err) {
      if(err == null){ // Success
        _scaffoldProfileKey.currentState.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('successfullyEdited')),
          backgroundColor: Colors.green[700],
          duration: const Duration(seconds: 2),
        ));
        setState(() {
          isLoading = false;
          editProfile = false;
        });
        getCurrentUserData();
        return ;
      }
      _scaffoldProfileKey.currentState.showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        ));
        setState(() {
          isLoading = false;
        });
        return ;
    });
  }

  Future<void> _onClickImagePicker(String type) async {
    
    File _pickedImage;

    if(type == 'camera') {
      _pickedImage = await ImagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50 // 0 - 100
      );
    } else { // gallery
      _pickedImage = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50 // 0 - 100
      );
    }

    // If user clicks back button
    if(_pickedImage == null) {
      Navigator.of(context).pop();
      return ;
    }

    // Real Device Path
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(_pickedImage.path);
    final savedImage = await _pickedImage.copy('${appDir.path}/$fileName');

    setState(() {
      pickedImage = savedImage;
    });
    
    Navigator.of(context).pop();

    // print(pickedImage.path);
  }

  void _showImagePickerModal(BuildContext ctx, Size screenSize) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(ctx).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: HexColor('#d90429')
          ),
          height: screenSize.height * .08,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () { _onClickImagePicker('camera'); },
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              GestureDetector(
                onTap: () { _onClickImagePicker('gallery'); },
                child: Icon(
                  Icons.photo_size_select_actual,
                  color: Colors.white,
                  size: 27,
                ),
              ),
            ],
          )
        )
        );
      }
    );
  }

  Future<void> onClickDeleteMovies(BuildContext ctx) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('deleteMyMovieList'), style: TextStyle(fontFamily: 'Quicksand-Bold'),),
          content: Text(AppLocalizations.of(context).translate('deleteMyMovieListContent'), style: TextStyle(fontSize: 15)),
          elevation: 5,
          actions: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('close'), style: TextStyle(fontFamily: 'Quicksand-Bold', color: Colors.black87)),
              onPressed: () { Navigator.of(context).pop(); },
            ),
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('delete'), style: TextStyle(fontFamily: 'Quicksand-Bold', color: HexColor('#d90429'))),
              onPressed: () {
                setState(() {
                  isScreenLoading = true;
                });
                Navigator.of(context).pop();
                Provider.of<MyMovieModel>(context, listen: false).deleteMyMovieList()
                .then((err) async {
                if(err == null){ // Success
                  setState(() {
                    isScreenLoading = false;
                  });
                  _scaffoldProfileKey.currentState.showSnackBar(
                  SnackBar(
                    // Note!! ctx from build function !!
                    content: Text(AppLocalizations.of(ctx).translate('successfullyDeleted')),
                    backgroundColor: Colors.green[700],
                    duration: const Duration(seconds: 2),
                  ));
                  await getCurrentUserData();
                  return ;
                }
                _scaffoldProfileKey.currentState.showSnackBar(
                  SnackBar(
                    // Note!! ctx from build function !!
                    content: Text(err),
                    backgroundColor: Theme.of(ctx).errorColor,
                    duration: const Duration(seconds: 2),
                  ));
                  setState(() {
                    isScreenLoading = false;
                  });
                  return ;
                });              
              }
            ),
          ],
        );
      }
    );
  }

  Future<void> onClickChangeLanguage (BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    print(prefs.getString('language_code'));

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('changeLanguageFullText'), style: TextStyle(fontFamily: 'Quicksand-Bold'),),
          content: Text(AppLocalizations.of(context).translate('translationNotSupportText'), style: TextStyle(fontSize: 15)),
          elevation: 5,
          actions: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('close'), style: TextStyle(fontFamily: 'Quicksand-Bold', color: Colors.black87)),
              onPressed: () { Navigator.of(context).pop(); },
            ),
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('english'), style: TextStyle(fontFamily: 'Quicksand-Bold', color: HexColor('#d90429'))),
              onPressed: () {
                Provider.of<AppConfigModel>(context, listen: false).changeLanguage(Locale("en"));
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('korean'), style: TextStyle(fontFamily: 'Quicksand-Bold', color: HexColor('#d90429'))),
              onPressed: () {
                Provider.of<AppConfigModel>(context, listen: false).changeLanguage(Locale("ko"));
                Navigator.of(context).pop();
              }
            ),
          ],
        );
      }
    );
  }

  Future<void> onClickChangePassword(BuildContext ctx) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('changePasswordText'), style: TextStyle(fontFamily: 'Quicksand-Bold'),),
          content: Text(AppLocalizations.of(context).translate('changePasswordTextContent'), style: TextStyle(fontSize: 15)),
          elevation: 5,
          actions: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('close'), style: TextStyle(fontFamily: 'Quicksand-Bold', color: Colors.black87)),
              onPressed: () { Navigator.of(context).pop(); },
            ),
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('changeText'), style: TextStyle(fontFamily: 'Quicksand-Bold', color: HexColor('#d90429'))),
              onPressed: () {
                setState(() {
                  isScreenLoading = true;
                });
                Navigator.of(context).pop();
                Provider.of<AuthModel>(context, listen: false).changePassword()
                .then((err) async {
                if(err == null){ // Success
                  setState(() {
                    isScreenLoading = false;
                  });
                  _scaffoldProfileKey.currentState.showSnackBar(
                  SnackBar(
                    // Note!! ctx from build function !!
                    content: Text(AppLocalizations.of(ctx).translate('successfullySendEmail')),
                    backgroundColor: Colors.green[700],
                    duration: const Duration(seconds: 2),
                  ));
                  return ;
                }
                _scaffoldProfileKey.currentState.showSnackBar(
                  SnackBar(
                    // Note!! ctx from build function !!
                    content: Text(err),
                    backgroundColor: Theme.of(ctx).errorColor,
                    duration: const Duration(seconds: 2),
                  ));
                  setState(() {
                    isScreenLoading = false;
                  });
                  return ;
                });              
              }
            ),
          ],
        );
      }
    );
  }

  Future<void> onClickDeleteAccount(BuildContext ctx, Size screenSize) async {

    String password = '';
    String feedback = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('deleteAccountText'), style: TextStyle(fontFamily: 'Quicksand-Bold'),),
          content: Container(
            height: screenSize.height * .35,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(AppLocalizations.of(context).translate('deleteAccountTextContent'), style: TextStyle(fontSize: 15, color: HexColor('#d90429'))),
                  SizedBox(height: screenSize.height * .03),
                  TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.black,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    key: ValueKey('checkPassword'),
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).translate('passwordHintText'),
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  SizedBox(height: screenSize.height * .03),
                  TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    maxLines: null,
                    cursorColor: Colors.black,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    key: ValueKey('feedback'),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).translate('leaveFeedbackContent'),
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      feedback = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          elevation: 5,
          actions: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('close'), style: TextStyle(fontFamily: 'Quicksand-Bold', color: Colors.black87)),
              onPressed: () { Navigator.of(context).pop(); },
            ),
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('delete'), style: TextStyle(fontFamily: 'Quicksand-Bold', color: HexColor('#d90429'))),
              onPressed: () {
                if(password == '') {
                  Navigator.of(context).pop();
                  _scaffoldProfileKey.currentState.showSnackBar(
                  SnackBar(
                    // Note!! ctx from build function !!
                    content: Text(AppLocalizations.of(ctx).translate('enterPassword')),
                    backgroundColor: Theme.of(ctx).errorColor,
                    duration: const Duration(seconds: 2),
                  ));
                  return ;
                }
                // feedback does NOT need validation

                setState(() {
                  isScreenLoading = true;
                });

                Navigator.of(context).pop();
                Provider.of<AuthModel>(context, listen: false).deleteAccount(password, feedback)
                .then((err) async {
                if(err == null){ // Success
                  // Automatically go to auth screen (auth state change)
                  return ;
                }
                _scaffoldProfileKey.currentState.showSnackBar(
                  SnackBar(
                    // Note!! ctx from build function !!
                    content: Text(err),
                    backgroundColor: Theme.of(ctx).errorColor,
                    duration: const Duration(seconds: 2),
                  ));
                  setState(() {
                    isScreenLoading = false;
                  });
                  return ;
                });
              }
            ),
          ],
        );
      }
    );
  }

  Future<void> onClickSignOut() async {
    Provider.of<AuthModel>(context, listen: false).authSignOut();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldProfileKey,
      backgroundColor: Colors.white,
      body: isScreenLoading
      ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(HexColor('#d90429')),
        ),
      )
      : GestureDetector(
        onTap: () { FocusScope.of(context).unfocus(); },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              width: double.infinity,
              height: screenSize.height * .45,
              decoration: BoxDecoration(
                color: HexColor('#d90429'),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      if(editProfile) {
                        _showImagePickerModal(context, screenSize);
                      }
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle
                      ),
                      alignment: Alignment.center,
                      child: (currentUserData != null && currentUserData.containsKey('user_image') && pickedImage == null)
                      ? ClipOval(
                        child: Container(
                          width: 120,
                          height: 120,
                          child: Image.network(currentUserData['user_image'], fit: BoxFit.cover)
                        ) 
                      )
                      : pickedImage == null
                      ? Text(
                        editProfile ? AppLocalizations.of(context).translate('tabHere') : AppLocalizations.of(context).translate('noImage'),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15
                        ),
                      )
                      : ClipOval(
                        child: Container(
                          width: 120,
                          height: 120,
                          child: Image.file(
                            pickedImage,
                            fit: BoxFit.cover,
                          ),
                        ) 
                      )
                    )
                  ),
                  SizedBox(height: screenSize.height * .01),
                  if(!editProfile)
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    width: screenSize.width * .8,
                    child: Text(
                      currentUserData == null ? '' : currentUserData['username'],
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Quicksand-Bold',
                        fontSize: 16,
                      ),
                    )
                  ),
                  if(editProfile)
                  Container(
                    padding: EdgeInsets.only(left: 2, bottom: 4),
                    height: 50,
                    alignment: Alignment.center,
                    width: screenSize.width * .8,
                    child: TextFormField(
                      readOnly: editProfile ? false : true,
                      // maxLines: null,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      cursorColor: Colors.white,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Quicksand-Bold',
                        fontSize: 16,
                      ),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      key: ValueKey('editUserName'),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      /* initialValue == null || controller == null': is not true (Error -> Can not use initialValue & controller simultaneously) */
                      initialValue: currentUserData['username'],
                      onChanged: (value) {
                        userName = value;
                      },
                    ),
                  ),
                  if(editProfile)
                  Container(
                    height: 25,
                  ),
                  if(!editProfile)
                  Container(
                    alignment: Alignment.center,
                    height: 25,
                    width: screenSize.width * .8,
                    child: Text(
                      currentUserData == null
                      ? ''
                      : currentUserData['email'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )
            ),
            if(!editProfile)
            Positioned(
              top: screenSize.height * .5,
              left: 0,
              right: 0,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 30),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).translate('numberOfMyMovie'),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontFamily: 'Quicksand-Bold'
                            ),
                          ),
                          Text(
                            '$numberOfMyMovie',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 24,
                              fontFamily: 'Quicksand-Bold'
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * .05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () { onClickDeleteMovies(context); },
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.grey[800],
                                  size: 34,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                AppLocalizations.of(context).translate('deleteMovie'),
                                style: TextStyle(color: Colors.grey[800])
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () { onClickDeleteAccount(context, screenSize); },
                                child: Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.grey[800],
                                  size: 34,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                AppLocalizations.of(context).translate('deleteAccount'),
                                style: TextStyle(color: Colors.grey[800])
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * .07),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () { onClickChangePassword(context); },
                                child: Icon(
                                  Icons.lock_outline,
                                  color: Colors.grey[800],
                                  size: 34,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                AppLocalizations.of(context).translate('changePassword'),
                                style: TextStyle(color: Colors.grey[800])
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () { onClickChangeLanguage(context); },
                                child: Icon(
                                  Icons.g_translate,
                                  color: Colors.grey[800],
                                  size: 34,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                AppLocalizations.of(context).translate('changeLanguage'),
                                style: TextStyle(color: Colors.grey[800])
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: onClickSignOut,
                                child: Icon(
                                  Icons.exit_to_app,
                                  color: Colors.grey[800],
                                  size: 34,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                AppLocalizations.of(context).translate('signOut'),
                                style: TextStyle(color: Colors.grey[800])
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if(!editProfile)
            Positioned(
              top: screenSize.height * .06,
              right: screenSize.width * .06,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    editProfile = !editProfile;
                  });
                },
                child: Icon(
                  Icons.create,
                  size: 24,
                  color: Colors.white,
                ),
              )
            ),
            if(editProfile)
            Positioned(
              top: screenSize.height * .06,
              left: screenSize.width * .06,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    editProfile = !editProfile;
                  });
                  userName = null;
                  pickedImage = null;
                },
                child: Icon(
                  Icons.keyboard_arrow_left,
                  size: 32,
                  color: Colors.white,
                ),
              )
            ),
            if(editProfile)
            Positioned(
              top: screenSize.height * .06,
              right: screenSize.width * .06,
              child: GestureDetector(
                onTap: _editProfile,
                child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                )
                : Icon(
                  Icons.save,
                  size: 25,
                  color: Colors.white,
                ),
              )
            ),
          ],
        ),
      )
    );
  }
}

class ProfileScreenT extends StatefulWidget {
  @override
  _ProfileScreenTState createState() => _ProfileScreenTState();
}

class _ProfileScreenTState extends State<ProfileScreenT> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}