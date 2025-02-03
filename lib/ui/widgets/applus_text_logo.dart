import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../_core/components/theme.dart';

class APPlusTextLogo extends StatelessWidget {
  double size;
  APPlusTextLogo({this.size = 25, super.key});

  @override
  Widget build(BuildContext context) {
    return Text('APPLUS',
        textAlign: TextAlign.left,
        style: GoogleFonts.bangers(
          fontSize: size,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: APlusTheme.primaryColor,
        ));
  }
}
