import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:biru/model/productCartModel.dart';
import 'package:biru/network/network.dart';
import 'package:device_info/device_info.dart';

class ProductCart extends StatefulWidget {
  @override
  _ProductCartState createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  ////////////////product cart model////////////////////////////
  List<ProductCartModel> list = [];

  /////////device info //////
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final price = NumberFormat("#,##0", 'en_US');

  getDeviceInfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("Device Info : ${androidInfo.id}");
    setState(() {
      unikID = androidInfo.id;
    });
    _fetchData();
  }

  String unikID;
  var loading = false;
  var cekData = false;

  //////////////////////fetch data from cart database////////
  _fetchData() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(NetworkUrl.getProductCart(unikID));
    if (response.statusCode == 200) {
      if (response.contentLength == 2) {
        setState(() {
          loading = false;
          cekData = false;
        });
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          for (Map i in data) {
            list.add(ProductCartModel.fromJson(i));
          }
          loading = false;
          cekData = true;
        });
        _getSummaryAmount();
      }
    } else {
      setState(() {
        loading = false;
        cekData = false;
      });
    }
  }

  //////////////sum of product price//////////
  var totalPrice = "0";

  _getSummaryAmount() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(NetworkUrl.getSummaryAmountCart(unikID));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      String total = data['total'];
      setState(() {
        loading = false;
        totalPrice = total;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  ////////////////add quantity of product////////////
  _addQuantity(ProductCartModel model, String tipe) async {
    await http.post(NetworkUrl.updateQuantity(), body: {
      "idProduct": model.id,
      "unikID": unikID,
      "tipe": tipe,
    });
    setState(() {
      _fetchData();
    });
  }

///////////////////initState////////////////////////////
  @override
  void initState() {
    super.initState();
    getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Cart"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : cekData
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemCount: list.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, i) {
                            final a = list[i];
                            return Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Text(a.productName),
                                        Text(
                                            "Price : RM ${price.format(a.productPrice)}"),
                                        Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 2),
                                          child: Divider(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: IconButton(
                                      onPressed: () {
                                        _addQuantity(a, "tambah");
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                  ),
                                  Container(
                                    child: Text("${a.qty}"),
                                  ),
                                  Container(
                                    child: IconButton(
                                      onPressed: () {
                                        _addQuantity(a, "kurang");
                                      },
                                      icon: Icon(Icons.remove),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      totalPrice == "0"
                          ? SizedBox()
                          : Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "Total Price : RM ${price.format(int.parse(totalPrice))}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  InkWell(
                                    onTap: () {

                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.orange,
                                      ),
                                      child: Text(
                                        "Save List",
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
                            ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "You don't have product on cart",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
