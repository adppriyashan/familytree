import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:familytree/Models/User.dart';
import 'package:familytree/Models/Utils.dart';
import 'package:familytree/Views/Login.dart';

class AuthController {
  static FirebaseAuth _auth;
  DatabaseReference _databaseRef;
  GoogleSignIn _googleSignin;

  AuthController() {
    _auth = FirebaseAuth.instance;
    _databaseRef = FirebaseDatabase.instance.reference();
    _googleSignin = GoogleSignIn();
  }

  Future<bool> checkAuth() async {
    if (_auth.currentUser == null) {
      return false;
    } else {
      Utils.profileUser = await getUserData();
      return true;
    }
  }

  Future<bool> doRegistration(data) async {
    bool check = true;

    await _auth
        .createUserWithEmailAndPassword(
      email: data['email'],
      password: data['password'],
    )
        .then((value) async {
      await _databaseRef.child('users').child(value.user.uid).set({
        'name': data['name'],
        'mobile': data['mobile'],
      });

      Utils.showToast('Successfully Registered. Please Login Now.');
    }).catchError((e) {
      check = false;
      Utils.showToast(e.toString());
    });

    return check;
  }

  Future<bool> doLogin(data) async {
    bool check = true;

    await _auth
        .signInWithEmailAndPassword(
      email: data['email'],
      password: data['password'],
    )
        .catchError((e) {
      check = false;
      Utils.showToast(e.toString());
    }).then((value) async {
      Utils.profileUser = await getUserData();
    });

    return check;
  }

  Future<String> signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignin.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      Utils.profileUser = await getUserData();

      return '$user';
    }

    return null;
  }

  Future<void> logout(context) async {
    if (_auth.currentUser == null) {
      await _googleSignin.signOut();
    } else {
      await _auth.signOut();
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => Login()));
  }

  Future<ProfileUser> getUserData() async {
    ProfileUser user;
    if (_auth.currentUser != null) {
      print(_auth.currentUser.uid);

      await _databaseRef
          .child('users')
          .child(_auth.currentUser.uid)
          .once()
          .then((value) => user = ProfileUser(
              name: value.value['name'],
              email: _auth.currentUser.email,
              mobile: value.value['mobile'],
              img: value.value['img'],
              uid: _auth.currentUser.uid));
    } else {
      user = ProfileUser(
          name: _googleSignin.currentUser.displayName,
          email: _googleSignin.currentUser.email,
          mobile: '-------',
          uid: _googleSignin.currentUser.id);
    }

    return user;
  }
}
