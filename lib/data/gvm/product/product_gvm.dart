import 'dart:io';

import 'package:applus_market/data/gvm/product/productlist_gvm.dart';
import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:applus_market/data/model/product/product_info_card.dart';
import 'package:applus_market/data/repository/product/product_repository.dart';
import 'package:applus_market/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/exception_handler.dart';
import '../../../_core/utils/logger.dart';

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
      nickname: null,
      is_negotiable: null,
      is_possible_meet_you: null,
      category: null,
      register_ip: null,
      created_at: null,
      brand: null,
    );
  }

  Future<void> insertproduct(
    String title,
    String productname,
    String content,
    String registerlocation,
    String registerip,
    int price,
    bool isnegotiable,
    bool ispossiblemeetyou,
    String category,
    int userid,
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
        'isNegotiable': isnegotiable,
        'isPossibleMeetYou': ispossiblemeetyou,
        'sellerId': userid,
        'category': category,
      };
      logger.i('productName : ${body}');
      final responseBody = await productRepository.insertProduct(
        body,
        imageFiles: imageFiles, // 이미지 파일 리스트 전달
      );
      logger.i('API 응답: $responseBody');
      if (responseBody['status'] != 'success') {
        ExceptionHandler.handleException(
            responseBody['errorMessage'], StackTrace.current);
        return; // 실행의 제어건 반납
      }

      Navigator.popAndPushNamed(mContext, '/home');
      ref.read(productListProvider.notifier).fetchProducts(isRefresh: true);
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('서버 연결 실패', stackTrace);
    }
  }

  Future<ProductInfoCard?> selectProduct(int productId) async {
    try {
      final responseBody = await productRepository.selectProduct(id: productId);
      logger.e("responseBody: $responseBody['status']");
      if (responseBody['status'] == 'success') {
        state = ProductInfoCard.todata(responseBody['data']);

        logger.e("Updated State: $state");
      } else {
        throw Exception(responseBody['message']);
      }
    } catch (e) {
      print('상품 정보 불러오기 실패: $e');
      Navigator.pop(mContext);
      ref.read(productListProvider.notifier).fetchProducts(isRefresh: true);
      return null;
    }
  }
}

final productProvider = NotifierProvider<ProductGvm, ProductInfoCard>(
  () => ProductGvm(),
);
