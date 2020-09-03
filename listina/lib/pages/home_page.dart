import 'package:flutter/material.dart';
import 'package:listina/models/itemModel.dart';
import 'package:intl/intl.dart';
import 'package:listina/views/new_items/budget_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listina/views/new_items/detail_item_view.dart';
import 'package:listina/widgets/provider_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listina/widgets/calculator_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future _nextBudget;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nextBudget = _getNextBudget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: _nextBudget,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                ////display welcome page
                return showNewHomePage();
              } else {
                return showHomePageWithBudgets(snapshot.data);
              }
            } else {
              return Text("Loading...");
            }
          },
        ),
      ),
    );
  }

////////////stream snapshot from firebase////////////
  Stream<QuerySnapshot> getUsersItemsStreamSnapshot(
      BuildContext context) async* {
    final uid = await Provide.of(context).auth.getCurrentUID();
    ///////return data untuk user tertentu//////
    yield* Firestore.instance
        .collection('userData')
        .document(uid)
        .collection('items')
        .orderBy('startDate')
        .snapshots();
  }

  /////////////get next budget/////////////
  _getNextBudget() async {
    final uid = await Provide.of(context).auth.getCurrentUID();
    var snapshot = await Firestore.instance
        .collection('userData')
        .document(uid)
        .collection('items')
        .orderBy('startDate')
        .limit(1)
        .getDocuments();

    return Item.fromSnapshot(snapshot.documents.first);
  }

  Widget buildItemCard(BuildContext context, DocumentSnapshot document) {
    final item = Item.fromSnapshot(document);
    final itemType = item.types();

    return new Container(
      child: Card(
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8,
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        item.title,
                        style: GoogleFonts.seymourOne(
                          fontSize: 20,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                    bottom: 30,
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(DateFormat("dd/MM/yyyy")
                          .format(item.startDate)
                          .toString()),
                      Spacer(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8,
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "RM ${(item.budget == null) ? "n/a" : item.budget.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 27,
                        ),
                      ),
                      Spacer(),
                      (itemType.containsKey(item.listType))
                          ? itemType[item.listType]
                          : itemType["other"],
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailItemView(item: item)),
            );
          },
        ),
      ),
    );
  }

  ////////homepage/////////
  Widget showHomePageWithBudgets(Item item) {
    return Column(
      children: <Widget>[
        CalculatorWidget(item: item),
        Expanded(
          child: StreamBuilder(
              stream: getUsersItemsStreamSnapshot(context),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      "Create new ShopList Budget",
                      style: TextStyle(fontSize: 20),
                    )),
                  );
                }
                return new ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildItemCard(context, snapshot.data.documents[index]));
              }),
        ),
      ],
    );
  }

  //////home page for user baru sign up///////////////
  Widget showNewHomePage() {
    final newItem = new Item(null, null, null, null, null);
    return Column(
      children: <Widget>[
        Container(
          color: Colors.cyan[100],
          height: MediaQuery.of(context).size.height * .3,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          color: Colors.grey[850],
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Column(
              children: <Widget>[
                Text(
                  "Create your first Shopping trip",
                  style: GoogleFonts.acme(fontSize: 25, color: Colors.white),
                ),
                RaisedButton(
                  child: Text(
                    "Start",
                    style: TextStyle(color: Colors.blue),
                  ),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NewItemBudgetView(item: newItem)));
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.cyan[100],
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ],
    );
  }
}
