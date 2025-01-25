import 'package:flutter/material.dart';

import 'widgets/wish_body.dart';

class WishPage extends StatelessWidget {
  WishPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: WishBody());
  }
}
