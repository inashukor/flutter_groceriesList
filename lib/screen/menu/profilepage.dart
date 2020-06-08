import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mecommerce/custom/prefProfile.dart';
import 'package:mecommerce/screen/login.dart';
import 'package:mecommerce/screen/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

///////////////////////////////get pref///////////////
  bool login = false;
  String name, email, phone;

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      login = pref.getBool(Pref.login) ?? false;
      name = pref.getString(Pref.name) ?? false;
      email = pref.getString(Pref.email) ?? false;
      phone = pref.getString(Pref.phone) ?? false;
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  ////////////sign out////////////////
  signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(Pref.name);
    pref.remove(Pref.id);
    pref.remove(Pref.login);
    pref.remove(Pref.level);
    pref.remove(Pref.createdDate);
    pref.remove(Pref.kode);
    _auth.signOut();
    googleSignIn.signOut();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Menu()));
  }

  ////////////init State////////////////////////
  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        actions: <Widget>[
          login
              ? IconButton(
                  icon: Icon(Icons.lock_open),
                  onPressed: signOut,
                )
              : SizedBox(),
        ],
        backgroundColor: Colors.blueGrey,
      ),
      body: login
          ? Container(
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("$name"),
                      Text("$email"),
                      Text("$phone"),
                    ],
                  ),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Please Login to create your own groceries list!",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  RaisedButton(
                    color: Colors.orange,
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      "Sign In",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),

                  ),
                ],
              ),
            ),
    );
  }
}
