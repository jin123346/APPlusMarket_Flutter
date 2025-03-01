import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/gvm/product/productlist_gvm.dart';
import '../../../../data/model/product/product_info_card.dart';
import '../../product/product_view_page.dart';

class ProductListContainer extends ConsumerWidget {
  final ProductInfoCard product;
  final String price;
  ProductListContainer({required this.product, required this.price, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // 상품 클릭 시 상세 페이지로 이동
        ref.read(productListProvider.notifier).addRecent(product);

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
                    '$price 원',
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
  }
}
