import 'package:applus_market/_core/utils/dialog_helper.dart';
import 'package:applus_market/data/model/product/product.dart';
import 'package:applus_market/data/repository/product/product_repository.dart';
import 'package:applus_market/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/logger.dart';
import '../../gvm/session_gvm.dart';
import '../../model/auth/login_state.dart';

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

      Map<String, dynamic> data = resBody['data'];
      logger.i(state);

      state = Product.fromJson(data);
      isLoading = false;
      return;
    } catch (e) {
      print('상품 정보 불러오기 실패: $e');
      Navigator.pop(mContext);
      return;
    }
  }
}

final productModifyProvider = NotifierProvider<ProductModifyVM, Product>(
  () => ProductModifyVM(),
);
