import 'package:flutter/material.dart';

import 'widgets/product_register_body.dart';

class ProductRegisterPage extends StatelessWidget {
  const ProductRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductRegisterBody(),
    );
  }
}
