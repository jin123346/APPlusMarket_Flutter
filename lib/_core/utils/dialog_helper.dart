import 'package:flutter/material.dart';

class DialogHelper {
  static void showAlertDialog({
    required BuildContext context,
    required String title,
    String? content,
    String confirmText = '확인',
    bool isCanceled = false,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              title: Center(child: Text(title)),
              content: content != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        content,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                  : null, // content가 없으면 공간을 차지하지 않도록 설정
              contentPadding: EdgeInsets.zero,
              actions: [
                Visibility(
                  visible: isCanceled,
                  child: TextButton(
                      onPressed: onCancel ??
                          () {
                            Navigator.pop(context);
                          },
                      child: Text('취소')),
                ),
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
