import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class AddModel with ChangeNotifier {

  final _auth = FirebaseAuth.instance;
  final _store = Firestore.instance;

  Future<String> submitAddMovie(File image, String date, String title, String note, double rate) async {

    try {
      final currentUser = await _auth.currentUser();

      final ref = FirebaseStorage.instance.ref().child('movies').child(currentUser.uid).child(image.path);
      await ref.putFile(image).onComplete;
      final url = await ref.getDownloadURL();

      await _store.collection('movies').document(currentUser.uid).collection('movie_list').add({
        'movie_image': url,
        'watch_date': date,
        'movie_title': title,
        'movie_note': note,
        'movie_rate': rate
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

}