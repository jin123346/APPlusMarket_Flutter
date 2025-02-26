/*
* 2025.01.21 - 황수빈 : ProductCard 모델링 클래스
*
*/

import 'package:applus_market/_core/utils/apiUrl.dart';

class ProductCard {
  final int productId;
  final String name; // title
  final int price;
  final String thumbnailImage;
  final bool? isNegotiable; // 필수값 아님

  ProductCard(
      {required this.productId,
      required this.name,
      required this.price,
      required this.thumbnailImage,
      this.isNegotiable});

  factory ProductCard.fromJson(Map<String, dynamic> json) {
    return ProductCard(
      productId: json['productId'],
      name: json['productName'],
      price: json['price'],
      thumbnailImage:
          '$apiUrl/uploads/${json['productId']}/${json['thumbnailImage']}',
      isNegotiable: json['isNegotiable'] ?? '',
    );
  }

  factory ProductCard.fromMap(Map<String, dynamic> json) {
    return ProductCard(
      productId: json['id'],
      name: json['title'],
      price: json['price'],
      thumbnailImage: '$apiUrl/uploads/${json['id']}/${json['productImage']}',
    );
  }

  @override
  String toString() {
    return 'ProductCard{productId: $productId, name: $name, price: $price, thumbnailImage: $thumbnailImage, isNegotiable: $isNegotiable}';
  }
}

List<ProductCard> products = [
  ProductCard(
      isNegotiable: true,
      productId: 1,
      name: '맥북 프로 14 2024년형 새상품 팝니다',
      price: 3000000,
      thumbnailImage: 'https://picsum.photos/id/910/200/100'),
  ProductCard(
      isNegotiable: true,
      productId: 1,
      name: '맥북 프로 14 2024년형 새상품 팝니다',
      price: 3000000,
      thumbnailImage: 'https://picsum.photos/id/910/200/100'),
];
