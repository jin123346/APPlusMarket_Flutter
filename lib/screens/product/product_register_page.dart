import 'package:flutter/material.dart';

class ProductRegisterPage extends StatelessWidget {
  const ProductRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            Text('product Register page'),
          ],
        ),
      ),
    );
  }
}
