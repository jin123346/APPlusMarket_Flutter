import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/product/ProductList.dart';
import 'package:applus_market/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../_core/utils/exception_handler.dart';
import '../../../_core/utils/logger.dart';
import '../../model/product/product_info_card.dart';
import '../../repository/product/product_repository.dart';
import 'package:uuid/uuid.dart';

// 상품 리스트 출력 기능
class ProductListGvm extends AutoDisposeNotifier<ProductListModel?> {
  final ProductRepository productRepository = ProductRepository();
  final mContext = navigatorkey.currentContext!;

  bool _isFetching = false;
  bool _hasMore = true;
  bool _isLoding = false;
  bool get isFetching => _isFetching;
  bool get hasMore => _hasMore;

  @override
  ProductListModel? build() {
    ref.onDispose(
      () {
        logger.d('ProductListGvm dispose');
      },
    );
    init();

    return null;
  }

  Future<void> init({String? keyword}) async {
    try {
      Map<String, dynamic> resBody =
          await productRepository.getFirstList(keyword);
      if (resBody['status'] == 'failed') {
        ExceptionHandler.handleException(
            resBody['message'], StackTrace.current);
        return;
      }
      logger.i('resBody  ${resBody}');
      state = ProductListModel.fromMap(resBody['data']);
      logger.i('state  ${state!.products}');
    } catch (e, stackTrace) {
      logger.e('$e $stackTrace');
    }
  }

  Future<void> fetchProducts() async {
    if (state == null) return;

    if (state!.isLast) return;
    try {
      int newPage = state!.page + 1;
      logger.i('newPage : $newPage');
      Map<String, dynamic> resBody =
          await productRepository.getProductsPage(pageKey: newPage);
      logger.i('fetchProducts : $resBody');

      final newProducts = ProductListModel.fromMap(resBody['data']).products;

      // 기존 데이터 + 새로 불러온 데이터로 상태 업데이트
      state = state!.copyWith(
        isFirst: resBody['data']['isFirst'],
        isLast: resBody['data']['isLast'],
        products: [...state!.products, ...newProducts],
        page: resBody['data']['page'],
      );
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
      String? tmpUserId;
      if (userId == null) {
        tmpUserId = await getTemporaryUserId();
      }

      Map<String, dynamic> data = {
        "userId": userId,
        "tmpUserId": tmpUserId,
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

  Future<String> getTemporaryUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tempUserId = prefs.getString('tempUserId');

    if (tempUserId == null) {
      var uuid = Uuid();
      tempUserId = uuid.v4();
      await prefs.setString('tempUserId', tempUserId);
    }

    return tempUserId;
  }

  Future<void> searchProducts({required String keyword, int? page}) async {
    if (_isLoding) {
      logger.w('이미 검색 중이므로 요청을 무시함.');
      return;
    }
    logger.i('keyword : $keyword');
    _isLoding = true;

    try {
      Map<String, dynamic> resBody =
          await productRepository.searchProducts(keyword, page);
      logger.i('searchProducts : $resBody');

      if (resBody['status'] == 'failed') {
        _isLoding = false;
        return;
      }

      state = ProductListModel.fromMap(resBody['data']);
      logger.i('state  ${state!.products}');
    } catch (e, stackTrace) {
      logger.e('$e $stackTrace');
    } finally {
      _isLoding = false;
    }
  }
}

final productListProvider =
    NotifierProvider.autoDispose<ProductListGvm, ProductListModel?>(
  () => ProductListGvm(),
);
