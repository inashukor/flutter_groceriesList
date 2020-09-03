import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:listina/widgets/custom_dialog.dart';

class FirstView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//means it only usable inside the widget
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        color: Colors.teal[100],
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height:150,

                        child: Image.asset("assets/logoo1.png"),),

                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          "Welcome",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: _height * 0.10,
                ),
                AutoSizeText(
                  "Let's start planning your Shopping trip",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
                SizedBox(
                  height: _height * 0.10,
                ),
                RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 15.0, left: 30.0, right: 30.0),
                    child: Text(
                      "Get Started",
                      style: TextStyle(color: Colors.teal, fontSize: 28.0),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (buildContext) => CustomDialog(
                        title: "Would you like to create a free account?",
                        description:
                            "with an account allowing you to create your personal Shoplist",
                        primaryButtonText: "Create My Account",
                        primaryButtonRoute: "/signUp",
//                        secondaryButtonText: "Maybe Later",
//                        secondaryButtonRoute: "/anonymousSignIn",
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: _height * 0.05,
                ),
                FlatButton(
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.black, fontSize: 25.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/signIn');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
