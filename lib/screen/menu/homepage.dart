import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:biru/model/categoryProductModel.dart';
import 'package:biru/model/productModel.dart';
import 'package:biru/network/network.dart';
import 'package:biru/screen/product/addProduct.dart';

import 'package:http/http.dart' as http;
import 'package:biru/screen/product/productCart.dart';
import 'package:biru/screen/product/productDetail.dart';
import 'package:biru/screen/product/searchProduct.dart';

import 'package:device_info/device_info.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final price = NumberFormat("#,##0", 'en_US');

class _HomePageState extends State<HomePage> {
  var loading = false;

  ////////device Info//////
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceID;

  getDeviceInfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("Device Info : ${androidInfo.id}");
    setState(() {
      deviceID = androidInfo.id;
    });
    getTotalCart();
  }
  ////////////////get product with category/////////////
  List<CategoryProductModel> listCategory = [];
  getProductWithCategory() async {
    setState(() {
      loading = true;
    });
    listCategory.clear();
    final response = await http.get(NetworkUrl.getProductCategory());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        for (Map i in data) {
          listCategory.add(CategoryProductModel.fromJson(i));
        }
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  /////////////filter based on product category////
  var filter = false;

  //////////////////get product ///////////////////////
  List<ProductModel> list = [];

  getProduct() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(NetworkUrl.getProduct());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        for (Map i in data) {
          list.add(ProductModel.fromJson(i));
        }
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }
  ///////////get total cart//////////////////////////////
  var loadingCart = false;
  var totalCart = "0";

  getTotalCart() async {
    setState(() {
      loadingCart = true;
    });
    final response = await http.get(NetworkUrl.getTotalCart(deviceID));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      String total = data['total'];
      setState(() {
        loadingCart = false;
        totalCart = total;
      });
    } else {
      setState(() {
        loadingCart = false;
      });
    }
  }

  /////////////////refresh /////////////////////
  Future<void> onRefresh() async {
    getProduct();
//    getTotalCart();
    getProductWithCategory();
    setState(() {
      filter = false;
    });
  }

  int index = 0;

  /////////////add product to favourite//////
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

  ///////////////////////initState//////////////////
  @override
  void initState() {
    super.initState();
    getProduct();
    getProductWithCategory();
    getDeviceInfo();
//    getTotalCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///////////////app bar/////////////////////////////////
      appBar: AppBar(
        ///////////////////////icon////////////
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductCart()));
            },
            icon: Stack(
              children: <Widget>[
                Icon(Icons.shopping_cart),
                totalCart == "0" ? SizedBox() : Positioned(
                  right: 0,
                  top: -4,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Text(
                      "$totalCart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        /////////search product////////////////////
        title: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchProduct()));
          },
          child: Container(
            height: 50,
            padding: EdgeInsets.all(4),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search product",
                fillColor: Colors.white,
                filled: true,
                enabled: false,
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(style: BorderStyle.none),
                ),
              ),
            ),
          ),
        ),
      ),
      ///////////////////////////////////floating button///////////////////
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddProduct(),
              ));
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.blue,
          ),
          child: Text(
            "add Product",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      /////////////////////////////////body///////////////////////////////////////
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: onRefresh,
              /////////////////////////////////grid view homepage no filter/////////
              child: ListView(
                children: <Widget>[
                  /////////////////////product category//////
                  Container(
                    height: 50,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: listCategory.length,
                      itemBuilder: (context, i) {
                        final a = listCategory[i];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              filter = true;
                              index = i;
                              print(filter);
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 4, left: 8, top: 4),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.amber,
                            ),
                            child: Text(
                              a.categoryName,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  //////////////////product grid view by filter/////////
                  filter
                      ? listCategory[index].product.length == 0
                          ? Container(
                              height: 100,
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Sorry product on this category is not available",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: listCategory[index].product.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                              ),
                              itemBuilder: (context, i) {
                                final a = listCategory[index].product[i];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetail(a , getTotalCart)));
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
                                                    icon: Icon(
                                                      Icons.favorite_border,
                                                    ),
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
//                                        Text(
//                                          "RM ${price.format(a.productPrice)}",
//                                          style: TextStyle(
//                                            fontWeight: FontWeight.w300,
//                                            color: Colors.orange,
//                                            fontSize: 14,
//                                          ),
//                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                      //////////////// product grid view no filter////////
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
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
                                            ProductDetail(a, getTotalCart)));
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
                ],
              ),
            ),
    );
  }
}
