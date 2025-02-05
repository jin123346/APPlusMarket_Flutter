import 'package:applus_market/data/model/product/product_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/gvm/product/productlist_gvm.dart';
import '../pages/product/product_register_page.dart';
import '../pages/product/product_view_page.dart';

class ProductList extends ConsumerWidget {
  final List<ProductInfoCard> products;
  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Riverpod으로 상품 리스트 가져오기
    final products = ref.watch(productListProvider);

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: products.isEmpty
          ? const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            )
          : SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      // 상품 클릭 시 상세 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductViewPage(productId: product.product_id!),
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
                                product.images!.first,
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
                                  '${product.price}원',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.title!,
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
                childCount: products.length,
              ),
            ),
    );
  }
}
