import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../model/mymovie/my_movie_model.dart';
import '../../services/hex_color.dart';
import '../../model/appconfig/app_locale.dart';

class MyMovieDetailScreenM extends StatefulWidget {
  
  final Map argMap;
  MyMovieDetailScreenM({ this.argMap });

  @override
  _MyMovieDetailScreenMState createState() => _MyMovieDetailScreenMState();
}

class _MyMovieDetailScreenMState extends State<MyMovieDetailScreenM> {

  String movieTitle;
  String movieNote;
  File movieImage;
  String movieWatchDate;
  double movieRate;

  bool isLoading = false;
  bool editSwitch = false;

  final _scaffoldMyMovielDetailKey = GlobalKey<ScaffoldState>();

  Future<void> _onClickUpdate(Map argMap) async {
    String movieImageOriginal;

    // Image Validation
    if(movieImage == null) { movieImageOriginal = argMap['movie_image']; }

    // Title Validation
    if(movieTitle == null) { movieTitle = argMap['movie_title']; }
    else if(movieTitle != null && movieTitle.isEmpty) {
      _scaffoldMyMovielDetailKey.currentState.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('enterTitleErrorMsg')),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        )
      );
    }

    // Note Validation
    if(movieNote == null) { movieNote = argMap['movie_note']; }
    else if(movieNote != null && movieNote.isEmpty) {
      _scaffoldMyMovielDetailKey.currentState.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('enterNoteErrorMsg')),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        )
      );
    }

    // Watch Date Validation
    if(movieWatchDate == null) { movieWatchDate = argMap['watch_date']; }

    // Rate Validation
    if(movieRate == null) { movieRate = argMap['movie_rate']; }
    else if(movieRate == 0.0) {
      _scaffoldMyMovielDetailKey.currentState.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('enterRateErrorMsg')),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        )
      );
    }

    if(movieTitle.isNotEmpty && movieNote.isNotEmpty && movieWatchDate != null && movieRate != 0.0){ // validation success

      setState(() {
        isLoading = true;
      });

      if(movieImageOriginal == null) { // Changed Image File
        Provider.of<MyMovieModel>(context, listen: false).editMyMovieWithImageChange(
          argMap['id'], argMap['movie_image'], movieImage, movieTitle, movieNote, movieWatchDate, movieRate, argMap['created_at']
        )
        .then((err) {
          if(err == null) { // Success
          setState(() {
            isLoading = false;
          });

          Navigator.of(context).pop();
          widget.argMap['editMovieSuccess'](); // should put () to call parent function
          return ;
        }
        // Fail
        _scaffoldMyMovielDetailKey.currentState.showSnackBar(
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
      } else { // No Changed Image File
        Provider.of<MyMovieModel>(context, listen: false).editMyMovieWithoutImageChange(
          argMap['id'], argMap['movie_image'], movieTitle, movieNote, movieWatchDate, movieRate, argMap['created_at']
        )
        .then((err) {
          if(err == null) { // Success
          setState(() {
            isLoading = false;
          });

          Navigator.of(context).pop();
          widget.argMap['editMovieSuccess'](); // should put () to call parent function
          return ;
        }
        // Fail
        _scaffoldMyMovielDetailKey.currentState.showSnackBar(
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
    }
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
      movieImage = savedImage;
    });
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
      // description: "Select Watch Date",
      // fontFamily: 'Questrial',
    );

    if(newDateTime == null) {
      return ;
    }

    setState(() {
      movieWatchDate = DateFormat.yMMMd().format(newDateTime);
    });
  }

  Widget getRateIcon(double rate) {
    String rateString = rate.toString();

    switch(rateString){
      case '1.0': return Icon(Icons.sentiment_very_dissatisfied, color: Colors.red, size: 40);
      case '2.0': return Icon(Icons.sentiment_dissatisfied, color: Colors.orange, size: 40);
      case '3.0': return Icon(Icons.sentiment_neutral, color: Colors.yellow, size: 40);
      case '4.0': return Icon(Icons.sentiment_satisfied, color: Colors.green, size: 40);
      case '5.0': return Icon(Icons.sentiment_very_satisfied, color: Colors.blue, size: 40);
      default: return null;
    }
  }

  Future<void> onClickShare(String title, String date, String note, double rate) async {
    final RenderBox box = context.findRenderObject();
    Share.share(
      'Movie Title: $title\n\nMovie Rate: $rate\nWatch Date: $date\n\n$note', // content
      // subject: '$title', // title
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
    );
  }

  @override
  Widget build(BuildContext context) {

    // print(widget.argMap['selectedDocument']);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldMyMovielDetailKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
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
                // height: screenSize.height * .06,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                padding: EdgeInsets.only(left: screenSize.width * .05, right: screenSize.width * .05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () { Navigator.of(context).pop(); },
                          child: Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.black87,
                            size: 32,
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    editSwitch = !editSwitch;
                                  });
                                  if(editSwitch){
                                    _scaffoldMyMovielDetailKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text(AppLocalizations.of(context).translate('selectAreaToChange')),
                                        backgroundColor: Colors.green[700],
                                        duration: const Duration(seconds: 2),
                                      )
                                    );
                                  }
                                },
                                child: Icon(
                                  Icons.create,
                                  color: editSwitch ? HexColor('#d90429') : Colors.black87,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () { 
                                  onClickShare(
                                    widget.argMap['selectedDocument']['movie_title'],
                                    widget.argMap['selectedDocument']['watch_date'],
                                    widget.argMap['selectedDocument']['movie_note'],
                                    widget.argMap['selectedDocument']['movie_rate']
                                  );
                                },
                                child: Icon(
                                  Icons.share,
                                  color: Colors.black87,
                                  size: 23,
                                ),
                              ),
                            ],
                          )
                        )
                      ],
                    )
                  ],
                )
              ),
              Container(
                width: double.infinity,
                height: screenSize.height * .46,
                margin: EdgeInsets.only(top: 50),
                child: editSwitch
                ? Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: screenSize.height * .46,
                      child: Opacity(
                        opacity: .2,
                        child: movieImage != null
                        ? Image.file(movieImage, fit: BoxFit.cover)
                        : Image.network(widget.argMap['selectedDocument']['movie_image'], fit: BoxFit.cover),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: screenSize.height * .11),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () { _onClickImagePicker('camera'); },
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.black87,
                                  size: 38
                                ),
                              ),
                              GestureDetector(
                                onTap: () { _onClickImagePicker('gallery'); },
                                child: Icon(
                                  Icons.photo_size_select_actual,
                                  color: Colors.black87,
                                  size: 36
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
                : movieImage != null
                  ? Image.file(movieImage, fit: BoxFit.cover)
                  : Image.network(widget.argMap['selectedDocument']['movie_image'], fit: BoxFit.cover),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: screenSize.height * .65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                    color: Colors.white
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            readOnly: editSwitch ? false : true,
                            maxLines: null,
                            textAlignVertical: TextAlignVertical.center,
                            cursorColor: Colors.black,
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'Quicksand-Bold',
                              fontSize: 24,
                            ),
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: false,
                            key: ValueKey('editMovieTitle'),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            /* initialValue == null || controller == null': is not true (Error -> Can not use initialValue & controller simultaneously) */
                            initialValue: widget.argMap['selectedDocument']['movie_title'],
                            onChanged: (value) {
                              movieTitle = value;
                            },
                          ),
                          if(editSwitch)
                          GestureDetector(
                            onTap: _showDatePicker,
                            child: Text(
                              movieWatchDate != null
                              ? movieWatchDate
                              : widget.argMap['selectedDocument']['watch_date'],
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                          if(!editSwitch)
                          Text(
                            movieWatchDate != null
                            ? movieWatchDate
                            : widget.argMap['selectedDocument']['watch_date'],
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            readOnly: editSwitch ? false : true,
                            maxLines: null,
                            textAlignVertical: TextAlignVertical.center,
                            cursorColor: Colors.black,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                            ),
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: false,
                            key: ValueKey('editMovieNote'),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            /* initialValue == null || controller == null': is not true (Error -> Can not use initialValue & controller simultaneously) */
                            initialValue: widget.argMap['selectedDocument']['movie_note'],
                            onChanged: (value) {
                              movieNote = value;
                            },
                          ),
                          SizedBox(height: 20),
                          if(editSwitch)
                          RatingBar(
                            initialRating: movieRate != null
                            ? movieRate
                            : widget.argMap['selectedDocument']['movie_rate'],
                            itemCount: 5,
                            itemPadding: EdgeInsets.only(right: 3.0),
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
                                movieRate = newRate;
                              });
                            },
                          ),
                          if(!editSwitch)
                          getRateIcon(movieRate != null ? movieRate : widget.argMap['selectedDocument']['movie_rate']),
                          SizedBox(height: editSwitch ? 50 : 35)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if(editSwitch)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () { _onClickUpdate(widget.argMap['selectedDocument']); },
                  child: Container(
                    alignment: Alignment.center,
                    width: screenSize.width * 1,
                    height: 43,
                    decoration: BoxDecoration(
                      color: HexColor('#d90429'),
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
                      AppLocalizations.of(context).translate('updateText'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Quicksand-Bold'
                      ),
                    )
                  ),
                )
              )
            ],
          ),
        ),
      )
    );
  }
}

class MyMovieDetailScreenT extends StatefulWidget {

  final Map argMap;
  MyMovieDetailScreenT({ this.argMap });

  @override
  _MyMovieDetailScreenTState createState() => _MyMovieDetailScreenTState();
}

class _MyMovieDetailScreenTState extends State<MyMovieDetailScreenT> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}