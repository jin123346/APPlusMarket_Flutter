import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/model/chat/chat_room_card.dart';
import 'package:applus_market/data/repository/chat/chat_repository.dart';

class ChatListPageViewModel extends AsyncNotifier<List<ChatRoomCard>> {
  final ChatRepository chatRepository = ChatRepository();

  @override
  Future<List<ChatRoomCard>> build() async {
    return await selectChatRooms(1); // 초기 데이터 로드
  }

  Future<List<ChatRoomCard>> selectChatRooms(int currentUserId) async {
    return await chatRepository.selectChatRoomCards(currentUserId);
  }
}

final chatListProvider =
    AsyncNotifierProvider<ChatListPageViewModel, List<ChatRoomCard>>(
        () => ChatListPageViewModel());
