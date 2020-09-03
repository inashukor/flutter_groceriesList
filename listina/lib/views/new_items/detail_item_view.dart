import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:listina/models/itemModel.dart';
import 'package:listina/services/database.dart';
import 'package:listina/views/new_items/edit_notes_view.dart';
import 'package:intl/intl.dart';
import 'package:listina/widgets/calculator_widget.dart';
import 'package:listina/widgets/money_text_field.dart';
import 'package:listina/widgets/provider_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:device_apps/device_apps.dart';
import 'package:android_intent/android_intent.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DetailItemView extends StatefulWidget {
  final Item item;

  DetailItemView({Key key, @required this.item}) : super(key: key);

  @override
  _DetailItemViewState createState() => _DetailItemViewState();
}

class _DetailItemViewState extends State<DetailItemView> {
  ////////select date for remainder//////////////////////////
  DateTime _selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await DatePicker.showDateTimePicker(context, showTitleActions: true);
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  ///////////////////////////////////////////////////////////////

  TextEditingController _budgetController = TextEditingController();
  var _budget;

  @override
  void initState() {
    super.initState();
    _budgetController.text = widget.item.budget.toStringAsFixed(0);
    _budget = widget.item.budget.floor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text('Budget Details'),
              backgroundColor: Colors.indigo,
              expandedHeight: 50.0,
//              flexibleSpace: FlexibleSpaceBar(
//                background: ,
//              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.border_color,
                    color: Colors.black,
                    size: 30,
                  ),
                  padding: const EdgeInsets.only(right: 15),
                  onPressed: () {
                    _budgetEditModalBottomSheet(context);
                  },
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                budgetDetails(),
                CalculatorWidget(item: widget.item),
                daysOutCard(),
                totalBudgetCard(),
                notesCard(context),
                remindMe(),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget remindMe(){
    return Card(
      color: Colors.red[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text("Set Shopping Trip reminder", style: TextStyle(fontSize: 20),),
            Divider(),
            Text(DateFormat.yMMMMd("en_US").format(_selectedDate)),
            Text(DateFormat("H:mm").format(_selectedDate)),
            Container(
              color: Colors.white,
              child: FlatButton(
                child: Text("Set Date and Time"),
                onPressed: () => _selectDate(context),
              ),
            ),
            RaisedButton(
              onPressed: (){
                Database().createNotification(whenToNotify: Timestamp.fromDate(_selectedDate));
              },
              child: Text("REMIND ME !"),
            ),
          ],
        ),
      ),
    );

  }

  ///////days till budget date card///////////
  Widget daysOutCard() {
    return Card(
      color: Colors.greenAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "${widget.item.getDaysUntilDate()}",
              style: TextStyle(fontSize: 50),
            ),
            Text(
              "days until your shopping trip",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /////////budget detail card////////////
  Widget budgetDetails() {
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  widget.item.title,
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.blue[900],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text(DateFormat("dd/MM/yyyy")
                    .format(widget.item.startDate)
                    .toString()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //////total budget card///////
  Widget totalBudgetCard() {
    return Card(
      color: Colors.indigoAccent,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Budget Amount",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text(
                    "RM $_budget",
                    style: TextStyle(fontSize: 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

////////note card//////////////
  Widget notesCard(context) {
    return Hero(
      tag: "BudgetNotes-${widget.item.title}",
      transitionOnUserGestures: true,
      child: Card(
        color: Colors.grey[300],
        child: InkWell(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Row(
                  children: <Widget>[
                    Text("Budget notes",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: setNoteText(),
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditNotesView(item: widget.item)));
          },
        ),
      ),
    );
  }

  List<Widget> setNoteText() {
    if (widget.item.notes == null) {
      return [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.add_circle_outline,
            color: Colors.black,
          ),
        ),
        Text(
          "Click to add notes",
          style: TextStyle(color: Colors.black),
        ),
      ];
    } else {
      return [
        Text(
          widget.item.notes,
          style: TextStyle(color: Colors.black),
        ),
      ];
    }
  }

////edit modal bottom sheet////////////
  void _budgetEditModalBottomSheet(context) {
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
                      Text("Edit Budget details"),
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
                      Text(
                        widget.item.title,
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: MoneyTextField(
                          controller: _budgetController,
                          helperText: "Budget",
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
                          widget.item.budget = double.parse(_budgetController.text);
                          setState(() {
                            _budget = widget.item.budget.floor();
                          });
                          await updateBudget(context);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Delete"),
                        color: Colors.red,
                        textColor: Colors.white,
                        onPressed: () async {

                          await deleteBudget(context);
                          Navigator.of(context).pushNamedAndRemoveUntil("/home", (Route<dynamic> route)=>false);
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
//////////////update data dalam database//////////////
  Future updateBudget(context) async {
    var uid = await Provide.of(context).auth.getCurrentUID();
    final doc = Firestore.instance
        .collection('userData')
        .document(uid)
        .collection('items')
        .document(widget.item.documentId);
    return await doc.setData(widget.item.toJson());
  }

  /////////////delete budget///////////////
  Future deleteBudget(context) async {
    var uid = await Provide.of(context).auth.getCurrentUID();
    final doc = Firestore.instance
        .collection('userData')
        .document(uid)
        .collection('items')
        .document(widget.item.documentId);
    return await doc.delete();
  }

  /////////shoppe///////////////////
 Future _shopee() async{
    bool isInstalled = await DeviceApps.isAppInstalled('https://youtube.com');
    if (isInstalled !=false){
      DeviceApps.openApp("https://youtube.com");
    }
    else{
      Text("Cannot open");
    }
  }

}
