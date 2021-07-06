import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messageboard_app/models/user.dart';
import 'package:messageboard_app/screens/home.dart';
import 'package:messageboard_app/screens/pages/chatlist.dart';
import 'package:messageboard_app/screens/wrapper.dart';
import 'package:messageboard_app/services/auth.dart';
import 'package:messageboard_app/services/database.dart';
import 'package:messageboard_app/shared/constants.dart';
import 'package:messageboard_app/widgets/message_tile.dart';
import 'package:provider/provider.dart';

class GameChatPage extends StatefulWidget {
  @override
  _GameChatPageState createState() => _GameChatPageState();
}

class _GameChatPageState extends State<GameChatPage> {
  final AuthService _auth = AuthService();

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance
  //           .collection('games')
  //           .orderBy('Date')
  //           .snapshots(),
  //       builder: (context, snapshot) {
  //         return snapshot.hasData
  //             ? ListView.builder(
  //                 itemCount: snapshot.data.documents.length,
  //                 itemBuilder: (context, index) {
  //                   return MessageTile(
  //                     message: snapshot.data.documents[index].data["message"],
  //                     sender: snapshot.data.documents[index].data["sender"],
  //                     sentByMe: widget.userName ==
  //                         snapshot.data.documents[index].data["sender"],
  //                   );
  //                 })
  //             : Container(
  //                 child: CircularProgressIndicator(),
  //               );
  //       },
  //     ),
  //   );
  // }

  // _sendMessage() {
  //   if (messageEditingController.text.isNotEmpty) {
  //     Map<String, dynamic> chatMessageMap = {
  //       "message": messageEditingController.text,
  //       "sender": widget.userName,
  //       'time': DateTime.now().millisecondsSinceEpoch,
  //     };

  //     DatabaseService().sendMessage(widget.groupId, chatMessageMap);

  //     setState(() {
  //       messageEditingController.text = "";
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   DatabaseService().getChats(widget.groupId).then((val) {
  //     // print(val);
  //     setState(() {
  //       _chats = val;
  //     });
  //   });
  // }
  String input = '';
  FirebaseAuth auth = FirebaseAuth.instance;

  User user = FirebaseAuth.instance.currentUser!;
  String username = '';

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance
    //   .collection('Users')
    //   .get()
    //   .then((QuerySnapshot querySnapshot) {
    //       querySnapshot.docs.forEach((doc) {
    //         if(doc["User"] == FirebaseAuth.instance.currentUser.){
    //           if(doc["role"] == 'admin' && isAdmin == false) {
    //             setState(() => isAdmin = true);
    //             getData();
    //           }
    //         }
    //       });
    //   });
    return Scaffold(
      backgroundColor: Color(0xFFb5e1eb),
      appBar: AppBar(
        title: Text('Games Group'),
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
      body: Container(
          child: Stack(children: <Widget>[
        // getUserName(user.uid),
        ArticleList(),
        Container(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                    onChanged: (value) {
                      input = value;
                    },
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Message')),
              ),
              SizedBox(width: 12.0),
              GestureDetector(
                onTap: () {
                  getUserName(user.uid);
                  _auth.post(username, input, DateTime.now().toString());
                },
                child: Container(
                  height: 45.0,
                  width: 45.0,
                  decoration: BoxDecoration(
                      color: Color(0xFF2a9d8f),
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(child: Icon(Icons.send, color: Colors.white)),
                ),
              )
            ],
          ),
        )
      ])),
    );
  }

  void getUserName(documentId) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    users.doc(documentId).get().then((DocumentSnapshot documentSnapshot) {
      setState(() => username = documentSnapshot.get('Full Name'));
    });
  }
}

void _errorPost(context) {
  showDialog(
    context: context,
    builder: (BuildContext bc) {
      return AlertDialog(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ALERT',
              style: TextStyle(
                  color: Color(0xFFe76f51),
                  fontWeight: FontWeight.w900,
                  fontSize: 30),
            ),
          ],
        ),
        content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Content Required',
                style: TextStyle(
                    color: Color(0xFFe76f51),
                    fontWeight: FontWeight.w400,
                    fontSize: 15),
              ),
              SizedBox(
                height: 15,
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80)),
                padding: EdgeInsets.all(8),
                minWidth: 180,
                color: Color(0xFF2a9d8f),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              )
            ]),
      );
    },
  );
}

// getUserName(documentId) {

//   CollectionReference users = FirebaseFirestore.instance.collection('Users');
//   users.doc(documentId).get().then((DocumentSnapshot documentSnapshot) {
//     return documentSnapshot.get('Username');
//   });
// }
// class GetUserName extends StatelessWidget {
//   final String documentId;

//   GetUserName(this.documentId);

//   @override
//   Widget build(BuildContext context) {
//     CollectionReference users = FirebaseFirestore.instance.collection('Users');

//     return FutureBuilder<DocumentSnapshot>(
//       future: users.doc(documentId).get(),
//       builder:
//           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text("Something went wrong");
//         }

//         if (snapshot.hasData && !snapshot.data!.exists) {
//           return Text("Document does not exist");
//         }

//         if (snapshot.connectionState == ConnectionState.done) {
//           Map<String, dynamic> data =
//               snapshot.data!.data() as Map<String, dynamic>;
//           return Text("${data['Full Name']}");
//         }

//         return Text("loading");
//       },
//     );
//   }
// }
