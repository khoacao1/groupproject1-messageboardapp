import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messageboard_app/screens/home.dart';
import 'package:messageboard_app/screens/wrapper.dart';
import 'package:messageboard_app/services/auth.dart';
import 'package:messageboard_app/services/database.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  late String fname;
  late String lname;

  getUid() {
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    return uid;
  }

  getFirstName() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(getUid())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        fname = documentSnapshot.get('First Name');
      }
    });
  }

  getLastName() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(getUid())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        lname = documentSnapshot.get('Last Name');
      }
    });
  }

  updateProfileData() {
    var dbs = new DatabaseService(uid: getUid());
    setState(() {
      if (fnameController.text == "") {
        fnameController.text = fname;
      }
      if (lnameController.text == "") {
        lnameController.text = lname;
      }
      dbs.updateName(fnameController.text, lnameController.text);
      Navigator.pop(context, [fnameController.text, lnameController.text]);
    });
  }

  Column buildFirstName() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "First Name",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextField(
            controller: fnameController,
          ),
        ]);
  }

  Column buildLastName() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Last Name",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextField(
            controller: lnameController,
          ),
        ]);
  }

  Widget cancelButton() {
    getFirstName();
    getLastName();
    return FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context, [fname, lname]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFb5e1eb),
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF2a9d8f),
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            CustomListTile(Icons.backpack, 'Message Boards', () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Wrapper()));
            }),
            CustomListTile(Icons.person, 'Profile', () {}),
            CustomListTile(Icons.logout, 'Log Out', () async {
              await _auth.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Wrapper()));
            }),
          ],
        ),
      ),
      body: ListView(children: <Widget>[
        Container(
            child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  buildFirstName(),
                  buildLastName(),
                ],
              ),
            ),
            RaisedButton(
                onPressed: () {
                  updateProfileData();
                },
                child: Text("Update Profile")),
            cancelButton(),
          ],
        ))
      ]),
    );
  }
}
