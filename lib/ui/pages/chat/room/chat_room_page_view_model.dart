import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/model/chat/chat_room.dart';
import 'package:applus_market/data/service/chat_websocket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applus_market/data/repository/chat/chat_repository.dart';

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
 * 2024/02/05     황수빈    setupMessageListener() 추가 - 화면 반영
 */

class ChatRoomPageViewModel extends AsyncNotifier<ChatRoom> {
  final ChatRepository chatRepository = ChatRepository();
  final ChatService chatService = ChatService();

  final int chatRoomId = 0;
  @override
  Future<ChatRoom> build() async {
    // TODO: 실제 채팅방 ID로 변경

    setupMessageListener();
    return await getChatRoomDetail(1); // 초기 데이터 로드
  }

  void getChatRoomId(int chatRoomId) {
    chatRoomId = chatRoomId;
    logger.e('');
  }

  // 구독한 방에서 받아온 알람을 화면에 반영하기 위함
  void setupMessageListener() {
    chatService.onMessageReceived = (ChatMessage newMessage) {
      state.whenData((currentRoom) {
        final updatedMessages = [...currentRoom.messages, newMessage];
        state = AsyncData(currentRoom.copyWith(messages: updatedMessages));
      });
    };
  }

  Future<ChatRoom> getChatRoomDetail(int chatRoomId) async {
    return await chatRepository.getChatRoomDetail(chatRoomId);
  }
}

final chatRoomProvider = AsyncNotifierProvider<ChatRoomPageViewModel, ChatRoom>(
  () => ChatRoomPageViewModel(),
);
