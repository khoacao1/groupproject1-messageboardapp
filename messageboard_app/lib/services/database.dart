import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messageboard_app/screens/pages/gamechat.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  Future updateUserData(String fname, String lname, String date) async {
    return await userCollection.doc(uid).set({
      'Full Name': fname + ' ' + lname,
      'First Name': fname,
      'Last Name': lname,
      'Register Date': date,
      'User Admin Role': false,
    });
  }
}

class DataPost {
  DataPost({dynamic});

  final CollectionReference gamesCollection =
      FirebaseFirestore.instance.collection('games');

  Future uploadData(String username, String input, String dateTime) async {
    return await gamesCollection.doc().set({
      'Username': username,
      'Input': input,
      'Date': dateTime,
    });
  }
}
