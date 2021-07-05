import 'package:cloud_firestore/cloud_firestore.dart';

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

  final CollectionReference articleCollection =
      FirebaseFirestore.instance.collection('Articles');

  Future uploadData(String input, String dateTime) async {
    return await articleCollection.doc().set({
      'Input': input,
      'Date': dateTime,
    });
  }
}
