import 'package:biru/screen/menu/homepage.dart';
import 'package:biru/screen/menu/listpage.dart';
import 'package:biru/screen/menu/profilepage.dart';
import 'package:biru/screen/menu/retailerpage.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
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
        color: Colors.blue,
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
                  Icons.list,
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
