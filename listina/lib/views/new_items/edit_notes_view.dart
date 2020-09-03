import 'package:flutter/material.dart';
import 'package:listina/models/itemModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listina/widgets/provider_widget.dart';

class EditNotesView extends StatefulWidget {
  final Item item;

  EditNotesView({Key key, @required this.item}) : super(key: key);

  @override
  _EditNotesViewState createState() => _EditNotesViewState();
}

class _EditNotesViewState extends State<EditNotesView> {
  TextEditingController _notesController = new TextEditingController();

  final db = Firestore.instance;

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.item.notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[300],
        child: Hero(
          tag: "BudgetNotes-${widget.item.title}",
          transitionOnUserGestures: true,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildHeading(context),
                  buildNotesText(),
                  buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeading(context) {
    return Material(
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "Budget Notes",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
            FlatButton(
              child: Icon(
                Icons.close,
                color: Colors.black,
                size: 40,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNotesText() {
    return Material(
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          maxLines: null,
          controller: _notesController,
//          decoration: InputDecoration(border: InputBorder.none),
          cursorColor: Colors.indigo,
          autofocus: true,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget buildSubmitButton(context) {
    return Material(
      color: Colors.grey[300],
      child: RaisedButton(
        child: Text("Save", style: TextStyle(color: Colors.white),),
        color: Colors.indigo,
        onPressed: () async {
          widget.item.notes = _notesController.text;

          final uid = await Provide.of(context).auth.getCurrentUID();

          await db
              .collection("userData")
              .document(uid)
              .collection("items")
              .document(widget.item.documentId)
              .updateData({'notes': _notesController.text});

          Navigator.of(context).pop();
        },
      ),
    );
  }
}
