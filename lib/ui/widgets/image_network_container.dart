import 'dart:ui';

import 'package:applus_market/_core/utils/apiUrl.dart';
import 'package:flutter/material.dart';

//이미지의 가로, 세로, radius, url,

class ImageNetworkContainer extends StatelessWidget {
  final double borderRadius;
  final String imgUri;
  final double width;
  final double height;
  final bool isNull;

  const ImageNetworkContainer(
      {required this.borderRadius,
      required this.imgUri,
      required this.width,
      required this.height,
      this.isNull = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imgUri, // Use dynamic API URL
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          defaultProfile,
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
