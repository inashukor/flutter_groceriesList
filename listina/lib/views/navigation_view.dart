import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listina/models/itemModel.dart';

//pages
import 'package:listina/pages/profile_page.dart';
import 'package:listina/pages/hypermarket_page.dart';
import 'package:listina/pages/home_page.dart';
import 'package:listina/views/new_items/budget_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int currentTabIndex = 0;
  List<Widget> pages;
  Widget currentPage;
  HomePage homePage;
  HypermarketPage hypermarketPage;
  ProfilePage profilePage;

  @override

  void initState(){
    super.initState();
    homePage = HomePage();
    hypermarketPage = HypermarketPage();
    profilePage = ProfilePage();

    pages = [homePage, hypermarketPage, profilePage];

    currentPage = homePage;
  }

  Widget build(BuildContext context) {
    final newItem = new Item(null, null, null, null, null);

    return Scaffold(
      appBar: AppBar(
        title: Text("ShopList App"),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewItemBudgetView(
                        item: newItem,
                      )));
            },
          ),
        ],
      ),


      body: currentPage,

      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          //sets the background color of the bottom navigation bar
          canvasColor: Colors.white,
          //set the active color
        ),
        child: BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
              currentPage = pages[index];
            });
          },
          currentIndex: currentTabIndex,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                title: Text("DashBoard")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.store),
                title: Text("Hypermarket")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                title: Text("Profile")
            ),
          ],
        ),
      ),

    );
  }
}
