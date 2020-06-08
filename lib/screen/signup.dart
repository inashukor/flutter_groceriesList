import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mecommerce/custom/prefProfile.dart';
import 'package:mecommerce/network/network.dart';
import 'package:mecommerce/screen/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  final String email;
  final String token;

  Signup(this.email, this.token);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  final _key = GlobalKey<FormState>();

  cek() async {
    if (_key.currentState.validate()) {
      simpan();
    }
  }
/////////////simpan/////////////////////////
  simpan() async {
    final response = await http.post(NetworkUrl.signup(), body: {
      "email" : widget.email,
      "token" : widget.token,
      "name" : name.text,
      "phone" : phone.text,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];

    String id = data['id'];
    String nama = data['name'];
    String hp = data['phone'];
    String emailUsers = data['email'];
    String createdDate = data['createdDate'];
    String level = data['level'];

    if (value ==1){
      setState(() {
        savePref(id, emailUsers, hp, nama, createdDate, level);
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Menu()));
    }else{
      print(message);
    }
  }

  ////////////////ssve preference/////////
  savePref(
      String id,
      String email,
      String phone,
      String name,
      String createdDate,
      String level,
      ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString(Pref.id, id);
      pref.setString(Pref.email, email);
      pref.setString(Pref.name, name);
      pref.setString(Pref.createdDate, createdDate);
      pref.setString(Pref.level, level);
      pref.setBool(Pref.login, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: <Widget>[
              TextFormField(
                controller: name,
                validator: (e){
                  if (e.isEmpty)
                    return "Please input your name";
                  else
                    null;
                },
                decoration: InputDecoration(
                  hintText: "Name"
                ),
              ),TextFormField(
                keyboardType: TextInputType.phone,
                controller: phone,
                validator: (e) {
                  if (e.isEmpty)
                    return "Please input your phone number";
                  else
                    null;
                },
                decoration: InputDecoration(
                  hintText: "Phone number"
                ),
              ),
              SizedBox(height: 16,),
              InkWell(
                onTap: cek,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.redAccent[200],
                        Colors.amber,
                      ],
                    ),
                  ),
                  child: Text(
                    "Submit",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
