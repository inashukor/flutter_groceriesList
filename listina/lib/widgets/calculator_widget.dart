import 'package:flutter/material.dart';
import 'package:listina/widgets/money_text_field.dart';
import 'package:listina/models/itemModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listina/widgets/provider_widget.dart';

class CalculatorWidget extends StatefulWidget {
  final Item item;

  CalculatorWidget({@required this.item});

  @override
  _CalculatorWidgetState createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {

  TextEditingController _moneyController = TextEditingController();
  int _saved;
  int _needed;

  @override
  void initState() {
    super.initState();
    _saved = (widget.item.saved ?? 0.0).floor();
    _needed = (widget.item.budget.floor()) - _saved;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: <Widget>[
        Container(
          color: Colors.teal,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "RM $_saved",
                      style: TextStyle(fontSize: 40),
                    ),
                    Text(
                      "Expense",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Container(
                  height: 80,
                  child: VerticalDivider(
                    color: Colors.white,
                    thickness: 5,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "RM $_needed",
                      style: TextStyle(fontSize: 40),
                    ),
                    Text(
                      "Budget",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.lightGreen,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 40.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: MoneyTextField(
                    controller: _moneyController,
                    helperText: "Amount",
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle),
                  color: Colors.teal,
                  iconSize: 50,
                  onPressed: () async {
                    setState(() {
                      _saved = _saved + int.parse(_moneyController.text);
                      _needed = _needed - int.parse(_moneyController.text);
                    });
                    final uid = await Provide.of(context).auth.getCurrentUID();
                    await Firestore.instance
                        .collection('userData')
                        .document(uid)
                        .collection('items')
                        .document(widget.item.documentId)
                        .updateData({'saved': _saved.toDouble()});
                  },
                ),
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  color: Colors.pink,
                  iconSize: 50,
                  onPressed: () async {
                    setState(() {
                      _saved = _saved - int.parse(_moneyController.text);
                      _needed = _needed + int.parse(_moneyController.text);
                    });
                    final uid = await Provide.of(context).auth.getCurrentUID();
                    await Firestore.instance
                        .collection('userData')
                        .document(uid)
                        .collection('items')
                        .document(widget.item.documentId)
                        .updateData({'saved': _saved.toDouble()});
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
