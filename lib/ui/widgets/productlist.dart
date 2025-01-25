import 'package:flutter/material.dart';

import '../../data/model/product/product_card.dart';
import '../pages/product/product_view_page.dart';

class ProductList extends StatelessWidget {
  final List<ProductCard> products;

  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
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
              onDoubleTap: () {
                // 더블 클릭시 ProductViewPage로 이동하면서 product_id 전달
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductViewPage(productId: product.product_id),
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
                          product.thumbnail_image,
                          fit: BoxFit.cover,
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
          childCount: products.length,
        ),
      ),
    );
  }
}
