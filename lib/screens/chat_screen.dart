import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String username = '';

  @override
  void initState() {
    super.initState();

    _getUserData();

    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.notification!.title);
      print(message.notification!.body);
      // print(message.notification.toString());
      // print(message.toString());
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message.notification!.title);
      print(message.notification!.body);
      // print(message.notification.toString());
      // print(message.toString());
      return;
    });

    fbm.subscribeToTopic('chat');
  }

  Future<void> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    setState(() {
      username = userData['username'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        actions: <Widget>[
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryColorLight,
              // color: Theme.of(context).colorScheme.primary,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.exit_to_app,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                value: 'logout',
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      // body: StreamBuilder<dynamic>(
      //   stream: FirebaseFirestore.instance
      //       .collection('chats/10v6cpKx3Hcc5sRoNGNa/messages')
      //       .snapshots(),
      //   builder: (ctx, streamSnapshot) {
      //     if (streamSnapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     final documents = streamSnapshot.data.docs;
      //     return ListView.builder(
      //       itemCount: documents.length,
      //       itemBuilder: (context, index) => Container(
      //         padding: const EdgeInsets.all(8),
      //         child: Text(documents[index]['text']),
      //       ),
      //     );
      //   },
      // ),
      body: Container(
        child: Column(children: const <Widget>[
          Expanded(
            child: Messages(),
          ),
          NewMessage(),
        ]),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     // FirebaseFirestore.instance
      //     //     .collection('chats/10v6cpKx3Hcc5sRoNGNa/messages')
      //     //     .snapshots()
      //     //     .listen((event) {
      //     //   print('1 : ${event.docs[0]['text']}');
      //     //   event.docs.forEach((element) {
      //     //     print('2 : ${element['text']}');
      //     //   });
      //     // });
      //     FirebaseFirestore.instance
      //         .collection('chats/10v6cpKx3Hcc5sRoNGNa/messages')
      //         .add({'text': 'This was added by clicking the button!'});
      //   },
      // ),
    );
  }
}
