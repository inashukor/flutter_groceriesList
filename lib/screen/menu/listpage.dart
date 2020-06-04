import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:biru/model/productModel.dart';

import 'package:http/http.dart' as http;
import 'package:biru/network/network.dart';
import 'package:biru/screen/product/productDetail.dart';
import 'package:biru/screen/menu/homepage.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  //////////////////////////////////get product based on device///////////////
  List<ProductModel> list = [];

  //////device info//////////////
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceID;

  getDeviceInfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("Device Info : ${androidInfo.id}");
    setState(() {
      deviceID = androidInfo.id;
    });
    getProduct();
  }

  var loading = false;
  var cekData = false;

  getProduct() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response =
        await http.get(NetworkUrl.getProductFavoriteWithoutLogin(deviceID));
    if (response.statusCode == 200) {
      if (response.contentLength == 2) {
        setState(() {
          loading = false;
          cekData = false;
        });
      } else {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          for (Map i in data) {
            list.add(ProductModel.fromJson(i));
          }
          loading = false;
          cekData = true;
        });
      }
    } else {
      setState(() {
        loading = false;
        cekData = false;
      });
    }
  }

  //////////////////////add product to favourite///////////////
  addFavorite(ProductModel model) async {
    setState(() {
      loading = true;
    });
    final response =
        await http.post(NetworkUrl.addFavoriteWithoutLogin(), body: {
      "deviceInfo": deviceID,
      "idProduct": model.id,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      print(message);
      getProduct();
      setState(() {
        loading = false;
      });
    } else {
      print(message);
      setState(() {
        loading = false;
      });
    }
  }

  ///////////refresh page for fav product///////////////
  Future<void> onRefresh() async {
    getDeviceInfo();
  }

///////////////initState/////////////////////////////
  @override
  void initState() {
    super.initState();
    getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          children: <Widget>[
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : cekData
                    ? Container(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          padding: EdgeInsets.all(10),
                          itemCount: list.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                          itemBuilder: (context, i) {
                            final a = list[i];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetail(a,getProduct)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey[300],
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5,
                                        color: Colors.grey,
                                      ),
                                    ]),
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Expanded(
                                      child: Stack(
                                        children: <Widget>[
                                          Image.network(
                                            "http://192.168.1.9/mylist/product/${a.pic}",
                                            height: 180,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  addFavorite(a);
                                                },
                                                icon:
                                                    Icon(Icons.favorite_border),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "${a.productName}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
//                                    Text(
//                                      "RM ${price.format(a.productPrice)}",
//                                      style: TextStyle(
//                                        fontWeight: FontWeight.w300,
//                                        color: Colors.orange,
//                                        fontSize: 14,
//                                      ),
//                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "You don't have product favourite ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
