import 'package:applus_market/_core/utils/custom_snackbar.dart';
import 'package:applus_market/_core/utils/exception_handler.dart';
import 'package:applus_market/data/model/product/category.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/dio.dart';
import '../../../_core/utils/logger.dart';

class CategoryVM extends Notifier<List<Category>> {
  @override
  List<Category> build() {
    return [];
  }

  Future<void> getAllCategory() async {
    try {
      Response response = await dio.get('/product/category/all');
      Map<String, dynamic> resBody = response.data;
      logger.i(resBody);

      List<dynamic> data = resBody['data'];
      logger.i(data);

      state = data
          .map(
            (e) => Category.fromMap(e),
          )
          .toList();
      return;
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('조회 중 오류', stackTrace);
    }
  }
}

final categoryProvider = NotifierProvider<CategoryVM, List<Category>>(
  () {
    return CategoryVM();
  },
);
