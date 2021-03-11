import 'package:chat_app/ChatScreen.dart';
import 'package:chat_app/LogInScreen.dart';
import 'package:chat_app/RegistrationScreen.dart';
import 'package:chat_app/WelcomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(
            color: Colors.black87
          )
        )
      ),
      initialRoute: 'welcome',
      routes: {
        'welcome': (context) => WelcomeScreen(),
        'login': (context) => LogInScreen(),
        'register': (context) => RegistrationScreen(),
        'chat': (context) => ChatScreen()

      },
      home: WelcomeScreen(),
    );
  }
}

