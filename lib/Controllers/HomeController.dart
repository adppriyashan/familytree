import 'package:firebase_database/firebase_database.dart';

class HomeController {
  DatabaseReference _databaseRef;

  HomeController() {
    _databaseRef = FirebaseDatabase.instance.reference();
  }

  DatabaseReference getCategoriesWithProducts() {
    return _databaseRef.child('categories').orderByValue().reference();
  }

  DatabaseReference getCategoriesFilteredProducts(String id) {
    return _databaseRef
        .child('categories')
        .child(id)
        .orderByValue()
        .reference();
  }
}
