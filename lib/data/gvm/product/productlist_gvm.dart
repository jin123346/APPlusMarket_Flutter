import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../_core/utils/exception_handler.dart';
import '../../../_core/utils/logger.dart';
import '../../model/product/product_info_card.dart';
import '../../repository/product/product_repository.dart';

class ProductListGvm extends StateNotifier<List<ProductInfoCard>> {
  final ProductRepository productRepository = ProductRepository();
  int _currentPage = 1;
  bool _isFetching = false;
  bool _hasMore = true; // 추가: 더 가져올 데이터가 있는지 여부
  bool get isFetching => _isFetching;
  bool get hasMore => _hasMore;
  ProductListGvm() : super([]) {
    fetchProducts(); // 초기 로드
  }

  // DB에서 상품 목록 가져오기 (페이징 처리)
  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (_isFetching || !_hasMore) return; // 이미 요청 중이거나 더 불러올 데이터가 없다면 return
    _isFetching = true;
    try {
      if (isRefresh) {
        _currentPage = 1;
        state = [];
      }
      final responseBody =
          await productRepository.getProductsPage(page: _currentPage);
      logger.i('responseBody : $responseBody');

      if (responseBody['status'] != 'success') {
        ExceptionHandler.handleException(
            responseBody['message'], StackTrace.current);
        return;
      }
      final List<ProductInfoCard> productList = (responseBody['data'] as List)
          .map((item) => ProductInfoCard.fromJson(item))
          .toList();

      if (productList.isNotEmpty) {
        state = [...state, ...productList]; // 기존 데이터에 추가
        _currentPage++; // 다음 페이지 번호 증가
      } else {
        _hasMore = false; // 더 이상 불러올 데이터가 없음
      }
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('상품 목록 불러오기 실패', stackTrace);
    } finally {
      _isFetching = false;
    }
  }
}

final productListProvider =
    StateNotifierProvider<ProductListGvm, List<ProductInfoCard>>(
  (ref) => ProductListGvm(),
);
