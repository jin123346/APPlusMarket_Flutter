import 'package:applus_market/_core/components/size.dart';
import 'package:applus_market/ui/widgets/applus_text_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../_core/utils/logger.dart';
import '../../../../data/model/product/product_card.dart';
import '../../../../data/model_view/product/product_wish_view_model.dart';
import '../../my/widgets/product_container.dart';
import '../wish_list_page.dart';
import 'wish_tabbar.dart';

class WishBody extends ConsumerStatefulWidget {
  const WishBody({super.key});

  @override
  ConsumerState<WishBody> createState() => _WishBodyState();
}

class _WishBodyState extends ConsumerState<WishBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('관심 상품'),
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            icon: Icon(Icons.arrow_back_ios)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(child: Text('찜 목록')),
            Tab(child: Text('최근 본 상품')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          WishListPage(),
          // GridView.builder(
          //   padding: EdgeInsets.all(5.0),
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     crossAxisSpacing: 5,
          //     mainAxisSpacing: 5,
          //   ),
          //   itemCount: products.length,
          //   itemBuilder: (context, index) {
          //     ProductCard product = products[index];
          //     return ProductContainer(price: product.price, name: product.name);
          //   },
          // ),
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
              return ProductContainer(price: product.price, name: product.name);
            },
          ),
        ],
      ),
    );
  }
}
