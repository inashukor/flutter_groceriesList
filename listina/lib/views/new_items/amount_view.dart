import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listina/models/itemModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listina/views/new_items/summary_view.dart';
import 'package:listina/widgets/divider_with_text._widget.dart';
import 'package:listina/widgets/money_text_field.dart';
import 'package:listina/widgets/provider_widget.dart';

enum budgetType { simple, complex }

class NewBudgetAmountView extends StatefulWidget {
  final Item item;

  NewBudgetAmountView({Key key, @required this.item}) : super(key: key);

  @override
  _NewBudgetAmountViewState createState() => _NewBudgetAmountViewState();
}

class _NewBudgetAmountViewState extends State<NewBudgetAmountView> {
  var _budgetstate = budgetType.simple;
  var _switchButtonText = "Build Budget";
  var _budgetTotal = 0;

  TextEditingController _budgetController = new TextEditingController();
  TextEditingController _groceryController = new TextEditingController();
  TextEditingController _householdController = new TextEditingController();

  /////////////initstate////////////////////
  @override
  void initState() {
    super.initState();
    _budgetController.addListener(_setBudgetTotal);
    _groceryController.addListener(_setTotalBudget);
    _householdController.addListener(_setTotalBudget);
  }

  /////////////set total budget//////////////////////
  _setTotalBudget() {
    var total = 0;
    total =
    (_groceryController.text == "") ? 0 : int.parse(_groceryController.text);
    total += (_householdController.text == "") ? 0 : int.parse(
        _householdController.text);
    setState(() {
      _budgetTotal = total;
    });
  }

  _setBudgetTotal() {
    setState(() {
      _budgetTotal = int.parse(_budgetController.text);
    });
  }


  List<Widget> setBudgetFields(_budgetController) {
    List<Widget> fields = [];

    if (_budgetstate == budgetType.simple) {
      _switchButtonText = "Build Budget";

      fields.add(Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text("Enter amount of Budget"),
      ));

      fields
          .add(MoneyTextField(controller:_budgetController, helperText:"Daily Estimated budget"));
    } else {
      //assume complex budget///////////////////
      _switchButtonText = "Simple Budget";
      fields.add(Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text("Enter How much you want to spend in each area"),
      ));
      fields.add(MoneyTextField(
          controller:_groceryController, helperText:"Estimation for grocery budget"));
      fields.add(MoneyTextField(
          controller:_householdController,helperText: "Estimation for household budget"));

      fields.add(Text("Total : RM $_budgetTotal"));
    }

    fields.add(
      FlatButton(
        child: Text(
          "Continue",
          style: TextStyle(
            fontSize: 25,
            color: Colors.blue,
          ),
        ),
        onPressed: () async {
          widget.item.budget = _budgetTotal.toDouble();
          widget.item.budgetTypes = {
            'grocery': (_groceryController.text == "") ? 0.0 : double.parse(
                _groceryController.text),
            'household': (_householdController.text == "") ? 0.0 : double.parse(
                _householdController.text),
          };

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewBudgetSummaryView(item: widget.item)),
          );
        },
      ),
    );
    fields.add(
      DividerWithText(
        dividerText: "or",
      ),
    );
    fields.add(
      FlatButton(
          child: Text(
            _switchButtonText,
            style: TextStyle(
              fontSize: 25,
              color: Colors.blue,
            ),
          ),
          onPressed: () {
            setState(() {
              _budgetstate = (_budgetstate == budgetType.simple)
                  ? budgetType.complex
                  : budgetType.simple;
            });
          }),
    );

    return fields;
  }

  @override
  Widget build(BuildContext context) {
    _budgetController.text =
    (_budgetController.text == "0") ? "" : _budgetTotal.toString();
    _budgetController.selection =
        TextSelection.collapsed(offset: _budgetController.text.length);

    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Amount of budget"),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: setBudgetFields(_budgetController),
          ),
        ),
      ),
    );
  }

}
