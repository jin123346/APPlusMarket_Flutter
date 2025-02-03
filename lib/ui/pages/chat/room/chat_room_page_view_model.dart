import 'package:applus_market/data/model/chat/chat_room.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applus_market/data/repository/chat/chat_repository.dart';

class ChatRoomPageViewModel extends AsyncNotifier<ChatRoom> {
  final ChatRepository chatRepository = ChatRepository();
  int chatRoomId = 1;
  @override
  Future<ChatRoom> build() async {
    return await selectChatRoomDetail(chatRoomId); // 초기 데이터 로드
  }

  Future<ChatRoom> selectChatRoomDetail(int chatRoomId) async {
    return await chatRepository.selectChatRoomDetail(chatRoomId);
  }

  void addMessage(int sender_id, String message) {
    // 새로운 메시지를 추가하고 상태 갱신
    final currentChatRoom = state.value; // 현재 상태의 ChatRoom 객체를 가져옴

    if (currentChatRoom == null) {
      // 상태가 아직 로드되지 않았거나 오류가 있는 경우 처리
      return;
    }

    // 새로운 메시지를 추가한 ChatRoom 객체https://discord.com/channels/1279969462262698078/1279969462262698082 생성
    final updatedChatRoom = currentChatRoom.copyWith(
      messages: [
        ...currentChatRoom.messages,
        ChatMessage(
          // 메시지 ID 증가
          sender_id: sender_id,
          message: message,
          isRead: false,
          created_at: DateTime.now().toString(),
        ),
      ],
    );

    // 상태 갱신
    state = AsyncData(updatedChatRoom);
  }
}

final chatRoomProvider = AsyncNotifierProvider<ChatRoomPageViewModel, ChatRoom>(
  () => ChatRoomPageViewModel(),
);
