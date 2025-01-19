import 'package:flutter/material.dart';

double getParentWith(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getBodyWidth(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.7;
}
