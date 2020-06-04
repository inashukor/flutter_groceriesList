import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:biru/model/productModel.dart';
import 'package:biru/network/network.dart';
import 'package:biru/screen/product/productDetail.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  var loading = false;

  List<ProductModel> list = [];
  List<ProductModel> listSearch = [];
//////////////////////////get product/////////////////////////////////
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

  final price = NumberFormat("#,##0", 'en_US');

  /////////////////////method for product search/////////////////////////////
  TextEditingController searchController = TextEditingController();

  onSearch(String text) async {
    listSearch.clear();
    if (text.isEmpty) {
      setState(() {});
    }
    list.forEach((a) {
      if (a.productName.toLowerCase().contains(text)) listSearch.add(a);
    });
    setState(() {});
  }

  ////////////////////////add refresh action//////////////////////////////
  Future<void> onRefresh() async {
    getProduct();
  }
  ///////////////////////////initState////////////////////////////
  @override
  void initState() {
    super.initState();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 50,
          padding: EdgeInsets.all(4),
          child: TextField(
            textAlign: TextAlign.left,
            autofocus: true,
            controller: searchController,
            onChanged: onSearch,
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
              hintText: "Search product",
              fillColor: Colors.white,
              filled: true,
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
      /////////////////////body///////////////////////////
      body: Container(
        child: loading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : searchController.text.isNotEmpty || listSearch.length != 0
            ? GridView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: listSearch.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, i) {
              final a = listSearch[i];
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetail(a, getProduct)));
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Image.network(
                          "http://192.168.1.9/mylist/product/${a.pic}",
                          height: 200,
                          fit: BoxFit.cover,
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
//                      Text(
//                        "RM ${price.format(a.productPrice)}",
//                        style: TextStyle(
//                          fontWeight: FontWeight.w300,
//                          color: Colors.orange,
//                          fontSize: 14,
//                        ),
//                      ),
                    ],
                  ),
                ),
              );
            })
            : Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Please search your product",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
