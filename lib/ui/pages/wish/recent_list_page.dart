import 'package:applus_market/data/model/product/product_card.dart';
import 'package:applus_market/data/model_view/product/product_recent_view_model.dart';
import 'package:applus_market/data/model_view/product/product_wish_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/logger.dart';
import '../my/widgets/product_container.dart';
import '../product/product_view_page.dart';

class RecentListPage extends ConsumerStatefulWidget {
  RecentListPage({super.key});

  @override
  ConsumerState<RecentListPage> createState() => _WishListPageState();
}

class _WishListPageState extends ConsumerState<RecentListPage> {
  bool isLoading = true;

  late List<ProductCard> recentList;

  @override
  void initState() {
    recentList = [];
    // TODO: implement initState
    super.initState();
    getMyList();
  }

  Future<void> getMyList() async {
    logger.i('관심상품 리스트 로직 시작');
    await ref.read(productRecentProvider.notifier).getMyRecentList();
    recentList = ref.watch(productRecentProvider);
    if (recentList.isEmpty) {
      recentList = [];
      isLoading = false;
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : CustomScrollView(
            slivers: [
              recentList.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('최근 본 상품이 없습니다.'),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            ProductCard product = recentList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductViewPage(
                                      productId: product.productId,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          product.thumbnailImage,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${product.price} 원',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.name,
                                            style:
                                                const TextStyle(fontSize: 14.5),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: recentList.length,
                        ),
                      ),
                    ),
            ],
          );
  }
}
