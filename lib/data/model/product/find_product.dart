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
  String? goodsId;

  FindProduct({
    required this.id,
    required this.name,
    required this.productCode,
    required this.productDetailCode,
    required this.originalPrice,
    required this.finalPrice,
    required this.productUrl,
    required this.brandName,
    required this.goodsId,
  });

  factory FindProduct.fromMap(Map<String, dynamic> map) {
    return FindProduct(
      id: map['id'],
      name: map['name'],
      productCode: map['productCode'] as String,
      productDetailCode: map['productDetailCode'] as String,
      originalPrice: map['originalPrice'] ?? 0,
      finalPrice: map['finalPrice'] ?? 0,
      productUrl: map['productUrl'] as String,
      brandName: map['brandName'] as String,
      goodsId: map['goodsId'] ?? null,
    );
  }

  @override
  String toString() {
    return 'FindProduct{id: $id, name: $name, productCode: $productCode, productDetailCode: $productDetailCode, originalPrice: $originalPrice, finalPrice: $finalPrice, productUrl: $productUrl, brandName: $brandName, categoryName: $categoryName}';
  }
}
