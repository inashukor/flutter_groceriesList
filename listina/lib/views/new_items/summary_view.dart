import 'package:flutter/material.dart';
import 'package:listina/models/itemModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listina/widgets/provider_widget.dart';

class NewBudgetSummaryView extends StatelessWidget {
  ////////////////////////call package//////////////
  final db = Firestore.instance;
  final Item item;


  NewBudgetSummaryView({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemTypes = item.types();
     var itemKeys = itemTypes.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Budget Summary"),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Finish", style: TextStyle(fontSize: 18),),
            SizedBox(height: 10,),
            Text("Budget for ${item.title}",style: TextStyle(fontSize: 18),),
            Text("Date :  ${item.startDate}",style: TextStyle(fontSize: 18),),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                scrollDirection: Axis.vertical,
                primary: false,
                children: List.generate(
                  itemTypes.length,
                  (index) {
                    return FlatButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          itemTypes[itemKeys[index]],
                          Text(itemKeys[index]),
                        ],
                      ),
                      onPressed: ()async{
                        item.listType = itemKeys[index];
                        final uid = await Provide.of(context).auth.getCurrentUID();

                        await db
                            .collection("userData")
                            .document(uid)
                            .collection("items")
                            .add(item.toJson());
                        Navigator.of(context).popUntil((route) => route.isFirst);

                      },
                    );
                  },
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
