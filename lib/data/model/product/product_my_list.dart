import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ProductMyList {
  int? id;
  String? title;
  String? productImage;
  String? productName;
  String? createdAt;
  String? updatedAt;
  int? price;
  String? status;
  bool? isNegotiable;
  bool? isPossibleMeetYou;
  String? category;
  int? sellerId;
  String? registerLocation;
  String? uuidName;

  ProductMyList({
    required int? id,
    required String? title,
    required String? productImage,
    required String? productName,
    required String? createdAt,
    required String? updatedAt,
    required int? price,
    required String? status,
    required bool? isNegotiable,
    required bool? isPossibleMeetYou,
    required String? category,
    required int? sellerId,
    required String? registerLocation,
    required String? uuidName,
  });

  ProductMyList copyWith({
    int? id,
    String? title,
    String? productImage,
    String? productName,
    String? createdAt,
    String? updatedAt,
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
    return ProductMyList(
      id: json['id'],
      title: json['title'],
      productImage: json['productImage'],
      productName: json['productName'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      price: json['price'],
      status: json['status'],
      isNegotiable: json['isNegotiable'],
      isPossibleMeetYou: json['isPossibleMeetYou'],
      category: json['category'],
      registerLocation: json['registerLocation'],
      sellerId: json['sellerId'],
      uuidName: json['uuidName'],
    );
  }
}
