import 'package:applus_market/_core/utils/custom_snackbar.dart';
import 'package:applus_market/_core/utils/exception_handler.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:applus_market/data/repository/product/product_repository.dart';
import 'package:applus_market/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/product/product_my_list.dart';

class ProductMyListVM extends Notifier<List<ProductMyList>> {
  final ProductRepository productRepository = const ProductRepository();
  final mContext = navigatorkey.currentContext!;

  @override
  List<ProductMyList> build() {
    getMyOnSaleList(null);
    return [];
  }

  Future<void> getMyOnSaleList(int? lastIndex) async {
    try {
      SessionUser sessionUser = ref.read(LoginProvider);
      Map<String, dynamic> body = {
        "userId": sessionUser.id,
        "lastIndex": null,
        "pageSize": 10,
      };
      Map<String, dynamic> resBody =
          await productRepository.selectForMyList(body);

      if (resBody['status'] == 'failed') {
        CustomSnackbar.showSnackBar('${resBody['code']}:${resBody['message']}');
        return;
      }

      List<dynamic> data = resBody['data'];
      if (data.isEmpty) {
        return;
      }

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
}

final productMyLisProvider =
    NotifierProvider<ProductMyListVM, List<ProductMyList>>(
  () => ProductMyListVM(),
);
