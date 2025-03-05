import 'dart:convert';

import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/gvm/websocket/websocket_notifier.dart';
import 'package:applus_market/data/model/chat/chat_message.dart';
import 'package:applus_market/data/model/chat/chat_room.dart';
import 'package:applus_market/ui/pages/chat/list/chat_list_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applus_market/data/repository/chat/chat_repository.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../../../data/gvm/session_gvm.dart';

/*
 * packageName    : lib/ui/pages/chat/room/chat_room_page_view_model.dart
 * fileName       : chat_room_view_model.dart
 * author         : 황수빈
 * date           : 2024/01/21
 * description    : 채팅방 뷰 모델
 *
 * =============================================================
 *   DATE         AUTHOR             NOTE
 * -------------------------------------------------------------
 * 2024/02/05    황수빈    setupMessageListener() 추가 - 화면 반영
 * 2024/02/07    황수빈    id 로 채팅방 조회 완료
 *                         id가 초기화 되지 않았을 땐 로딩 처리
 */

class ChatRoomPageViewModel extends AsyncNotifier<ChatRoom> {
  final ChatRepository chatRepository = ChatRepository();
  String? lastCreatedAt;

  late int chatRoomId; // 나중에 ChatRoomBody 에서 초기화 해줄 것
  bool _isInitialized = false;
  @override
  Future<ChatRoom> build() async {
    if (!isInitialized()) {
      state = const AsyncLoading();
      await Future.delayed(Duration(milliseconds: 10)); // 짧은 지연 추가
    }

    return await getChatRoomDetail(chatRoomId);
  }

  bool isInitialized() {
    return _isInitialized;
  }

  // ChatRoomBody 에서 들어온 id 값으로 초기화
  void setChatRoomId(int id) async {
    chatRoomId = id;
    _isInitialized = true;

    // 🔥 setChatRoomId()에서도 lastCreatedAt 초기화
    state.whenData((room) {
      if (room.messages.isNotEmpty) {
        // createdAt 중 가장 작은 값 찾기
        lastCreatedAt = room.messages
            .map((msg) => msg.createdAt)
            .where((createdAt) => createdAt != null)
            .reduce((a, b) => a!.compareTo(b!) < 0 ? a : b);
        logger.d('초기화된 lastCreatedAt: $lastCreatedAt');
      }
    });

    setupMessageListener();
    await _refreshData();
  }

