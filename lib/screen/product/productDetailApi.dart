import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mecommerce/model/productModel.dart';
import 'package:mecommerce/network/network.dart';
import 'package:mecommerce/screen/menu/homepage.dart';
import 'package:device_info/device_info.dart';

import 'package:http/http.dart' as http;

class ProductDetailAPI extends StatefulWidget {
  final String idProduct;

  ProductDetailAPI( this.idProduct);

  @override
  _ProductDetailAPIState createState() => _ProductDetailAPIState();
}

class _ProductDetailAPIState extends State<ProductDetailAPI> {
  /////////////////device info/////////////////////
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceID;
  ProductModel model;

  getDeviceInfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("Device Info : ${androidInfo.id}");
    setState(() {
      deviceID = androidInfo.id;
    });
    getProductDetail();
  }
/////////get product detail//////////////////
  getProductDetail() async{
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
    final response = await http.get(NetworkUrl.getProductDetail(widget.idProduct));
    if(response.statusCode ==200){
      Navigator.pop(context);
      final data = jsonDecode(response.body);
      setState(() {
        for(Map i in data){
          model = ProductModel.fromJson(i);
        }
      });
      print(model);
    }else{
      Navigator.pop(context);
    }
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
      "idProduct": model.id,
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
        title: Text("${model.productName}"),
        backgroundColor: Colors.blueGrey,
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
                    "http://192.168.1.9/ecommerce/product/${model.pic}",
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "${model.productName}",
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
//                  Text(
//                    "${model.description}",
//                    style: TextStyle(
//                      fontWeight: FontWeight.w300,
//                      color: Colors.black,
//                      fontSize: 18,
//                    ),
//                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "RM ${price.format(model.productPrice)}",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
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
