import 'package:applus_market/data/model/chat/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
 * packageName    : lib/ui/pages/chat/chat_notifier.dart
 * fileName       : chat_notifier.dart
 * author         : 황수빈
 * date           : 2024/02/11
 * description    : 채팅 웹소켓 메시지 상태 관리
 *
 * =============================================================
 *   DATE         AUTHOR             NOTE
 * -------------------------------------------------------------
 *
 */

class ChatNotifier extends StateNotifier<Map<int, List<ChatMessage>>> {
  ChatNotifier() : super({});

  void addMessage(int chatRoomId, ChatMessage message) {
    final existingMessages = state[chatRoomId] ?? [];
    state = {
      ...state,
      chatRoomId: [...existingMessages, message]
    };
  }

  List<ChatMessage> getMessages(int chatRoomId) {
    return state[chatRoomId] ?? [];
  }
}

final chatProvider =
    StateNotifierProvider<ChatNotifier, Map<int, List<ChatMessage>>>(
        (ref) => ChatNotifier());
