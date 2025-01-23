import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 150,
          height: 95,
        ),
        Positioned(
          top: -15,
          left: -50,
          child: Image.asset(
            width: 200,
            height: 150,
            'assets/applogo_logo_rd.png',
            fit: BoxFit.fitWidth,
          ),
        ),
      ],
    );
  }
}
