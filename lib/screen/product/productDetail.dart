import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:biru/model/productModel.dart';
import 'package:biru/network/network.dart';
import 'package:biru/screen/menu/homepage.dart';
import 'package:device_info/device_info.dart';

import 'package:http/http.dart' as http;

class ProductDetail extends StatefulWidget {
  final ProductModel model;
  final VoidCallback reload;

  ProductDetail(this.model, this.reload);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  /////////////////device info/////////////////////
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceID;

  getDeviceInfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("Device Info : ${androidInfo.id}");
    setState(() {
      deviceID = androidInfo.id;
    });
  }

  ///////////////add to cart/list//////////////////////////////////
  addCart() async {
    /////////loading bar/////////////
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Processing"),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 4,
                  ),
                  Text("Loading..."),
                ],
              ),
            ),
          );
        });
    final response = await http.post(NetworkUrl.addCart(), body: {
      "unikID": deviceID,
      "idProduct": widget.model.id,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Information"),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      Navigator.pop(context);
                      widget.reload();
                    });
                  },
                  child: Text("OK"),
                ),
              ],
            );
          });
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Warning"),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            );
          });
    }
  }

  ////////////initState///////////////////////////////
  @override
  void initState() {
    super.initState();
    getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.model.productName}"),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(8),
                children: <Widget>[
                  Image.network(
                    "http://192.168.1.9/mylist/product/${widget.model.pic}",
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "${widget.model.productName}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "${widget.model.description}",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(16),
//                  child: Text(
//                    "RM ${price.format(widget.model.productPrice)}",
//                    style: TextStyle(
//                      fontWeight: FontWeight.w300,
//                      color: Colors.black,
//                      fontSize: 14,
//                    ),
//                  ),
                ),
                InkWell(
                  onTap: () {
                    addCart();
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.orange,
                    ),
                    child: Text(
                      "Add to List",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
