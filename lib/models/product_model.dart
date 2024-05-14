class ProductModel {
  final String? id; // Add this line
  String? productName;
  String? productPrice;
  String? imageUrl;

  ProductModel({this.id, this.productName, this.productPrice, this.imageUrl});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'], // Ensure this matches the key in your JSON
      productName: json['productName'],
      productPrice: json['productPrice'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() { 
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id; // Add this line
    data['productName'] = productName;
    data['productPrice'] = productPrice;
    data['imageUrl'] = imageUrl;
    return data;
  }
}
