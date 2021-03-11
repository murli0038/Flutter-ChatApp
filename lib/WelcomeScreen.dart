import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>  with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      // upperBound: 60,
      vsync: this,
    );

    // animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);

    controller.forward();
    controller.addListener(() {
      setState(() {});
      // print(animation.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('assets/logo.png'),
                    height: 60,
                  ),
                ),
                // TypewriterAnimatedTextKit(
                //   displayFullTextOnTap: true,
                //   speed: Duration(milliseconds: 500),
                //   text: ["Ebrious Chat"],
                //   textStyle: TextStyle(
                //     fontSize: 35.0,
                //     fontWeight: FontWeight.w900,
                //   ),
                // ),


                // SizedBox(
                //   width: 250.0,
                //   child: ScaleAnimatedTextKit(
                //       onTap: () {
                //         print("Tap Event");
                //       },
                //       text: [
                //         "Ebrious",
                //         "Chat",
                //       ],
                //       textStyle: TextStyle(
                //           fontSize: 70.0,
                //           fontFamily: "Horizon"
                //       ),
                //       textAlign: TextAlign.center,
                //       alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                //   ),
                // )
                SizedBox(
                  width: 250.0,
                  child: TextLiquidFill(
                    text: 'EBRIOUS CHAT',
                    waveColor: Colors.black,
                    waveDuration: Duration(seconds: 1),
                    boxBackgroundColor: Colors.white,
                    textStyle: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w900,
                    ),
                    boxHeight: 100.0,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: "Login",
              colour: Colors.redAccent,
              onTapped: () {
                Navigator.pushNamed(context, 'login');
              },
            ),
            RoundedButton(
              title: "Register",
              colour: Colors.yellow[500],
              onTapped: () {
                Navigator.pushNamed(context, 'register');
              },
            )
          ],
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {

  final String title;
  final Color colour;
  final Function onTapped;

  RoundedButton({this.colour, this.onTapped, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onTapped,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}
