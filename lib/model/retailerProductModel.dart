import 'package:biru/model/productPriceRetailerModel.dart';

class RetailerProductModel {
  final String id;
  final String retailerName;
  final String status;
  final String createdDate;
  final List<ProductPriceRetailerModel> productPriceRetailer;

  RetailerProductModel({
    this.id,
    this.retailerName,
    this.status,
    this.createdDate,
    this.productPriceRetailer,
  });

  factory RetailerProductModel.fromJson(Map<String, dynamic>json){
    var list = json['product_retailer'] as List;
    List<ProductPriceRetailerModel> productList = list.map((i)=>ProductPriceRetailerModel.fromJson(i)).toList();

    return RetailerProductModel(
      productPriceRetailer: productList,
      id: json['id'],
      retailerName: json['retailerName'],
      status: json['status'],
      createdDate: json['createdDate'],
    );
  }
}
