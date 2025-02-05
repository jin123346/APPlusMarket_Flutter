import 'dart:convert';
import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/model/chat/chat_room.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChatService {
  StompClient? stompClient;

  void connect() {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: "http://192.168.0.145:8080/ws",
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print("WebSocket error: $error"),
      ),
    );
    stompClient!.activate();
  }

  void onConnect(StompFrame frame) {
    // 구독: 채팅방 ID 1번의 메시지를 구독
    stompClient!.subscribe(
      destination: "/sub/chatroom/1",
      callback: (frame) {
        if (frame.body != null) {
          Map<String, dynamic> result = json.decode(frame.body!);
          ChatMessage receivedMessage = ChatMessage.fromJson(result);
          logger.e('💻received data :$receivedMessage');
          notifyListeners(receivedMessage);
          // 받은 메시지를 UI에 반영하는 로직 추가 가능
        }
      },
    );
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
      logger.e("WebSocket 연결되지 않음");
      connect(); // 연결 재시도
    }
  }

  void notifyListeners(ChatMessage chatMessage) {
    if (onMessageReceived != null) {
      onMessageReceived!(chatMessage);
    }
  }

  Function(ChatMessage)? onMessageReceived;

  void disconnect() {
    stompClient?.deactivate();
  }
}
