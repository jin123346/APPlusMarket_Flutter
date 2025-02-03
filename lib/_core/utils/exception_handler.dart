import 'package:flutter/material.dart';

import '../../main.dart';
import 'logger.dart';

class ExceptionHandler {
  static void handleException(dynamic exception, StackTrace stackTrace) {
    logger.e('Exception : $exception');
    logger.e('StackTrace : $stackTrace');

    final mContext = navigatorkey.currentContext;
    if (mContext == null) return;

    // 시스템 키보드가 있다면 내려 주자
    FocusScope.of(mContext).unfocus();

    ScaffoldMessenger.of(mContext).showSnackBar(
      SnackBar(
        content: Text(
          exception.toString(),
        ),
      ),
    );
  }
}