  Future<void> _refreshData() async {
    try {
      final roomDetail = await getChatRoomDetail(chatRoomId);
      state = AsyncData(roomDetail);

      state.whenData((room) {
        if (room.messages.isNotEmpty) {
          // createdAt 중 가장 작은 값 찾기
          lastCreatedAt = room.messages
              .map((msg) => msg.createdAt)
              .where((createdAt) => createdAt != null)
              .reduce((a, b) => a!.compareTo(b!) < 0 ? a : b);
          logger.d('초기화된 lastCreatedAt: $lastCreatedAt');
        }
      });
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }

  // 구독한 방에서 받아온 메시지를 화면에 반영하기 위함
  void setupMessageListener() {
    ref.watch(webSocketProvider.notifier).onMessageReceived =
        (ChatMessage newMessage) {
      logger.d('메시지 화면 반영');
      state.whenData((currentRoom) {
        final updatedMessages = [...currentRoom.messages, newMessage];
        state = AsyncData(currentRoom.copyWith(messages: updatedMessages));
      });
    };
  }

  void sendMessage(ChatMessage chatMessage) {
    WebSocketNotifier notifier = ref.watch(webSocketProvider.notifier);
    StompClient? stompClient = notifier.stompClient;
    if (stompClient != null && stompClient.connected) {
      Map<String, dynamic> body;
      try {
        // 일반 메시지인 경우
        if (chatMessage.content != null) {
          body = {
            "chatRoomId": chatMessage.chatRoomId,
            "content": chatMessage.content,
            "userId": chatMessage.userId,
            "isFirst": chatMessage.isFirst,
            "isRead": chatMessage.isRead
          };
          // 약속 메시지인 경우
        } else {
          body = {
            "chatRoomId": chatMessage.chatRoomId,
            "userId": chatMessage.userId,
            "date": chatMessage.date.toString(),
            "time": chatMessage.time.toString(),
            "location": chatMessage.location,
            "locationDescription": chatMessage.locationDescription,
            "remindBefore": chatMessage.reminderBefore,
            "isFirst": chatMessage.isFirst,
            "isRead": chatMessage.isRead
          };
        }
        stompClient.send(
          destination: "/pub/chat/message",
          body: json.encode(body),
        );
        logger.d("메시지 전송 성공: $body");
        if (chatMessage.isFirst!) {
          ref.read(chatListProvider.notifier).refreshChatRooms();
        }
      } catch (e) {
        logger.e("메시지 전송 오류: $e");
      }
    } else {
      logger.e("WebSocket 연결되지 않음 ${stompClient?.connected}");
    }
  }

  Future<ChatMessage> updateAppointment(ChatMessage chatMessage) async {
    await chatRepository.updateAppointment(chatMessage);
    _refreshData();
    return chatMessage;
  }

  Future<int> createChatRoom(int sellerId, int productId, int userId) async {
    Map<String, dynamic> body = {
      "sellerId": sellerId,
      "productId": productId,
      "userId": userId,
    };

    Map<String, dynamic> result = await chatRepository.createChatRoom(body);
    logger.d('채팅방 생성 완료 -  : $result');
    int resultId = result['chatRoomId'];
    ref.read(chatListProvider.notifier).refreshChatRooms();
    ref.watch(webSocketProvider.notifier).subscribe('/sub/chatroom/$resultId');
    return resultId;
  }

  Future<ChatRoom> getChatRoomDetail(int chatRoomId) async {
    return await chatRepository.getChatRoomDetail(chatRoomId);
  }

  Future<void> loadPreviousMessages() async {
    state.whenData((currentRoom) async {
      // 현재 저장된 가장 오래된 메시지 시간 확인
      if (lastCreatedAt == null) return;

      try {
        // ChatRepository에서 이전 메시지를 가져옴
        final previousMessages = await chatRepository.getPreviousMessagesByTime(
          chatRoomId,
          lastCreatedAt!,
        );

        if (previousMessages.isNotEmpty) {
          // 가져온 메시지 중 가장 오래된 createdAt 갱신
          lastCreatedAt = previousMessages
              .map((msg) => msg.createdAt)
              .where((createdAt) => createdAt != null)
              .reduce((a, b) => a!.compareTo(b!) < 0 ? a : b);

          // 기존 메시지 리스트 상단에 이전 메시지 추가
          final updatedMessages = [
            ...previousMessages,
            ...currentRoom.messages
          ];
          state = AsyncData(currentRoom.copyWith(messages: updatedMessages));
        }
      } catch (e, stacktrace) {
        logger.e('이전 메시지 로드 오류: $e');
      }
    });
  }

  void markMessagesAsRead() async {
    final sessionUser = ref.watch(LoginProvider);

    final chatRoomId = this.chatRoomId;

    if (sessionUser.id == null) return;

    try {
      await chatRepository.markMessagesAsRead(
          chatRoomId, sessionUser.id!, DateTime.now().toIso8601String());
      logger.d("읽음 처리 요청 완료: 채팅방 $chatRoomId, 사용자 ${sessionUser.id}");

      // 프론트엔드 UI 상태 업데이트
      state.whenData((currentRoom) {
        final updatedMessages = currentRoom.messages.map((message) {
          return message.copyWith(isRead: true);
        }).toList();
        state = AsyncData(currentRoom.copyWith(messages: updatedMessages));
      });
      // TODO : (중요) 어떤 방법이 있을지 고민해보기
      ref.read(chatListProvider.notifier).refreshChatRooms();
    } catch (e) {
      logger.e("읽음 처리 요청 실패: $e");
    }
  }
}

final chatRoomProvider = AsyncNotifierProvider<ChatRoomPageViewModel, ChatRoom>(
  () => ChatRoomPageViewModel(),
);
