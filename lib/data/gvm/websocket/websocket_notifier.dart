import 'dart:convert';
import 'package:applus_market/_core/utils/apiUrl.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:applus_market/data/model/chat/chat_message.dart';
import 'package:applus_market/data/model/chat/chat_room_card.dart';
import 'package:applus_market/data/model/notification_item.dart';
import 'package:applus_market/ui/pages/chat/list/chat_list_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applus_market/_core/utils/logger.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../notification_state.dart';

class WebSocketNotifier extends Notifier<bool> {
  StompClient? stompClient;
  final Set<String> subscribedDestinations = {};

  Function(String)? onNotificationReceived;

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

            // 관심 상품 알림 구독
            SessionUser sessionUser = ref.read(LoginProvider);
            logger.i("sessionUser 확인 중 ");

            if (sessionUser != null) {
              logger.i("sessionUser 존재함 ${sessionUser.id}");
              subscribeToNotifications(sessionUser.id!);
            }

            state = true;
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

  void subscribeUser(int userId) {
    try {
      logger.e('구독 메서드 입성');
      subscribe("/sub/user/$userId");
    } catch (e) {
      logger.e('로그인 요청 후 구독');
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

            // ChatSendMessage로 수정
            ChatMessage receivedMessage = ChatMessage.fromJson(data);
            logger.e('💻received data: $receivedMessage');
            // 콜백 함수로 화면 반영
            notifyListeners(receivedMessage);
            ref
                .watch(chatListProvider.notifier)
                .setupMessageListener(receivedMessage);
          }
        },
      );
      subscribedDestinations.add(destination);
      logger.d("구독 성공: $destination");
    } else {
      logger.w("이미 구독된 채널입니다: $destination");
    }
  }

  void requestPastNotifications(int userId) {
    logger.i("📡 과거 알림 요청 시작: $userId");

    stompClient?.send(
      destination: "/app/notifications/history",
      body: json.encode({"userId": userId}),
    );
  }

  void subscribeToNotifications(int userId) {
    logger.i("알림 구독 시작");
    String destination =
        "/topic/notification/$userId"; // 백엔드에서 설정한 WebSocket 경로

    stompClient?.subscribe(
      destination: destination,
      callback: (StompFrame frame) {
        logger.w("Received message: ${frame.body}");

        if (frame.body != null) {
          try {
            dynamic decodedData = json.decode(frame.body!);

            if (decodedData is List) {
              // JSON 배열이면 리스트 변환
              List<NotificationItem> items = decodedData.map((e) {
                return NotificationItem.fromJson(e);
              }).toList();
              ref.read(notificationProvider.notifier).addNotifications(items);
            } else if (decodedData is Map<String, dynamic>) {
              // 단일 JSON 객체 처리
              NotificationItem item = NotificationItem.fromJson(decodedData);
              ref.read(notificationProvider.notifier).addNotification(item);
            } else {
              logger.e("알 수 없는 데이터 형식: ${frame.body}");
            }
          } catch (e) {
            logger.e("알림 데이터 변환 오류: $e, 원본 데이터: ${frame.body}");
          }
        }
      },
    );

    print("📡 WebSocket 알림 구독 완료: $destination");
  }

  void disconnect() {
    stompClient?.deactivate();
    state = false; // 연결 해제 상태 업데이트
  }
}

final webSocketProvider = NotifierProvider<WebSocketNotifier, bool>(() {
  return WebSocketNotifier();
});
