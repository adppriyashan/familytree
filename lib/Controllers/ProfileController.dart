import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:familytree/Controllers/AuthController.dart';
import 'package:familytree/Models/Utils.dart';

class ProfileController {
  DatabaseReference _databaseRef;
  AuthController _authController;
  FirebaseStorage _storage;

  ProfileController() {
    _databaseRef = FirebaseDatabase.instance.reference();
    _authController = AuthController();
    _storage = FirebaseStorage.instance;
  }

  Future<void> updateProfile(data) async {
    await _databaseRef.child('users').child(Utils.profileUser.uid).update(data);
    Utils.profileUser = await _authController.getUserData();
  }

  Future<void> uploadImage(Uint8List image) async {
    _storage.ref(Utils.profileUser.uid + '.jpg').putData(image);
  }
}
