import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../_core/utils/logger.dart';

class ProductMyList {
  int? id;
  String? title;
  String? productImage;
  String? productName;
  String? createdAt;
  String? updatedAt;
  String? reloadAt;
  int? price;
  String? status;
  bool? isNegotiable;
  bool? isPossibleMeetYou;
  String? category;
  int? sellerId;
  String? registerLocation;
  String? uuidName;

  ProductMyList({
    required this.id,
    required this.uuidName,
    required this.productName,
    required this.productImage,
    required this.createdAt,
    required this.updatedAt,
    required this.reloadAt,
    required this.price,
    required this.status,
    required this.isPossibleMeetYou,
    required this.sellerId,
    required this.registerLocation,
    required this.category,
    required this.isNegotiable,
    required this.title,
  });

  ProductMyList copyWith({
    int? id,
    String? title,
    String? productImage,
    String? productName,
    String? createdAt,
    String? updatedAt,
    String? reloadAt,
    int? price,
    String? status,
    bool? isNegotiable,
    bool? isPossibleMeetYou,
    String? category,
    int? sellerId,
    String? registerLocation,
    String? uuidName,
  }) {
    return ProductMyList(
      id: id ?? this.id,
      title: title ?? this.title,
      productImage: productImage ?? this.productImage,
      productName: productName ?? this.productName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reloadAt: reloadAt ?? this.reloadAt,
      price: price ?? this.price,
      status: status ?? this.status,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      isPossibleMeetYou: isPossibleMeetYou ?? this.isPossibleMeetYou,
      category: category ?? this.category,
      registerLocation: registerLocation ?? this.registerLocation,
      sellerId: sellerId ?? this.sellerId,
      uuidName: uuidName ?? this.uuidName,
    );
  }

  factory ProductMyList.fromMap(Map<String, dynamic> json) {
    logger.i('들어온 Json $json');
    return ProductMyList(
      id: json["id"] ?? 0,
      title: json["title"] ?? "No Title",
      productImage: json["productImage"] ?? "", // Default to empty string
      productName: json["productName"] ?? "No Name",
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      reloadAt: json['reloadAt'] ?? '',
      price: json['price'] ?? 0.0,
      status: json['status'] ?? 'Unknown',
      isNegotiable: json['isNegotiable'] ?? false,
      isPossibleMeetYou: json['isPossibleMeetYou'] ?? false,
      category: json['category'] ?? 'Unknown',
      registerLocation: json['registerLocation'] ?? 'Unknown',
      sellerId: json['sellerId'] ?? 0,
      uuidName: json['uuidName'] ?? "",
    );
  }

  @override
  String toString() {
    return 'ProductMyList{id: $id, title: $title, productImage: $productImage, productName: $productName, createdAt: $createdAt, updatedAt: $updatedAt, price: $price, status: $status, isNegotiable: $isNegotiable, isPossibleMeetYou: $isPossibleMeetYou, category: $category, sellerId: $sellerId, registerLocation: $registerLocation, uuidName: $uuidName}';
  }
}
