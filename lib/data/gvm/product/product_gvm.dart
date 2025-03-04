import 'dart:io';

import 'package:applus_market/_core/utils/custom_snackbar.dart';
import 'package:applus_market/_core/utils/dialog_helper.dart';
import 'package:applus_market/data/gvm/product/productlist_gvm.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:applus_market/data/model/product/product_info_card.dart';
import 'package:applus_market/data/model/product/selected_product.dart';
import 'package:applus_market/data/repository/product/product_repository.dart';
import 'package:applus_market/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/exception_handler.dart';
import '../../../_core/utils/logger.dart';

// 상품 등록 , 상품 상세 화면
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
      selectedProduct: null,
      location: null,
      findProduct: null,
      isWished: false,
    );
  }

  //상품 등록
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
    String? selectedProduct,
    String brand,
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
        'brand': brand,
        'findProductId': selectedProduct ?? null,
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
      //상품 등록에 성공 했을때 /home 화면으로 이동을 합니다.
      Navigator.popAndPushNamed(mContext, '/home');
      // 또한 isRefresh를 true 로 전달 하여 페이지 번호를 1로 리셋 하도록 수정 하였습니다.
      // ref.read(productListProvider.notifier).fetchProducts(isRefresh: true);
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('서버 연결 실패', stackTrace);
    }
  }

  //상품 상세 정보 선택
  Future<ProductInfoCard?> selectProduct(int productId) async {
    try {
      //선택된 상품 아이디를 검색
      SessionUser? user = ref.read(LoginProvider);
      final responseBody = await productRepository.selectProduct(
          id: productId, userId: user?.id);
      logger.e("responseBody: $responseBody['status']");
      if (responseBody['status'] == 'success') {
        //응답된 결과사 성공일 경우 전달 받은 데이터를 todata를 이용해 데이터를 변환 해줍니다.
        // 그리고 전환된 데이터를 state에 전달 하여 바로 사용 가능 하도록 만들었습니다.
        state = ProductInfoCard.todata(responseBody['data']);

        //
      } else {
        throw Exception(responseBody['message']);
      }
    } catch (e) {
      print('상품 정보 불러오기 실패: $e');
      Navigator.pop(mContext);
      //ref.read(productListProvider.notifier).fetchProducts(isRefresh: true);
      return null;
    }
  }

  Future<void> updateWishList(int productId, int userId) async {
    try {
      Map<String, dynamic> resBody =
          await productRepository.updateWishList(productId, userId);
      if (resBody['status'] == 'failed') {
        CustomSnackbar.showSnackBar(resBody['message']);
        return;
      }

      state = state.copyWith(isWished: !state.isWished!);

      DialogHelper.showAlertDialog(
          context: mContext, title: '성공', content: resBody['message']);
    } catch (e, stackTrace) {
      ExceptionHandler.handleException(e, stackTrace);
    }
  }

  void findSelectedProduct() {}

  void updateSelectedProduct() {}
}

final productProvider = NotifierProvider<ProductGvm, ProductInfoCard>(
  () => ProductGvm(),
);
