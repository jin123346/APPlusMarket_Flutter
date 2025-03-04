import 'package:applus_market/_core/utils/exception_handler.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/product/product_card.dart';
import 'package:applus_market/data/model/product/product_info_card.dart';
import 'package:applus_market/data/repository/product/product_repository.dart';
import 'package:applus_market/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/logger.dart';

class ProductRecentVM extends Notifier<List<ProductCard>> {
  final mContext = navigatorkey.currentContext!;
  final ProductRepository productRepository = const ProductRepository();
  @override
  List<ProductCard> build() {
    return [];
  }
  //관심상품 리스트 불러오기

  Future<void> getMyRecentList() async {
    logger.i('최근 본 상품 조회시작');
    try {
      Map<String, dynamic> resBody = await productRepository.getMyRecentList();
      logger.i('최근 본 상품 결과 : $resBody');

      if (resBody['data'] == null) {
        state = [];
        return;
      }
      List<dynamic> list = resBody['data'];
      logger.i(list);

      state = list.map((e) => ProductCard.fromRedis(e)).toList();
      logger.i(state);
    } catch (e, stackTrace) {
      ExceptionHandler.handleException(e, stackTrace);
    }
  }

  //최근본 상품 리스트 불러오기
}

final productRecentProvider =
    NotifierProvider<ProductRecentVM, List<ProductCard>>(
  () => ProductRecentVM(),
);
