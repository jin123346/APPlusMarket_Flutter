import 'package:applus_market/ui/pages/product/widgets/product_modify_body.dart';
import 'package:flutter/material.dart';

import 'widgets/product_register_body.dart';

class ProductModifyPage extends StatelessWidget {
  const ProductModifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments;

    return (productId == null)
        ? Scaffold(
            body: Center(
              child: Text('수정할 제품이 없음'),
            ),
          )
        : Scaffold(
            body: ProductModifyBody(
              productId: productId as int,
            ),
          );
  }
}
