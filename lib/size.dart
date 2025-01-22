import 'package:flutter/material.dart';

final double appbarIconSize = 16.0;
final double iconList = 16.0;
final double commonPadding = 16.0;
final double halfPadding = 8.0;
final double bottomIconSize = 20.0;

double getParentWith(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getBodyWidth(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.7;
}
