/*
* 2025.01.22 - 이도영 : ProductInfoCard 모델링 클래스
*
*/
//상세 정보
import 'package:applus_market/data/model/product/find_product.dart';
import 'package:applus_market/data/model/product/product_image.dart';
import 'package:applus_market/data/model/product/selected_product.dart';

import '../../../_core/utils/apiUrl.dart';
import '../../../_core/utils/logger.dart';

class Product {
  final int? id; // 아이디
  final String? title; // 제목
  final String? productName; //제품명
  final String? content; // 내용
  final String? registerLocation; // 등록 위치
  final String? registerIp; // 등록 아이피
  final String? createdAt; // 생성 일자
  final String? updatedAt; // 업데이트 일자
  final int? price; // 가격
  final String? status; // 상태
  final String? deletedAt; // 삭제 일자
  final int? sellerId; // 판매자 아이디
  final String? nickname; //판매자 닉네임
  final bool? isNegotiable; // 네고 가능 여부
  final bool? isPossibleMeetYou; // 직거래 가능 여부
  final String? category; // 카테고리
  final String? brand; //브랜드
  final List<ProductImage>? images; // 이미지들
  final FindProduct? findProduct;
  final String? location;

  // 생성자
  Product({
    required this.id, // 아이디
    required this.title, // 제목
    required this.productName, //제품명
    required this.content, // 내용
    this.registerLocation, // 등록 위치
    required this.registerIp, // 등록 아이피
    required this.createdAt, // 생성 일자aa
    required this.updatedAt, // 업데이트 일자
    required this.price, // 가격
    required this.status, // 상태
    this.deletedAt, // 삭제 일자
    required this.sellerId, // 판매자 아이디
    required this.nickname, // 판매자 닉네임
    required this.isNegotiable, // 네고 가능 여부
    required this.isPossibleMeetYou, // 직거래 가능 여부
    required this.category, // 카테고리
    required this.brand, //브랜드
    required this.images, // 이미지들
    required this.findProduct,
    required this.location,
  });

  Product copyWith({
    int? id, // 아이디
    String? title, // 제목
    String? productName, //제품명
    String? content, // 내용
    String? registerLocation, // 등록 위치
    String? registerIp, // 등록 아이피
    String? createdAt, // 생성 일자
    String? updatedAt, // 업데이트 일자
    int? price, // 가격
    String? status, // 상태
    String? deletedAt, // 삭제 일자
    int? sellerId, // 판매자 아이디
    String? nickname, //판매자 닉네임
    bool? isNegotiable, // 네고 가능 여부
    bool? isPossibleMeetYou, // 직거래 가능 여부
    String? category, // 카테고리
    String? brand, //브랜드
    List<ProductImage>? images, // 이미지들
    FindProduct? findProduct,
    String? location,
  }) {
    return Product(
        id: id ?? this.id,
        title: title ?? this.title,
        productName: productName ?? this.productName,
        content: content ?? this.content,
        registerIp: registerIp ?? this.registerIp,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        price: price ?? this.price,
        status: status ?? this.status,
        sellerId: sellerId ?? this.sellerId,
        nickname: nickname ?? this.nickname,
        isNegotiable: isNegotiable ?? this.isNegotiable,
        isPossibleMeetYou: isPossibleMeetYou ?? this.isPossibleMeetYou,
        category: category ?? this.category,
        brand: brand ?? this.brand,
        images: images ?? this.images,
        findProduct: findProduct ?? this.findProduct,
        location: location ?? this.location);
  }

  // 수정된 toString() 메서드
  @override
  String toString() {
    return 'Product {'
        'product_id: $id, '
        'title: $title, '
        'product_name : $productName,'
        'images: $images, '
        'content: $content, '
        'register_location: $registerLocation, '
        'updated_at: $updatedAt, '
        'price: $price, '
        'status: $status, '
        'seller_id: $sellerId, '
        'is_negotiable: $isNegotiable, '
        'is_possible_meet_you: $isPossibleMeetYou, '
        'category: $category,'
        'brand: $brand}';
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    List<dynamic> productImage = json['images'];
    List<ProductImage> images = productImage
        .map(
          (e) => ProductImage.fromMap(e),
        )
        .toList();

    FindProduct? findProduct = json['findProduct'] != null
        ? FindProduct.fromMap(json['findProduct'])
        : null;
    return Product(
      id: json['id'] as int?,
      title: json['title'] as String?,
      productName: json['productName'] as String?,
      content: json['content'] as String?,
      registerLocation: json['registerLocation'] as String?,
      registerIp: json['registerIp'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      price: json['price'] as int?,
      status: json['status'] as String?,
      deletedAt: json['deletedAt'] as String?,
      sellerId: json['sellerId'] as int?,
      nickname: json['nickName'] as String?,
      isNegotiable: json['isNegotiable'] as bool?,
      isPossibleMeetYou: json['isPossibleMeetYou'] as bool?,
      category: json['category'] as String?,
      brand: json['brand'] as String?,
      images: images,
      findProduct: findProduct,
      location: null,
    );
  }
}
