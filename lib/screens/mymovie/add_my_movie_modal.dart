import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../model/add/add_model.dart';
import '../../services/hex_color.dart';

class AddMyMovieModalM extends StatefulWidget {

  final Function addMovieSuccess;
  AddMyMovieModalM({ this.addMovieSuccess });

  @override
  _AddMyMovieModalMState createState() => _AddMyMovieModalMState();
}

class _AddMyMovieModalMState extends State<AddMyMovieModalM> {

  File pickedImage;
  String watchTime;
  double rate;

  bool isLoading = false;
  bool isValidating = false;

  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _addMovieFormKey = GlobalKey<FormState>();
  final _scaffoldAddMovieKey = GlobalKey<ScaffoldState>();

  Future<void> _saveForm() async {
    FocusScope.of(context).unfocus();

    final validation = _addMovieFormKey.currentState.validate();

    // Image Validation
    if(pickedImage == null) {
      _scaffoldAddMovieKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please add image'),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        )
      );
      setState(() {
        isValidating = false;
      });
    } else {
      setState(() {
        isValidating = true;
      });
    }

    // WatchTime Validation
    if(watchTime == null) {
      _scaffoldAddMovieKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please select watch date'),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        )
      );
      setState(() {
        isValidating = false;
      });
    } else {
      setState(() {
        isValidating = true;
      });
    }

    // Rate Validation
    if(rate == null) {
      _scaffoldAddMovieKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please add rate'),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        )
      );
      setState(() {
        isValidating = false;
      });
    } else {
      setState(() {
        isValidating = true;
      });
    }

    // Title & Note Validation
    if(!isValidating){
      return ;
    }

    // If whole validation is passed, then isValidating will be ture
    // print(isValidating);

    setState(() {
      isLoading = true;
    });

    Provider.of<AddModel>(context, listen: false).submitAddMovie(
      pickedImage, watchTime, _titleController.text.trim(), _noteController.text.trim(), rate
    )
    .then((err) {
      if(err == null) { // Success
        setState(() {
          isLoading = false;
        });

        Navigator.of(context).pop();
        widget.addMovieSuccess();
        return ;
      }
      // Fail
      _scaffoldAddMovieKey.currentState.showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        )
      );
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
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
      return ;
    }

    // Real Device Path
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(_pickedImage.path);
    final savedImage = await _pickedImage.copy('${appDir.path}/$fileName');

    setState(() {
      pickedImage = savedImage;
    });
    
    print(pickedImage.path);
  }

  Future<void> _showDatePicker() async {
    DateTime newDateTime = await showRoundedDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime.now(),
      borderRadius: 16,
      theme: ThemeData.dark(),
      // imageHeader: AssetImage("assets/images/start_image.jpg"),
      description: "Select Watch Date",
      // fontFamily: 'Questrial',
    );

    if(newDateTime == null) {
      return ;
    }

    setState(() {
      watchTime = DateFormat.yMd().format(newDateTime);
    });
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldAddMovieKey,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () { FocusScope.of(context).unfocus(); },
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: screenSize.width * .15,
                    height: 5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.grey[500]
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: screenSize.width * .4,
                        height: screenSize.height * .2,
                        decoration: BoxDecoration(
                          color: Colors.grey[300]
                          // gradient: LinearGradient(
                          //   begin: Alignment.topRight,
                          //   end: Alignment.bottomLeft,
                          //   colors: [Colors.grey[400], Colors.grey[200]]
                          // ),
                        ),
                        child: pickedImage == null
                        ? Container()
                        : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Image.file(pickedImage, fit: BoxFit.cover)
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            FlatButton.icon(
                              onPressed: () { _onClickImagePicker('camera'); },
                              icon: Icon(Icons.camera_alt, color: Colors.black87),
                              label: Text(
                                'Camera',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87
                                )
                              )
                            ),
                            FlatButton.icon(
                              onPressed: () { _onClickImagePicker('gallery'); },
                              icon: Icon(Icons.photo_size_select_actual, color: Colors.black87),
                              label: Text(
                                'Gallery',
                                style: TextStyle(
                                  // fontFamily: 'Questrial',
                                  fontSize: 15,
                                  color: Colors.black87
                                )
                              )
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Divider(height: 3, color: Colors.black26),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: _showDatePicker,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: screenSize.height * .08,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1, color: Colors.black87)
                          // gradient: LinearGradient(
                          //   begin: Alignment.topRight,
                          //   end: Alignment.bottomLeft,
                          //   colors: [Colors.grey[400], Colors.grey[200]]
                          // ),
                      ),
                      child: Text(
                        watchTime == null
                        ? 'Select Watch Date'
                        : watchTime,
                        style: TextStyle(
                          color: Colors.black87,
                          // fontFamily: 'Questrial',
                          fontSize: 16
                        )
                      )
                    ),
                  ),
                  SizedBox(height: 15),
                  Divider(height: 3, color: Colors.black26),
                  SizedBox(height: 15),
                  Form(
                    key: _addMovieFormKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            cursorColor: Colors.black,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: false,
                            key: ValueKey('addMovieTitle'),
                            validator: (value) {
                              if(value.isEmpty) {
                                _scaffoldAddMovieKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text('Please enter title'),
                                    backgroundColor: Theme.of(context).errorColor,
                                    duration: const Duration(seconds: 2),
                                  )
                                );
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
                              hintText: 'Title',
                              hintStyle: TextStyle(color: Colors.black87),
                              border: InputBorder.none,
                            ),
                            controller: _titleController,
                          ),
                        ),
                        SizedBox(height: 15),
                        Divider(height: 3, color: Colors.black26),
                        SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          height: 100,
                          child: TextFormField(
                            maxLines: null, // Automatically add new lines
                            textAlignVertical: TextAlignVertical.center,
                            cursorColor: Colors.black,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: false,
                            key: ValueKey('addMovieNote'),
                            validator: (value) {
                              if(value.isEmpty) {
                                _scaffoldAddMovieKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text('Please enter notes'),
                                    backgroundColor: Theme.of(context).errorColor,
                                    duration: const Duration(seconds: 2),
                                  )
                                );
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
                              hintText: 'Notes',
                              hintStyle: TextStyle(color: Colors.black87),
                              border: InputBorder.none,
                            ),
                            controller: _noteController,
                          ),
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 15),
                  Divider(height: 3, color: Colors.black26),
                  SizedBox(height: 15),
                  RatingBar(
                    initialRating: 0,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return Icon(Icons.sentiment_very_dissatisfied, color: Colors.red);
                        case 1:
                          return Icon(Icons.sentiment_dissatisfied, color: Colors.orange);
                        case 2:
                          return Icon(Icons.sentiment_neutral, color: Colors.yellow);
                        case 3:
                          return Icon(Icons.sentiment_satisfied, color: Colors.green);
                        case 4:
                          return Icon(Icons.sentiment_very_satisfied, color: Colors.blue);
                      }
                    },
                    onRatingUpdate: (newRate) {
                      setState(() {
                        rate = newRate;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  Divider(height: 3, color: Colors.black26),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: _saveForm,
                    child: Container(
                      width: double.infinity,
                      height: screenSize.height * .08,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: HexColor('#f04c24'),
                          // gradient: LinearGradient(
                          //   begin: Alignment.topRight,
                          //   end: Alignment.bottomLeft,
                          //   colors: [Colors.grey[400], Colors.grey[200]]
                          // ),
                      ),
                      child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                      )
                      : Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Quicksand-Bold'
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25)
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}

class AddMyMovieModalT extends StatefulWidget {

  final Function addMovieSuccess;
  AddMyMovieModalT({ this.addMovieSuccess });

  @override
  _AddMyMovieModalTState createState() => _AddMyMovieModalTState();
}

class _AddMyMovieModalTState extends State<AddMyMovieModalT> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}