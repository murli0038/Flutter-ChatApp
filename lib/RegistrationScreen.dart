import 'package:chat_app/Constants.dart';
import 'package:chat_app/WelcomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final _fireStore = Firestore.instance;
User logInUser;


class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;

  String email;
  String password;
  bool spinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: spinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('assets/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black
                  ),
                  onChanged: (value) {
                    //Do something with the user input.
                    email = value;
                  },
                  decoration: kTextFiledDecoration.copyWith(hintText: "Enter your Mail...")
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    //Do something with the user input.
                    password = value;
                  },
                  style: TextStyle(
                    color: Colors.black
                  ),
                  decoration: kTextFiledDecoration.copyWith(hintText: "Enter your Password...")
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: "Register",
                  colour: Colors.blue,
                  onTapped: () async {
                    setState(() {
                      spinner = true;
                    });
                    //code
                    try{
                      final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                      if (newUser != null)
                        {
                          _fireStore.collection("Users").add({
                            "user": email
                          });
                          Navigator.pushNamed(context, "chat");
                        }
                      setState(() {
                        spinner = false;
                      });
                    }
                    catch(e)
                    {
                      print(e.toString());
                    }

                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
