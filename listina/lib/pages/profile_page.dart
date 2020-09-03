import 'package:flutter/material.dart';
import 'package:listina/widgets/provider_widget.dart';
import 'package:listina/models/user.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User user = new User("");
  bool _isAdmin = false;

  TextEditingController _userCountryController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: Provide.of(context).auth.getCurrentUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return displayUserInformation(context, snapshot);
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget displayUserInformation(context, snapshot) {
    final authData = snapshot.data;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            " Name : ${authData.displayName ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            " Email : ${authData.email ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        FutureBuilder(
          future: _getProfileData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _userCountryController.text = user.state;
              _isAdmin = user.admin ?? false;
            }
            return Container(
//              child: Column(
//                children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Text(
//                      " State : ${user.state}",
//                      style: TextStyle(fontSize: 20),
//                    ),
//                  ),
//                  adminFeature(),
//                ],
//              ),
            );
          },
        ),
        showSignOut(context, authData.isAnonymous),
//        RaisedButton(
//          child: Text("Edit User"),
//          onPressed: () {
//            _userEditBottomSheet(context);
//          },
//        ),
      ],
    );
  }

  _getProfileData() async {
    final uid = await Provide.of(context).auth.getCurrentUID();
    await Provide.of(context)
        .db
        .collection('userData')
        .document(uid)
        .get()
        .then((result) {
      user.state = result.data['state'];
      user.admin = result.data['admin'];
    });
  }

////////////sign out/////////////////////
  Widget showSignOut(context, bool isAnonymous) {
    if (isAnonymous == true) {
      return RaisedButton(
        child: Text("Sign In to save your data"),
        onPressed: () {
          Navigator.of(context).pushNamed('/convertUser');
        },
      );
    } else {
      return RaisedButton(
        child: Text("Sign Out"),
        onPressed: () async {
          try {
            await Provide.of(context).auth.signOut();
          } catch (e) {
            print(e);
          }
        },
      );
    }
  }

  /////////////admin feature////////
  Widget adminFeature(){
    if(_isAdmin == true){
      return Text("You are an admin");
    }else{
      return Container();
    }
  }

////////////////////edit bottom sheett//////////////////
  void _userEditBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * .60,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Update profile"),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.orange,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: TextField(
                            controller: _userCountryController,
                            decoration: InputDecoration(
                                helperText: "Your current state"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Save"),
                        color: Colors.indigo,
                        textColor: Colors.white,
                        onPressed: () async {
                          user.state = _userCountryController.text;
                          setState(() {
                            _userCountryController.text = user.state;
                            Navigator.of(context).pop();
                          });
                          final uid = Provide.of(context).auth.getCurrentUID();
                          await Provide.of(context)
                              .db
                              .collection('userData')
                              .document(uid)
                              .setData(user.toJson());
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
