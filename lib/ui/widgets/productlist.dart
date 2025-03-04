import 'package:applus_market/_core/utils/priceFormatting.dart';
import 'package:applus_market/data/model/product/product_info_card.dart';
import 'package:applus_market/ui/pages/home/widgets/product_list_container.dart';
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
    final products = ref.watch(productListProvider)!.products;

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
                  final price = formatPrice(product.price!);
                  return ProductListContainer(product: product, price: price);
                },
                childCount: products.length,
              ),
            ),
    );
  }
}
