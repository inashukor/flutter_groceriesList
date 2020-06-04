import 'package:biru/model/productModel.dart';
import 'package:biru/model/retailerProductModel.dart';

class ProductPriceRetailerModel {
  final String id;
  final List<ProductModel>product;
  final List<RetailerProductModel> retailer;
  final int productPrice;

  ProductPriceRetailerModel({
    this.id,
    this.product,
    this.retailer,
    this.productPrice,
  });

  factory ProductPriceRetailerModel.fromJson(Map<String, dynamic>json){
    var list = json['product'] as List;
    var listR = json['retailer'] as List;
    List<ProductModel> productList = list.map((i)=>ProductModel.fromJson(i)).toList();
    List<RetailerProductModel> productListR = listR.map((i)=>RetailerProductModel.fromJson(i)).toList();

    return ProductPriceRetailerModel(
      id: json['id'],
      product: productList,
      retailer: productListR,
      productPrice: json['productPrice'],

    );
  }
}
