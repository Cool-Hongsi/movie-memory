import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class AddModel with ChangeNotifier {

  List<DocumentSnapshot> myMovieList = [];

  final _auth = FirebaseAuth.instance;
  final _store = Firestore.instance;
  final _storage = FirebaseStorage.instance;
  
  Future<String> submitAddMovie(File image, String date, String title, String note, double rate) async {

    // print(image);
    // print(date);
    // print(title);
    // print(note);
    // print(rate);

    var stringToTimestamp = DateFormat('MMM d, yyyy').parse(date);

    try {
      final currentUser = await _auth.currentUser();

      final ref = _storage.ref().child('movies').child(currentUser.uid).child(image.path);
      await ref.putFile(image).onComplete;
      final url = await ref.getDownloadURL();

      await _store.collection('movies').document(currentUser.uid).collection('movie_list').add({
        'movie_image': url,
        'watch_date': date,
        'watch_date_timestamp': stringToTimestamp, // for filter
        'movie_title': title,
        'movie_note': note,
        'movie_rate': rate,
        'created_at': Timestamp.now()
      }).then((generatedDocument) {
         _store.collection('movies').document(currentUser.uid).collection('movie_list').document(generatedDocument.documentID).updateData({
           'id': generatedDocument.documentID
         });
      }).catchError((err) {
        print(err);
        return err;
      });
    } on PlatformException catch (err) {
      if(err.message != null) {
        return err.message;
      }
    } catch (err) {
      print(err);
      return err;
    }

    return null;
  }

  Future<String> getMyMovieList(String filterType) async {

    List<DocumentSnapshot> myMovieListSample = [];
    
    try {
      final currentUser = await _auth.currentUser();
      final data = await _store.collection('movies').document(currentUser.uid).collection('movie_list')
      .orderBy(filterType, descending: true).getDocuments();

      myMovieListSample = [...data.documents];

      myMovieList = [...myMovieListSample];

    } on PlatformException catch (err) {
      if(err.message != null) {
        return err.message;
      }
    } catch (err) {
      print(err);
      return err;
    }

    // notifyListeners();

    return null;
  }
}