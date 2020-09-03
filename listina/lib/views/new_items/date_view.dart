import 'package:flutter/material.dart';
import 'package:listina/models/itemModel.dart';
import 'package:listina/views/new_items/amount_view.dart';
import 'package:intl/intl.dart';

class NewBudgetDateView extends StatefulWidget {
  ////////////////////////itemModel//////////////
  final Item item;

  NewBudgetDateView({Key key, @required this.item}) : super(key: key);

  @override
  _NewBudgetDateViewState createState() => _NewBudgetDateViewState();
}

class _NewBudgetDateViewState extends State<NewBudgetDateView> {
  DateTime _startDate = DateTime.now();

  Future displayDatePicker(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _startDate,
        firstDate: DateTime(DateTime.now().year -5),
    lastDate:DateTime(DateTime.now().year +5)
    );

    if(picked != null){
      setState(() {
        _startDate = picked;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Budget Date"),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Budget for ${widget.item.title}", style: TextStyle(fontSize: 20),),
            SizedBox(height: 50,),

            Container(
              padding: EdgeInsets.only(top: 10, bottom: 50),
              child: RaisedButton(
                child: Text("Select Date"),
                onPressed: ()async{
                  await displayDatePicker(context);
                },
              ),
            ),
            Text("Date : ${DateFormat('dd/MM/yyyy').format(_startDate).toString()}", style: TextStyle(fontSize: 18),),
            SizedBox(height: 20,),

            RaisedButton(
              child: Text("Continue", style: TextStyle(color: Colors.white),),
              onPressed: () {
                widget.item.startDate = _startDate;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NewBudgetAmountView(item: widget.item)),
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
