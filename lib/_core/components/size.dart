import 'package:flutter/material.dart';

const double appbarIconSize = 16.0;
const double iconList = 16.0;
const double commonPadding = 16.0;
const double halfPadding = 8.0;
const double bottomIconSize = 20.0;

const double spaceM = 16.0;
const double space16 = 16.0;
const double spaceS = 8.0;
const double space8 = 8.0;
const double space32 = 32.0;
const double spaceL = 32.0;

double getParentWith(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getBodyWidth(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.7;
}
