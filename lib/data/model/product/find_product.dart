class FindProduct {
  String? id;
  String? name;
  String? productCode;
  String? productDetailCode;
  double? originalPrice;
  double? finalPrice;
  String? productUrl;
  String? brandName;
  String? categoryName;

  FindProduct({
    required this.id,
    required this.name,
    required this.productCode,
    required this.productDetailCode,
    required this.originalPrice,
    required this.finalPrice,
    required this.productUrl,
    required this.brandName,
  });

  factory FindProduct.fromMap(Map<String, dynamic> map) {
    return FindProduct(
        id: map['id'],
        name: map['name'],
        productCode: map['productCode'],
        productDetailCode: map['productDetailCode'],
        originalPrice: map['originalPrice'],
        finalPrice: map['finalPrice'],
        productUrl: map['productUrl'],
        brandName: map['brandName']);
  }
}
