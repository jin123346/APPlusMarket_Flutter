import 'package:applus_market/data/model/product/product_card.dart';
import 'package:applus_market/ui/pages/my/widgets/product_container.dart';
import 'package:applus_market/ui/widgets/productlist.dart';
import 'package:flutter/material.dart';

class WishTabbar extends StatefulWidget {
  const WishTabbar({super.key});

  @override
  State<WishTabbar> createState() => _WishTabbarState();
}

class _WishTabbarState extends State<WishTabbar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        TabBarView(
          controller: _tabController,
          children: [
            GridView.builder(
              padding: EdgeInsets.all(5.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                ProductCard product = products[index];
                return ProductContainer(
                    price: product.price, name: product.name);
              },
            ),
            GridView.builder(
              padding: EdgeInsets.all(5.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                ProductCard product = products[index];
                return ProductContainer(
                    price: product.price, name: product.name);
              },
            ),
          ],
        ),
      ],
    );
  }
}
