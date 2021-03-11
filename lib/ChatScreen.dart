import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Constants.dart';

final _fireStore = Firestore.instance;
User logInUser;


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText;

  Future<void> getCurrentUser()
  async {
    try{
      final user = await _auth.currentUser;
      if (user != null)
        {
          logInUser = user;
          print(logInUser.email);
        }
    }catch(e)
    {
      print(e.toString());
    }
  }

  void getData() async
  {
    final data = await _fireStore.collection("message").getDocuments();
    for (var abc in data.documents)
      {
        print(abc.data());
      }
  }

  void getDataAnother() async
  {
    await for(var snapshot in _fireStore.collection("message").snapshots())
      {
        for(var data in snapshot.documents.reversed)
          {
            print(data.data());
          }
      }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    // getData();
    // getDataAnother();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                // _auth.signOut();
                // Navigator.pop(context);
                // getData();
                // getData();
                getDataAnother();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      style: TextStyle(
                        color: Colors.black
                      ),
                      onChanged: (value) {
                        messageText = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      _fireStore.collection("message").add({
                        "sender" : logInUser.email,
                        "message": messageText,
                        'time': FieldValue.serverTimestamp()
                      });
                      messageTextController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatefulWidget {

  @override
  _MessageStreamState createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection("message").orderBy('time', descending: false).snapshots(),
        // ignore: missing_return
        builder: (context, snapshot)
        // ignore: missing_return
        {
          if (!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ),
            );
          }
          // CollectionReference collectionReference = Firestore.instance.collection("Events");
          // Query collectionRef = Firestore.instance.collection("Events").orderBy('field');

            final message = snapshot.data.documents.reversed;
            List<MessageBubble> messageWigets = [];
            for(var msg in message)
            {
              final msgText = msg.data();
              print(msgText);
              final msgSender = msgText["sender"];
              final msgtext = msgText["message"];

              final currentUser = logInUser.email;

              final msgWidgets = MessageBubble(
                msg: msgtext,
                sender: msgSender,
                isMe: currentUser == msgSender,
              );
              messageWigets.add(msgWidgets);
            }
            return Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                children: messageWigets,
              ),
            );

        }
    );
  }
}



class MessageBubble extends StatelessWidget {

  final String msg;
  final String sender;
  final bool isMe;

  MessageBubble({this.msg, this.sender, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey
            ),
          ),
          Material(
            borderRadius:  isMe ? BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30),     bottomRight: Radius.circular(30)) : BorderRadius.only(topRight: Radius.circular(30),bottomLeft: Radius.circular(30),     bottomRight: Radius.circular(30)),
            elevation: 5.0,
              color: isMe ? Colors.blue : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(msg,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}
