import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mecommerce/custom/dynamicLinkCustom.dart';
import 'package:mecommerce/custom/prefProfile.dart';
import 'package:mecommerce/screen/menu/homepage.dart';
import 'package:mecommerce/screen/menu/listpage.dart';
import 'package:mecommerce/screen/menu/profilepage.dart';
import 'package:mecommerce/screen/menu/retailerpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String fcmToken;


  ///////////////get Pref//////////////////
  String name;
  bool login = false;
  getPref() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString(Pref.name);
      login = pref.getBool(Pref.login) ?? false;
    });
    print(name);
    print(login);
  }
/////////////firebase dynamic link//////////////

  final DynamicLinkServices _dynamicLinkServices = DynamicLinkServices();

  Future handleStartupClass() async{
    await _dynamicLinkServices.handleDynamicLink(context);
  }
//////////////////////////firebase generate token///////////////////////

  generatedToken()async{
    fcmToken = await _firebaseMessaging.getToken();
    print("FCM Token : $fcmToken");
  }

  //////////////init state//////////////////
  @override
  void initState(){
    super.initState();
    generatedToken();
    handleStartupClass();
    getPref();
  }
////////////////////////////menu///////////////////////
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: selectIndex != 0,
            child: TickerMode(
              enabled: selectIndex ==0,
              child: HomePage(),
            ),
          ),
          Offstage(
            offstage: selectIndex != 1,
            child: TickerMode(
              enabled: selectIndex ==1,
              child: ListPage(),
            ),
          ),
          Offstage(
            offstage: selectIndex != 2,
            child: TickerMode(
              enabled: selectIndex ==2,
              child: RetailerPage(),
            ),
          ),
          Offstage(
            offstage: selectIndex != 3,
            child: TickerMode(
              enabled: selectIndex ==3,
              child: ProfilePage(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
                onTap: (){
                  setState(() {
                    selectIndex = 0;
                    print(selectIndex);
                  });
                },
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    selectIndex = 1;
                    print(selectIndex);
                  });
                },
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    selectIndex = 2;
                    print(selectIndex);
                  });
                },
                child: Icon(
                  Icons.store,
                  color: Colors.white,
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    selectIndex = 3;
                    print(selectIndex);
                  });
                },
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
