class SelectedProduct {
  String? id;
  String? name;
  String? productCode;
  String? productDetailCode;
  double? finalPrice;

  SelectedProduct(
      {required this.id,
      required this.name,
      required this.productCode,
      required this.productDetailCode,
      required this.finalPrice});

  factory SelectedProduct.fromMap(Map<String, dynamic> json) {
    return SelectedProduct(
        id: json['id'],
        name: json['name'],
        productCode: json['productCode'],
        productDetailCode: json['productDetailCode'],
        finalPrice: json['finalPrice']);
  }

  @override
  String toString() {
    return 'SelectedProduct{id: $id, name: $name, productCode: $productCode, productDetailCode: $productDetailCode, finalPrice: $finalPrice}';
  }
}
