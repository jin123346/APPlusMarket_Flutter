import 'dart:convert';
import 'dart:io';

import 'package:applus_market/_core/utils/custom_snackbar.dart';
import 'package:applus_market/_core/utils/dialog_helper.dart';
import 'package:applus_market/_core/utils/exception_handler.dart';
import 'package:applus_market/data/model/product/product.dart';
import 'package:applus_market/data/repository/product/product_repository.dart';
import 'package:applus_market/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/logger.dart';
import '../../gvm/session_gvm.dart';
import '../../model/auth/login_state.dart';
import '../../model/product/product_image.dart';
import 'image_item_view_model.dart';

class ProductModifyVM extends Notifier<Product> {
  final ProductRepository productRepository = const ProductRepository();
  final mContext = navigatorkey.currentContext!;
  bool isLoading = true; // 🔹 로딩 상태 추가

  @override
  build() {
    // TODO: implement build
    return Product(
        id: null,
        title: null,
        productName: null,
        content: null,
        registerIp: null,
        createdAt: null,
        updatedAt: null,
        price: null,
        status: null,
        sellerId: null,
        nickname: null,
        isNegotiable: null,
        isPossibleMeetYou: null,
        category: null,
        brand: null,
        images: null,
        findProduct: null,
        location: null);
  }

  //가져오기
//상품 수정시 셋팅
  Future<void> selectModifyProduct(int productId) async {
    try {
      //선택된 상품 아이디를 검색
      isLoading = true;
      SessionUser user = ref.read(LoginProvider);
      final resBody =
          await productRepository.getProductForModify(productId, user.id!);

      if (resBody['status'] == 'failed') {
        return DialogHelper.showAlertDialog(
            context: mContext, title: '잘못된 경로입니다.');
      }
      if (resBody['data'] == null) {
        logger.w('여기서 걸림');
        return;
      }
      Map<String, dynamic> data = resBody['data'];

      state = Product.fromJson(data);

      logger.i(state);

      isLoading = false;
      return;
    } catch (e, stackTrace) {
      print('상품 정보 불러오기 실패: $e , $stackTrace');
      Navigator.pop(mContext);
      return;
    }
  }

  Future<void> modifyProduct({
    required int id, // 아이디
    required String title, // 제목
    required String productName, //제품명
    required String content, // 내용
    required String price, // 가격
    required bool isNegotiable, // 네고 가능 여부
    required bool isPossibleMeetYou, // 직거래 가능 여부
    required String category, // 카테고리
    required String brand, //브랜드
    required String findProduct,
    List<ProductImage>? images, // 기존 이미지
  }) async {
    try {
      if (id == null ||
          title == null ||
          productName == null ||
          content == null ||
          price == null) {
        return CustomSnackbar.showSnackBar('모든 정보를 작성해주세요');
      }
      SessionUser user = ref.read(LoginProvider);
      final imageProvider = ref.read(imageStateProvider.notifier);
      Map<String, dynamic> imageState =
          await imageProvider.getImagesForUpdate();

      final Map<String, dynamic> jsonData = {
        "id": id,
        "title": title,
        "productName": productName,
        "content": content,
        "price": price,
        "isNegotiable": state.isNegotiable,
        "isPossibleMeetYou": state.isPossibleMeetYou,
        "category": category,
        "brand": brand,
        "findProduct": findProduct,
        "existingImages": imageState['existingImages'],
        "removedImages": imageState['removedImages'],
      };

      // Properly handle image updates
      final formData = FormData.fromMap({
        "data": jsonEncode(jsonData), // JSON 데이터를 문자열로 변환
      });

      // 새로운 이미지 파일들 추가
      if (imageState['newImages'] != null) {
        List<MultipartFile> newImageFiles = imageState['newImages'];
        for (int i = 0; i < newImageFiles.length; i++) {
          formData.files.add(
            MapEntry("newImages", newImageFiles[i]),
          );
        }
      }

      Map<String, dynamic> resBody =
          await productRepository.modifyProduct(id, user.id!, formData);

      imageProvider.reset();

      return;
    } catch (e, stackTrace) {
      ExceptionHandler.handleException(e, stackTrace);
    }
  }

  /// 🔹 상태 초기화 함수 추가
  void resetProduct() {
    state = Product(
        id: null,
        title: null,
        productName: null,
        content: null,
        registerIp: null,
        createdAt: null,
        updatedAt: null,
        price: null,
        status: null,
        sellerId: null,
        nickname: null,
        isNegotiable: null,
        isPossibleMeetYou: null,
        category: null,
        brand: null,
        images: null,
        findProduct: null,
        location: null);
    isLoading = true;
  }

  void updateMeetYou(bool? value) {
    state = state.copyWith(isPossibleMeetYou: value);
  }

  void updateIsNego(bool? value) {
    state = state.copyWith(isNegotiable: value);
  }
}

final productModifyProvider = NotifierProvider<ProductModifyVM, Product>(
  () => ProductModifyVM(),
);
