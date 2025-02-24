import 'package:applus_market/_core/utils/custom_snackbar.dart';
import 'package:applus_market/_core/utils/dialog_helper.dart';
import 'package:applus_market/_core/utils/exception_handler.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:applus_market/data/repository/product/product_repository.dart';
import 'package:applus_market/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/logger.dart';
import '../../model/product/product_my_list.dart';

class ProductMyListVM extends Notifier<List<ProductMyList>> {
  final ProductRepository productRepository = const ProductRepository();
  final mContext = navigatorkey.currentContext!;

  @override
  List<ProductMyList> build() {
    return [];
  }

  Future<void> getMyOnSaleList(int? lastIndex, String status) async {
    try {
      SessionUser sessionUser = ref.read(LoginProvider);
      Map<String, dynamic> body = {
        "userId": sessionUser.id,
        "lastIndex": null,
        "pageSize": 10,
        "status": status,
      };
      Map<String, dynamic> resBody =
          await productRepository.selectForMyList(body);

      if (resBody['status'] == 'failed') {
        CustomSnackbar.showSnackBar('${resBody['code']}:${resBody['message']}');
        return;
      }

      if (resBody['data'] == null) {
        state = List.empty();
        return;
      }

      List<dynamic> data = resBody['data'];

      logger.i("data 결과 : ${data}");

      List<ProductMyList> productList = data.map(
        (e) {
          return ProductMyList.fromMap(e);
        },
      ).toList();

      state = productList;

      return;
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('조회시 오류 발생, $e', stackTrace);
    }
  }

  Future<void> getMyCompletedList(int? lastIndex) async {
    try {
      SessionUser sessionUser = ref.read(LoginProvider);
      Map<String, dynamic> body = {
        "userId": sessionUser.id,
        "lastIndex": null,
        "pageSize": 10,
      };
      Map<String, dynamic> resBody =
          await productRepository.selectForMyCompletedList(body);

      if (resBody['status'] == 'failed') {
        CustomSnackbar.showSnackBar('${resBody['code']}:${resBody['message']}');
        return;
      }
      if (resBody['data'] == null) {
        state = List.empty();
        return;
      }

      List<dynamic> data = resBody['data'];

      logger.i("data 결과 : ${data}");

      List<ProductMyList> productList = data.map(
        (e) {
          return ProductMyList.fromMap(e);
        },
      ).toList();

      state = productList;

      return;
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('조회시 오류 발생, $e', stackTrace);
    }
  }

  //끌어올리기,
  Future<void> updateReload(int? productId) async {
    try {
      if (productId == null) {
        return CustomSnackbar.showSnackBar("선택된 끌어올리기 상품이 없습니다.");
      }
      Map<String, dynamic> resBody =
          await productRepository.reloadProduct(productId!);

      if (resBody['status'] == "failed") {
        return DialogHelper.showAlertDialog(
            context: mContext,
            title: '${resBody['code']} : ${resBody['message']}');
      }

      //상품 리로드 시키기 해야함
      await getMyOnSaleList(null, "Active");
      return DialogHelper.showAlertDialog(
          context: mContext, title: '끌어올리기 성공!');
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('조회시 오류 발생, $e', stackTrace);
    }
  }

  //숨김처리
  // 숨김해제
  Future<void> updateStatus(
      int? productId, String status, String message) async {
    try {
      if (productId == null) {
        return CustomSnackbar.showSnackBar("상태 변경 중 오류 발생");
      }
      Map<String, dynamic> resBody =
          await productRepository.updateStatus(productId, status);

      if (resBody['status'] == "failed") {
        return DialogHelper.showAlertDialog(
            context: mContext,
            title: '${resBody['code']} : ${resBody['message']}');
      }

      //상품 리로드 시키기 해야함

      state = state.where((product) => product.id != productId).toList();
      print(state);
      return DialogHelper.showAlertDialog(context: mContext, title: message);
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('조회시 오류 발생, $e', stackTrace);
    }
  }
}

final productMyLisProvider =
    NotifierProvider<ProductMyListVM, List<ProductMyList>>(
  () => ProductMyListVM(),
);
