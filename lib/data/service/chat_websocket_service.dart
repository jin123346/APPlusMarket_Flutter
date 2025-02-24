import 'dart:convert';
import 'dart:math';
import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/chat/chat_message.dart';
import 'package:applus_market/data/model/chat/chat_room.dart';
import 'package:applus_market/data/repository/chat/chat_repository.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

/*
 * packageName    : lib/ui/pages/chat/room/chat_room_page_view_model.dart
 * fileName       : chat_room_view_model.dart
 * author         : 황수빈
 * date           : 2024/02/03
 * description    : 채팅 웹소켓 서비스
 *
 * =============================================================
 *   DATE         AUTHOR             NOTE
 * -------------------------------------------------------------
 * 2024/02/05     황수빈    setupMessageListener() 추가
 *                          받은 메시지 화면 반영을 위하여
 */

// TODO : Notifier로 만들어서 사용
class ChatService {
  static final ChatService _instance = ChatService._internal();

  factory ChatService() {
    return _instance;
  }

  ChatService._internal();

  StompClient? stompClient;
  final Set<String> subscribedDestinations = {};
  List<int> results = [];

  bool connect(List<int> chatIds) {
    results = chatIds;

    // 이미 연결되어 있는 경우 활성화 방지
    if (stompClient != null && stompClient!.connected) {
      logger.d("이미 WebSocket 연결이 활성화되어 있습니다.");
      return true;
    }
    try {
      stompClient = StompClient(
        config: StompConfig.sockJS(
          url: "http://192.168.0.145:8080/ws",
          onConnect: onConnect,
          onWebSocketError: (dynamic error) =>
              logger.e("WebSocket error: $error"),
        ),
      );
      stompClient!.activate();
      logger.d("WebSocket 연결 중 상태 : ${stompClient?.connected}");
      return true;
    } catch (e) {
      logger.e('WebSocket 연결 실패 : $e');
      return false;
    }
  }

  void onConnect(StompFrame frame) {
    for (int id in results) {
      subscribeToChatRoom(id);
    }
  }

  void subscribeToChatRoom(int chatRoomId) {
    final destination = "/sub/chatroom/$chatRoomId";

    if (!subscribedDestinations.contains(destination)) {
      stompClient?.subscribe(
        destination: destination,
        callback: (frame) {
          if (frame.body != null) {
            Map<String, dynamic> result = json.decode(frame.body!);
            ChatMessage receivedMessage = ChatMessage.fromJson(result);
            logger.e('💻received data: $receivedMessage');

            notifyListeners(receivedMessage);
          }
        },
      );
      subscribedDestinations.add(destination);
      logger.d("구독 성공: $destination");
    } else {
      logger.w("이미 구독된 방입니다: $destination");
    }
  }

  void sendMessage(int chatRoomId, String message, int senderId) {
    if (stompClient != null && stompClient!.connected) {
      try {
        Map<String, dynamic> body = {
          "chatRoomId": chatRoomId,
          "content": message,
          "senderId": senderId,
        };
        stompClient!.send(
          destination: "/pub/chat/message",
          body: json.encode(body),
        );
        logger.d("메시지 전송 성공: $body");
      } catch (e) {
        logger.e("메시지 전송 오류: $e");
      }
    } else {
      logger.e("WebSocket 연결되지 않음 ${stompClient?.connected}");
      connect(results);
    }
  }

  Function(ChatMessage)? onMessageReceived;

// 이벤트 발생을 구독중인 리스너에게 알려주는 메서드
  void notifyListeners(ChatMessage chatMessage) {
    if (onMessageReceived != null) {
      onMessageReceived!(chatMessage);
    }
  }

  void disconnect() {
    stompClient?.deactivate();
  }
}
