import 'package:flutter/material.dart';

import '../../main.dart';

class CustomSnackbar {
  static void showSnackBar(String message) {
    final mContext = navigatorkey.currentContext!;
    ScaffoldMessenger.of(mContext).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white), // 텍스트 스타일 지정 가능
        ),
        behavior: SnackBarBehavior.floating, // 화면에서 떠있는 형태
        duration: Duration(seconds: 2), // 표시 시간
        backgroundColor: Colors.black87, // 배경 색상
      ),
    );
  }
}
