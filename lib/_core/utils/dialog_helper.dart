import 'package:flutter/material.dart';

class DialogHelper {
  static void showAlertDialog({
    required BuildContext context,
    required String title,
    String? content,
    String confirmText = '확인',
    VoidCallback? onConfirm,
  }) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              title: Center(child: Text(title)),
              content: Center(child: Text(content ?? '')),
              contentPadding: EdgeInsets.zero,
              actions: [
                TextButton(
                    onPressed: onConfirm ??
                        () {
                          Navigator.pop(context);
                        },
                    child: Text(confirmText)),
              ],
              actionsAlignment: MainAxisAlignment.center,
            ));
  }
}
