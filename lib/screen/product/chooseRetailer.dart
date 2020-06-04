import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biru/model/retailerProductModel.dart';
import 'package:biru/network/network.dart';

class ChooseRetailerProduct extends StatefulWidget {
  @override
  _ChooseRetailerProductState createState() => _ChooseRetailerProductState();
}

class _ChooseRetailerProductState extends State<ChooseRetailerProduct> {

  var loading = false;
/////////////////////get product with retailer/////////////////
  List<RetailerProductModel> listRetailer = [];

  getProductWithRetailer() async {
    setState(() {
      loading = true;
    });
    listRetailer.clear();
    final response = await http.get(NetworkUrl.getProductRetailer());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        for (Map i in data) {
          listRetailer.add(RetailerProductModel.fromJson(i));
        }
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    getProductWithRetailer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Retailer"),
        elevation: 1,
      ),
      body: Container(
          child: loading ? Center(child: CircularProgressIndicator(),) : ListView.builder(
            itemCount: listRetailer.length,
            itemBuilder: (context, i){
              final a = listRetailer[i];
              return InkWell(
                onTap: (){
                  Navigator.pop(context, a);
                },
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(a.retailerName),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4,),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
      ),
    );
  }
}
