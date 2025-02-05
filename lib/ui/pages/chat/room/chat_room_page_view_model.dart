import 'package:applus_market/data/model/chat/chat_room.dart';
import 'package:applus_market/data/service/chat_websocket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applus_market/data/repository/chat/chat_repository.dart';

class ChatRoomPageViewModel extends AsyncNotifier<ChatRoom> {
  final ChatRepository chatRepository = ChatRepository();
  final ChatService chatService = ChatService();
  late int chatRoomId;

  @override
  Future<ChatRoom> build() async {
    chatRoomId = 1; // TODO: 실제 채팅방 ID로 변경
    chatService.connect();
    setupMessageListener();
    return await getChatRoomDetail(chatRoomId); // 초기 데이터 로드
  }

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
