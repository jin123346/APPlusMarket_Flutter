import 'package:applus_market/_core/utils/custom_snackbar.dart';
import 'package:applus_market/_core/utils/dialog_helper.dart';
import 'package:applus_market/_core/utils/exception_handler.dart';
import 'package:applus_market/data/model/product/selected_product.dart';
import 'package:applus_market/data/repository/product/product_repository.dart';
import 'package:applus_market/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/logger.dart';
import '../../gvm/search_event_notifier.dart';

class ProductSearchNotifier extends Notifier<List<SelectedProduct>> {
  final mContext = navigatorkey.currentContext!;
  final ProductRepository productRepository = const ProductRepository();
  SelectedProduct? currentSelected;
  int result = 0;
  @override
  List<SelectedProduct> build() {
    return [];
  }

  String? getCurrentSelected() {
    logger.i('선택된 값 : ${currentSelected?.id!}');
    return currentSelected?.id! ?? null;
  }

  Future<void> searchProducts(String keyword) async {
    if (keyword.isEmpty) {
      state = [];
      CustomSnackbar.showSnackBar('검색할 단어가 없습니다.');
      result = 0;
      return;
    }

    ref.read(searchEventProvider.notifier).searching();
    try {
      Map<String, dynamic> resBody =
          await productRepository.searchProductForSamsung(keyword);

      if (resBody['code'] == 3014) {
        logger.i('크롤링 진행중 ,,, ');
        int retry = 3;
        while (retry > 0) {
          await Future.delayed(const Duration(seconds: 2)); // 재시도 간격
          logger.i(" 크롤링 시도중 남은횟수 : $retry");
          resBody = await productRepository.searchProductForCheck(keyword);
          if (resBody['code'] != 3014) {
            break;
          }
          retry--;
        }
      }

      if (resBody['status'] == 'failed') {
        DialogHelper.showAlertDialog(
            context: mContext,
            title: 'errorCode : ${resBody['code']}',
            content: resBody['message']);
        result = 1;
        ref.read(searchEventProvider.notifier).completed();

        return;
      }

      if (resBody['code'] == 3011) {
        result = 2;
        ref.read(searchEventProvider.notifier).completed();
        return;
      }

      List<dynamic> data = resBody['data'];
      List<SelectedProduct> productList = data
          .map(
            (product) => SelectedProduct.fromMap(product),
          )
          .toList();

      result = 3;
      state = productList;
      ref.read(searchEventProvider.notifier).completed();

      return;
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('제품 정보가져오는 중 오류 발생', stackTrace);
      ref.read(searchEventProvider.notifier).completed();

      result = 5;
      return;
    }
  }

  void updateCurrentSelected(SelectedProduct se) {
    currentSelected = se;
    logger.i(currentSelected);
  }

  void reset() {
    state = [];
    currentSelected = null;
  }
}

final productSearchProvider =
    NotifierProvider<ProductSearchNotifier, List<SelectedProduct>>(
  () => ProductSearchNotifier(),
);
