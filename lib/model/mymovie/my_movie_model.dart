import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

class MyMovieModel with ChangeNotifier {

  final _auth = FirebaseAuth.instance;
  final _store = Firestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<String> selectedMovieDelete(String documentId, String imageUrl) async {

    try {
      // Retrieve File Path by URL
      final fileUrl = Uri.decodeFull(path.basename(imageUrl)).replaceAll(new RegExp(r'(\?alt).*'), '');
      final currentUser = await _auth.currentUser();

      final ref = _storage.ref().child(fileUrl);
      // delete file in storage
      await ref.delete();

      // delete data in firestore db
      await _store.collection('movies').document(currentUser.uid).collection('movie_list').document(documentId).delete();
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

  Future<String> editMyMovieWithImageChange(
    String documentId,
    String previousImageUrl,
    File newMovieImage,
    String newMovieTitle,
    String newMovieNote,
    String newMovieWatchDate,
    double newMovieRate,
    Timestamp createdAt
  ) async {

    try {
      // Retrieve File Path by URL
      final fileUrl = Uri.decodeFull(path.basename(previousImageUrl)).replaceAll(new RegExp(r'(\?alt).*'), '');
      final currentUser = await _auth.currentUser();

      final refDelete = _storage.ref().child(fileUrl);
      // delete file in storage
      await refDelete.delete();

      // Add new file in storage
      final refAdd = _storage.ref().child('movies').child(currentUser.uid).child(newMovieImage.path);
      await refAdd.putFile(newMovieImage).onComplete;
      final url = await refAdd.getDownloadURL();

      // Update data in firestore db
      await _store.collection('movies').document(currentUser.uid).collection('movie_list').document(documentId).updateData({
        'id': documentId,
        'movie_image': url,
        'watch_date': newMovieWatchDate,
        'movie_title': newMovieTitle,
        'movie_note': newMovieNote,
        'movie_rate': newMovieRate,
        'created_at': createdAt,
        'edited_at': Timestamp.now()
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

  Future<String> editMyMovieWithoutImageChange(
    String documentId,
    String previousImageUrl,
    String newMovieTitle,
    String newMovieNote,
    String newMovieWatchDate,
    double newMovieRate,
    Timestamp createdAt
  ) async {

    try {
      final currentUser = await _auth.currentUser();

      // Update data in firestore db
      await _store.collection('movies').document(currentUser.uid).collection('movie_list').document(documentId).updateData({
        'id': documentId,
        'movie_image': previousImageUrl,
        'watch_date': newMovieWatchDate,
        'movie_title': newMovieTitle,
        'movie_note': newMovieNote,
        'movie_rate': newMovieRate,
        'created_at': createdAt,
        'edited_at': Timestamp.now()
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