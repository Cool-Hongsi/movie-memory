import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart' as path;

class AuthModel with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _store = Firestore.instance;
  final _storage = FirebaseStorage.instance;

  /* Login */
  Future<String> authLogin(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on PlatformException catch (err) {
      return err.message;
    } catch (err) {
      print(err);
      return err;
    }
  }

  /* Sign Up */
  Future<String> authSignUp(
      String email, String password, String username) async {
    try {
      // Add Authentication
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // Add Firestore DB with addition information
      await _store.collection('users').document(_authResult.user.uid).setData({
        'email': email,
        'username': username,
        'created_at': Timestamp.now(),
        'sign_in_with_google': false,
        'device': Platform.isAndroid ? 'Android' : 'IOS'
      });
      return null;
    } on PlatformException catch (err) {
      return err.message;
    } catch (err) {
      print(err);
      return err;
    }
  }

  /* Forgot Password */
  Future<String> authForgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on PlatformException catch (err) {
      return err.message;
    } catch (err) {
      print(err);
      return err;
    }
  }

  /* Google Sign In */
  Future<void> authGoogleSignIn() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    _googleSignIn
        .signOut(); // Whenever trying to login with google, have to check the email

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return; // When user click outside

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      // Automatically Sign up
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;

      var docRef = _store.collection('users').document(user.uid);
      docRef.get().then((data) {
        if (data.exists) {
          // Aleady Exist
        } else {
          // If it is first time to sign in by google
          _store.collection('users').document(user.uid).setData({
            'email': user.email,
            'username': user.displayName == null ? 'No Name' : user.displayName,
            'created_at': Timestamp.now(),
            'sign_in_with_google': true,
            'idToken': googleAuth.idToken,
            'accessToken': googleAuth.accessToken,
            'device': Platform.isAndroid ? 'Android' : 'IOS'
          });
        }
      });
    } catch (err) {
      print(err);
    }
  }

  /* Get Current User Data */
  Future<dynamic> authGetCurrentUserData() async {
    try {
      final currentUserFirebaseData = await _auth.currentUser();
      DocumentSnapshot currentUser = await _store
          .collection('users')
          .document(currentUserFirebaseData.uid)
          .get();
      return currentUser.data; // map
    } on PlatformException catch (err) {
      if (err != null) {
        return err.message; // string
      }
    } catch (err) {
      print(err);
      return err; // string
    }
  }

  /* Edit Profie */
  Future<String> authProfileEdit(File pickedImage, String userName) async {
    final currentUser = await _auth.currentUser();
    DocumentSnapshot currentUserSnapShot =
        await _store.collection('users').document(currentUser.uid).get();

    if (pickedImage != null && userName == null) {
      // Only Edit Image
      try {
        // Check whether it has already user_image url
        if (currentUserSnapShot.data['user_image'] != null) {
          // image already has
          final fileUrl = Uri.decodeFull(
                  path.basename(currentUserSnapShot.data['user_image']))
              .replaceAll(new RegExp(r'(\?alt).*'), '');
          final refDelete = _storage.ref().child(fileUrl);
          await refDelete.delete();

          final refAdd = _storage
              .ref()
              .child('users')
              .child(currentUser.uid)
              .child(pickedImage.path);
          await refAdd.putFile(pickedImage).onComplete;
          final url = await refAdd.getDownloadURL();

          await _store
              .collection('users')
              .document(currentUser.uid)
              .updateData({'edited_at': Timestamp.now(), 'user_image': url});
        } else {
          // image don't have
          final refAdd = _storage
              .ref()
              .child('users')
              .child(currentUser.uid)
              .child(pickedImage.path);
          await refAdd.putFile(pickedImage).onComplete;
          final url = await refAdd.getDownloadURL();

          await _store
              .collection('users')
              .document(currentUser.uid)
              .updateData({'edited_at': Timestamp.now(), 'user_image': url});
        }
        return null;
      } on PlatformException catch (err) {
        if (err != null) {
          return err.message;
        }
      } catch (err) {
        print(err);
        return err;
      }
    } else if (pickedImage == null && userName != null) {
      // Only Edit Username
      try {
        await _store
            .collection('users')
            .document(currentUser.uid)
            .updateData({'edited_at': Timestamp.now(), 'username': userName});

        return null;
      } on PlatformException catch (err) {
        if (err != null) {
          return err.message;
        }
      } catch (err) {
        print(err);
        return err;
      }
    } else if (pickedImage != null && userName != null) {
      // Edit Both Image and Username
      try {
        // Check whether it has already user_image url
        if (currentUserSnapShot.data['user_image'] != null) {
          // image already has
          final fileUrl = Uri.decodeFull(
                  path.basename(currentUserSnapShot.data['user_image']))
              .replaceAll(new RegExp(r'(\?alt).*'), '');
          final refDelete = _storage.ref().child(fileUrl);
          await refDelete.delete();

          final refAdd = _storage
              .ref()
              .child('users')
              .child(currentUser.uid)
              .child(pickedImage.path);
          await refAdd.putFile(pickedImage).onComplete;
          final url = await refAdd.getDownloadURL();

          await _store
              .collection('users')
              .document(currentUser.uid)
              .updateData({
            'edited_at': Timestamp.now(),
            'user_image': url,
            'username': userName
          });
        } else {
          // image don't have
          final refAdd = _storage
              .ref()
              .child('users')
              .child(currentUser.uid)
              .child(pickedImage.path);
          await refAdd.putFile(pickedImage).onComplete;
          final url = await refAdd.getDownloadURL();

          await _store
              .collection('users')
              .document(currentUser.uid)
              .updateData({
            'edited_at': Timestamp.now(),
            'user_image': url,
            'username': userName
          });
        }
        return null;
      } on PlatformException catch (err) {
        if (err != null) {
          return err.message;
        }
      } catch (err) {
        print(err);
        return err;
      }
    }

    return null;
  }

  /* Number of My Movie */
  Future<int> numberOfMyMovie() async {
    final currentUser = await _auth.currentUser();
    QuerySnapshot myMovieList = await _store
        .collection('movies')
        .document(currentUser.uid)
        .collection('movie_list')
        .getDocuments();
    List<DocumentSnapshot> myMovieDocs = myMovieList.documents;
    return myMovieDocs.length;
  }

  /* Sign Out */
  Future<void> authSignOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  /* Change Password */
  Future<String> changePassword() async {
    try {
      final currentUser = await _auth.currentUser();

      await _auth.sendPasswordResetEmail(email: currentUser.email);
    } on PlatformException catch (err) {
      if (err.message != null) {
        return err.message;
      }
    } catch (err) {
      print(err);
      return err;
    }

    return null;
  }

  /* Delete Account */
  Future<String> deleteAccount(String userPassword, String feedback) async {
    final currentUser = await _auth.currentUser();
    var credential;
    bool signInType;

    try {
      // Store feedback
      await _store.collection('feedbacks').document(currentUser.uid).setData({
        "deleted_at": Timestamp.now(),
        "email": currentUser.email,
        "feedback": feedback == '' ? 'Not leave feedback' : feedback
      });

      await _store
          .collection('users')
          .document(currentUser.uid)
          .get()
          .then((userData) {
        signInType = userData.data['sign_in_with_google'];

        if (userData.data['user_image'] != null) {
          // Exist profile image in storage
          final fileUrl =
              Uri.decodeFull(path.basename(userData.data['user_image']))
                  .replaceAll(new RegExp(r'(\?alt).*'), '');
          final refDelete = _storage.ref().child(fileUrl);
          // delete file in storage
          refDelete.delete();
        }
      });

      // To delete account, need to reauthenticate (Also need to check google sign in or general sign in)
      if (signInType) {
        // google sign in
        await _store
            .collection('users')
            .document(currentUser.uid)
            .get()
            .then((userData) {
          credential = GoogleAuthProvider.getCredential(
              idToken: userData.data['idToken'],
              accessToken: userData.data['accessToken']);
        });
      } else {
        // general sign in
        credential = EmailAuthProvider.getCredential(
            email: currentUser.email, password: userPassword);
      }

      await currentUser.reauthenticateWithCredential(credential);

      // Deleting a " directory " in firebase storage is not possible in firebase (Limitation).
      QuerySnapshot myMovieList = await _store
          .collection('movies')
          .document(currentUser.uid)
          .collection('movie_list')
          .getDocuments();
      List<DocumentSnapshot> myMovieDocs = myMovieList.documents;

      if (myMovieDocs.length == 0) {
        // there is no my movie list (0)
        // empty for storage and firestore
        await _store.collection('users').document(currentUser.uid).delete();
        await currentUser.delete();
      } else if (myMovieDocs.length > 0) {
        for (var i = 0; i < myMovieDocs.length; i++) {
          // Retrieve File Path by URL
          final fileUrl =
              Uri.decodeFull(path.basename(myMovieDocs[i].data['movie_image']))
                  .replaceAll(new RegExp(r'(\?alt).*'), '');
          final refDelete = _storage.ref().child(fileUrl);
          // delete file in storage
          await refDelete.delete();
          // delete FireStore
          await _store
              .collection('movies')
              .document(currentUser.uid)
              .collection('movie_list')
              .document(myMovieDocs[i].data['id'])
              .delete();
        }
        // Once finishing above for loop, if there is no more file or document in storage or firestore, then the directory or document also will be deleted automatically
        await _store.collection('users').document(currentUser.uid).delete();
        await currentUser.delete();
      }
    } on PlatformException catch (err) {
      if (err.message != null) {
        return err.message;
      }
    } catch (err) {
      print(err);
      return "There is an error occured in deleting account. Please try again later";
      // return err;
    }

    return null;
  }
}
