import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthModel with ChangeNotifier {

  final _auth = FirebaseAuth.instance;

  /* Login */
  Future<String> authLogin(String email, String password) async {
    try{
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
  Future<String> authSignUp(String email, String password, String username) async {
    try{
      // Add Authentication
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // Add Firestore DB with addition information
      await Firestore.instance.collection('users').document(_authResult.user.uid).setData({
        'email': email,
        'username': username
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
    try{
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

    _googleSignIn.signOut(); // Whenever trying to login with google, have to check the email

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if(googleUser == null) return ; // When user click outside

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try{
      // Automatically Sign up
      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      
      await Firestore.instance.collection('users').document(user.uid).setData({
        'email': user.email,
        'username': user.displayName
      });
    } catch(err) {
      print(err);
    }
  }

}