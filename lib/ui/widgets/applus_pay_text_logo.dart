import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../_core/components/theme.dart';

class APPlusPayTextLogo extends StatelessWidget {
  double size;
  double spacing;
  APPlusPayTextLogo({this.size = 25, this.spacing = 1.0, super.key});

  @override
  Widget build(BuildContext context) {
    return Text('APPLUS PAY',
        textAlign: TextAlign.left,
        style: GoogleFonts.bangers(
          fontSize: size,
          fontWeight: FontWeight.w400,
          letterSpacing: spacing,
          color: APlusTheme.primaryColor,
        ));
  }
}
