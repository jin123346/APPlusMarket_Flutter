import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        Image.asset('assets/images/banner/main_banner_1.jpg'),
        const SizedBox(height: 20),
      ],
    );
  }
}
