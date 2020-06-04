class ProductCartModel {
  final String id;
  final String productName;
  final int productPrice;
  final String createdDate;
  final String pic;
  final String status;
  final String description;
  final String qty;

  ProductCartModel({
    this.id,
    this.productName,
    this.productPrice,
    this.createdDate,
    this.pic,
    this.status,
    this.description,
    this.qty,
  });

  factory ProductCartModel.fromJson(Map<String, dynamic> json){
    return ProductCartModel(
      id: json['id'],
      productName: json['productName'],
      productPrice: json['productPrice'],
      createdDate: json['createdDate'],
      pic: json['pic'],
      status: json['status'],
      description: json['description'],
      qty: json['qty'],

    );
  }
}
