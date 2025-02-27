import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../_core/utils/exception_handler.dart';
import '../../../_core/utils/logger.dart';
import '../../model/product/product_info_card.dart';
import '../../repository/product/product_repository.dart';
import 'package:uuid/uuid.dart';

// 상품 리스트 출력 기능
class ProductListGvm extends StateNotifier<List<ProductInfoCard>> {
  final ProductRepository productRepository = ProductRepository();
  final Ref ref;

  int _currentPage = 1;
  bool _isFetching = false;
  bool _hasMore = true; // 추가: 더 가져올 데이터가 있는지 여부
  bool get isFetching => _isFetching;
  bool get hasMore => _hasMore;
  ProductListGvm(this.ref) : super([]) {
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

  Future<void> addRecent(ProductInfoCard product) async {
    try {
      logger.i('최근 본 상품 저장 : $product');
      int? userId = ref.read(LoginProvider).id;
      String? tmpUserId = null;
      if (userId == null) {
        tmpUserId = await getTemporaryUserId();
      }

      Map<String, dynamic> data = {
        "userId": userId ?? null,
        "tmpUserId": tmpUserId ?? null,
        "productId": product.product_id,
        "title": product.title,
        "thumbnailImage": product.images!.first,
        "price": product.price,
      };

      await productRepository.pushRecentProducts(data);
    } catch (e, stackTrace) {
      logger.e('$e $stackTrace');
    }
  }

  // UUID 생성
  Future<String> getTemporaryUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tempUserId = prefs.getString('tempUserId');

    // UUID가 없으면 새로 생성
    if (tempUserId == null) {
      var uuid = Uuid();
      tempUserId = uuid.v4();
      await prefs.setString('tempUserId', tempUserId);
    }

    return tempUserId;
  }

  Future<void> showRecentProduct() async {
    int? userId = ref.read(LoginProvider).id;
    String? tmpUserId = null;
    if (userId == null) {
      tmpUserId = await getTemporaryUserId();
    }
  }
}

final productListProvider =
    StateNotifierProvider<ProductListGvm, List<ProductInfoCard>>(
  (ref) => ProductListGvm(ref),
);
