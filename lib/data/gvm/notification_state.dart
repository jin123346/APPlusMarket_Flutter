import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../_core/utils/logger.dart';
import '../model/auth/login_state.dart';
import '../model/notification_item.dart';

class NotificationState extends Notifier<List<NotificationItem>> {
  @override
  List<NotificationItem> build() {
    return [];
  }

  void addNotification(NotificationItem item) {
    logger.i("알림 추가 로직");
    state = [
      ...state,
      item,
    ];
    logger.i(
      "알림 추가 ${state}",
    );
  }

  void addNotifications(List<NotificationItem> items) {
    state = [...state, ...items];
  }

  void markAsRead(NotificationItem notification) {
    state = state.map((n) {
      if (n == notification) {
        return NotificationItem(
          productId: n.productId,
          userId: n.userId,
          message: n.message,
          type: n.type,
          timestamp: n.timestamp,
          isRead: true, // 읽음 처리
        );
      }
      return n;
    }).toList();
  }

  void markAllAsRead() {
    SessionUser user = ref.read(LoginProvider);

    state = state.map((n) {
      if (n.userId == user.id) {
        return NotificationItem(
          productId: n.productId,
          userId: n.userId,
          message: n.message,
          type: n.type,
          timestamp: n.timestamp,
          isRead: true, // 읽음 처리
        );
      } else {
        return NotificationItem(
          productId: n.productId,
          userId: n.userId,
          message: n.message,
          type: n.type,
          timestamp: n.timestamp,
          isRead: false, // 읽음 처리
        );
      }
    }).toList();
  }

  void getHistory() {}

  void clearNotifications() {
    state = []; // 모든 알림 삭제
  }
}

final notificationProvider =
    NotifierProvider<NotificationState, List<NotificationItem>>(
  () => NotificationState(),
);
