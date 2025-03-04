import 'package:applus_market/data/model/product/product_card.dart';
import 'package:applus_market/data/model_view/product/product_wish_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/logger.dart';
import '../my/widgets/product_container.dart';
import '../product/product_view_page.dart';

class WishListPage extends ConsumerStatefulWidget {
  WishListPage({super.key});

  @override
  ConsumerState<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends ConsumerState<WishListPage> {
  bool isLoading = true;

  late List<ProductCard> wishLists;

  @override
  void initState() {
    wishLists = [];
    // TODO: implement initState
    super.initState();
    getMyList();
  }

  Future<void> getMyList() async {
    logger.i('관심상품 리스트 로직 시작');
    await ref.read(productWishProvider.notifier).getMyWishList();
    wishLists = ref.watch(productWishProvider);
    if (wishLists.isEmpty) {
      wishLists = [];
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
        : wishLists.isEmpty
            ? const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : GridView.builder(
                padding: EdgeInsets.all(5.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: wishLists.length,
                itemBuilder: (context, index) {
                  ProductCard product = wishLists[index];
                  return GestureDetector(
                    onTap: () {
                      // 상품 클릭 시 상세 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductViewPage(productId: product.productId),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  style: const TextStyle(fontSize: 14.5),
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
              );
  }
}
