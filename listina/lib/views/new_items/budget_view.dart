import 'package:flutter/material.dart';
import 'package:listina/models/itemModel.dart';
import 'package:listina/views/new_items/date_view.dart';

class NewItemBudgetView extends StatelessWidget {
  ////////////////////////itemModel//////////////
  final Item item;

  NewItemBudgetView({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    _titleController.text = item.title;

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Budget Name"),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("A Budget for ? "),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: _titleController,
                autofocus: true,
              ),
            ),
            RaisedButton(
              child: Text("Continue", style: TextStyle(color: Colors.white),),
              onPressed: () {
                item.title = _titleController.text;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewBudgetDateView(item: item)),
                );
              },
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}
