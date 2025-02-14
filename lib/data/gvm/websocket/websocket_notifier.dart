import 'dart:convert';
import 'package:applus_market/_core/utils/apiUrl.dart';
import 'package:applus_market/data/model/chat/chat_message.dart';
import 'package:applus_market/data/model/chat/chat_room_card.dart';
import 'package:applus_market/ui/pages/chat/list/chat_list_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applus_market/_core/utils/logger.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class WebSocketNotifier extends Notifier<bool> {
  StompClient? stompClient;
  final Set<String> subscribedDestinations = {};

  @override
  bool build() => false; // 초기 상태: 연결되지 않음

  bool connect() {
    if (stompClient != null && stompClient!.connected) {
      logger.d("이미 WebSocket 연결이 활성화되어 있습니다.");
      return true;
    }

    try {
      stompClient = StompClient(
        config: StompConfig.sockJS(
          url: "$apiUrl/ws",
          onConnect: (frame) {
            logger.d("WebSocket 연결됨");
            state = true; // 연결 상태 업데이트
          },
          onWebSocketError: (dynamic error) =>
              logger.e("WebSocket error: $error"),
        ),
      );
      stompClient!.activate();
      return true;
    } catch (e) {
      logger.e('WebSocket 연결 실패: $e');
      return false;
    }
  }

  // 채팅방 목록에서 채팅방 ID만 추출하여 리스트로 반환
  List<int> getChatIds(List<ChatRoomCard> chatRooms) {
    return chatRooms.map((chatRoom) => chatRoom.chatRoomId).toList();
  }

  void subscribeChatroom(List<ChatRoomCard> chatRooms) {
    List<int> results = getChatIds(chatRooms);
    for (int chatRoom in results) {
      subscribe("/sub/chatroom/$chatRoom");
    }
  }

  Function(ChatMessage)? onMessageReceived;

// 이벤트 발생을 구독중인 리스너에게 알려주는 메서드
  void notifyListeners(ChatMessage chatMessage) {
    if (onMessageReceived != null) {
      onMessageReceived!(chatMessage);
    }
  }

  void subscribe(String destination) {
    if (!subscribedDestinations.contains(destination)) {
      stompClient?.subscribe(
        destination: destination,
        callback: (frame) {
          if (frame.body != null) {
            Map<String, dynamic> data = json.decode(frame.body!);
            ChatMessage receivedMessage = ChatMessage.fromJson(data);
            logger.e('💻received data: $receivedMessage');
            notifyListeners(receivedMessage);
          }
        },
      );
      subscribedDestinations.add(destination);
      logger.d("구독 성공: $destination");
    } else {
      logger.w("이미 구독된 채널입니다: $destination");
    }
  }

  void disconnect() {
    stompClient?.deactivate();
    state = false; // 연결 해제 상태 업데이트
  }
}

// 🔥 WebSocket 전역 관리 Provider
final webSocketProvider = NotifierProvider<WebSocketNotifier, bool>(() {
  return WebSocketNotifier();
});
