import 'package:applus_market/data/model/product/product.dart';

class ProductImage {
  int? id; // PK (이미지 고유 번호)
  int? productId; // 상품 ID (FK)
  String? originalName; // 업로드된 실제 파일명
  String? uuidName; // 서버에서 저장할 고유 파일명
  int? sequence;

  ProductImage(
      {required this.id,
      required this.productId,
      required this.originalName,
      required this.uuidName,
      required this.sequence}); //이미지 순서

  factory ProductImage.fromMap(Map<String, dynamic> map) {
    return ProductImage(
      id: map['id'],
      productId: map['productId'],
      uuidName: map['uuidName'],
      originalName: map['originalName'],
      sequence: map['sequence'],
    );
  }
}
