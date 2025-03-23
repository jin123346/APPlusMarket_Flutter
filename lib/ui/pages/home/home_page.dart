import 'package:applus_market/data/model/product/ProductList.dart';
import 'package:applus_market/data/repository/chat/chat_repository.dart';
import 'package:applus_market/data/model/auth/my_position.dart';
import 'package:applus_market/ui/pages/home/widgets/home_banner.dart';
import 'package:applus_market/ui/pages/home/widgets/product_brand_list.dart';
import 'package:applus_market/ui/pages/home/widgets/product_home_appbar.dart';
import 'package:applus_market/ui/pages/home/widgets/product_list_container.dart';
import 'package:applus_market/ui/pages/home/widgets/product_search_bar.dart';
import 'package:applus_market/ui/widgets/productlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../_core/components/theme.dart';
import '../../../_core/utils/logger.dart';
import '../../../_core/utils/priceFormatting.dart';
import '../../../data/gvm/geo/location_gvm.dart';
import '../../../data/gvm/product/productlist_gvm.dart';
import '../../../data/model/product/brand.dart';
import '../../../data/model/product/product_info_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ChatRepository chatRepository = ChatRepository();
  final RefreshController _refreshController = RefreshController();
  late final TextEditingController textEditingController;

  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    TextEditingController();
    textEditingController.addListener(() {
      if (textEditingController.text.isEmpty) {
        // Clear search results when input is cleared
        ref.read(productListProvider.notifier).init();
      }
    });
  }

  void _onSearchChanged(String query) async {
    logger.i('_onSearchChanged 호출됨');
    if (textEditingController.text.isNotEmpty) {
      query = textEditingController.text;
      logger.i('_onSearchChanged 검색어  $query');
      await ref
          .read(productListProvider.notifier)
          .searchProducts(keyword: query);
      _refreshController.refreshCompleted();
    }
  }

  // 새로고침 함수 추가
  Future<void> _refresh() async {
    // 새로고침 시 데이터를 다시 불러오는 로직 추가
    await ref.read(productListProvider.notifier).init();
    _refreshController.refreshCompleted();
  }

  void nextList() async {
    await ref.read(productListProvider.notifier).fetchProducts();
  }

  @override
  void dispose() {
    textEditingController.clear();
    textEditingController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 브랜드 목록 예시

    // productListProvider 상태 구독
    final ProductListModel? model = ref.watch(productListProvider);
    final ProductListGvm vm = ref.read(productListProvider.notifier);
    final bool isSearching = textEditingController.text.isNotEmpty;

    return Scaffold(
      appBar: ProductHomeAppbar(),
      body: SmartRefresher(
        onRefresh: () async {
          await vm.init(keyword: textEditingController.text);
          _refreshController.refreshCompleted();
        },
        controller: _refreshController,
        enablePullUp: model != null && !model.isLast,
        enablePullDown: true,
        onLoading: () async {
          if (isSearching) {
            await vm.searchProducts(
                keyword: textEditingController.text,
                page: model!.page + 1 ?? 0);
          }
          if (model != null && model.isLast) {
            _refreshController.loadNoData(); // 마지막
            return; // 더 이상 요청 X
          } else {
            await vm.fetchProducts();
          }

          _refreshController.loadComplete();
        },

        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  ProductSearchBar(
                      onSubmitted: _onSearchChanged,
                      textEditingController: textEditingController),
                ],
              ),
            ),
            if (!isSearching)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    HomeBanner(),
                    ProductBrandList(),
                  ],
                ),
              ),
            if (isSearching)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Center(
                          child: Text('검색어 : "${textEditingController.text}"')),
                    ],
                  ),
                ),
              ),
            if (model == null)
              SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = model.products[index];
                      final price = formatPrice(product.price!);
                      return ProductListContainer(
                          product: product, price: price);
                    },
                    childCount: model.products.length,
                  ),
                ),
              ),
          ],
        ),
        // child: SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       // 검색창 영역
        //       ProductSearchBar(),
        //       // 배너 영역
        //       HomeBanner(),
        //       // 브랜드 리스트 영역
        //       ProductBrandList(),
        //       // 상품 목록 영역
        //
        //       // 상품 목록 (PagedListView 사용)
        //       (model == null)
        //           ? Center(child: CircularProgressIndicator())
        //           : GridView.builder(
        //               padding: EdgeInsets.symmetric(vertical: 16.0),
        //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //                 crossAxisCount: 2,
        //                 childAspectRatio: 0.75,
        //                 mainAxisSpacing: 16,
        //                 crossAxisSpacing: 16,
        //               ),
        //               itemBuilder: (context, index) {
        //                 final product = model.products[index];
        //                 final price = formatPrice(product.price!);
        //                 return ProductListContainer(
        //                     product: product, price: price);
        //               },
        //               itemCount: model.products.length,
        //             )
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
