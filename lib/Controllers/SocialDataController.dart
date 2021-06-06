import 'package:familytree/Models/Utils.dart';
import 'package:firebase_database/firebase_database.dart';

class SocialDataController {
  DatabaseReference _databaseRef;

  SocialDataController() {
    _databaseRef = FirebaseDatabase.instance.reference();
  }

  Future<DataSnapshot> getData() async {
    return await _databaseRef
        .child('users')
        .child(Utils.profileUser.uid)
        .child('social')
        .reference()
        .once();
  }

  Future<void> save(data) async {
    DatabaseReference _ref = _databaseRef
        .child('users')
        .child(Utils.profileUser.uid)
        .child('social')
        .reference()
        .push();

    data['id'] = _ref.key;

    await _ref.set(data);
  }

  Future<void> edit(id, data) async {
    await _databaseRef
        .child('users')
        .child(Utils.profileUser.uid)
        .child('social')
        .child(id)
        .reference()
        .update(data);
  }

  Future<void> delete(id) async {
    await _databaseRef
        .child('users')
        .child(Utils.profileUser.uid)
        .child('social')
        .child(id)
        .reference()
        .remove();
  }
}
