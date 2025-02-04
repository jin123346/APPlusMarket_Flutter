import 'dart:io';

import 'package:applus_market/data/model/product/product_info_card.dart';
import 'package:applus_market/data/repository/product/product_repository.dart';
import 'package:applus_market/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../_core/utils/exception_handler.dart';
import '../../_core/utils/logger.dart';

class ProductGvm extends Notifier<ProductInfoCard> {
  final mContext = navigatorkey.currentContext!;
  final ProductRepository productRepository = ProductRepository();
  @override
  ProductInfoCard build() {
    return ProductInfoCard(
      product_id: null,
      title: null,
      product_name: null,
      images: null,
      content: null,
      updated_at: null,
      price: null,
      status: null,
      seller_id: null,
      is_negotiable: null,
      is_possible_meet_you: null,
      category: null,
    );
  }

  Future<void> insertproduct(
    String title,
    String productname,
    String content,
    String registerlocation,
    String registerip,
    int price,
    String sellerid,
    bool isnegotiable,
    bool ispossiblemeetyou,
    String category,
    List<File> imageFiles,
  ) async {
    try {
      final body = {
        'title': title,
        'productName': productname,
        'content': content,
        'registerLocation': registerlocation,
        'registerIp': registerip,
        'price': price,
        'sellerId': sellerid,
        'isNegotiable': isnegotiable,
        'isPossibleMeetYou': ispossiblemeetyou,
        'category': category,
      };
      logger.i('productName : ${productname}');
      final responseBody = await productRepository.insertProduct(
        body,
        imageFiles: imageFiles, // 이미지 파일 리스트 전달
      );
      logger.i('API 응답: $responseBody'); // 추가된 로그
      if (!responseBody['success']) {
        ExceptionHandler.handleException(
            responseBody['errorMessage'], StackTrace.current);
        return; // 실행의 제어건 반납
      }
      Navigator.popAndPushNamed(mContext, '/home');
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('서버 연결 실패', stackTrace);
    }
  }
}

final productProvider = NotifierProvider<ProductGvm, ProductInfoCard>(
  () => ProductGvm(),
);
