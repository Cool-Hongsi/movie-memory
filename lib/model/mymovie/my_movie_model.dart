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

}