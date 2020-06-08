class ProductModel {
  final String id;
  final String productName;
  final int productPrice;
  final String createdDate;
  final String pic;
  final String status;
  final String description;

  ProductModel({
    this.id,
    this.productName,
    this.productPrice,
    this.createdDate,
    this.pic,
    this.status,
    this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json){
    return ProductModel(
      id: json['id'],
      productName: json['productName'],
      productPrice: json['productPrice'],
      createdDate: json['createdDate'],
      pic: json['pic'],
      status: json['status'],
      description: json['description'],

    );
  }
}
