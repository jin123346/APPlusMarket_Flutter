import 'package:riverpod/riverpod.dart'; // Riverpod 관련 패키지
import 'package:applus_market/data/repository/chat/chat_repository.dart';
import '../../../../data/model/chat/chat_room_card.dart';

class ChatListPageViewModel extends Notifier<List<ChatRoomCard>> {
  final ChatRepository chatRepository = ChatRepository();

  // 채팅방 목록을 가져오는 비동기 함수
  Future<void> selectChatRooms(int currentUserId) async {
    // 비동기 호출 후 채팅방 목록 업데이트
    List<ChatRoomCard> responseBody =
        await chatRepository.selectChatRoomCards(currentUserId);
    state = responseBody; // 상태 업데이트
  }

  // selectedIndex 관리 메서드 (선택적으로 추가)
  void updateSelectedIndex(int index) {
    // 필요시 selectedIndex 상태 업데이트
  }

  @override
  List<ChatRoomCard> build() {
    selectChatRooms(1);
    return state; // 상태 반환
  }
}

final ChatListNotiProvider =
    NotifierProvider<ChatListPageViewModel, List<ChatRoomCard>>(
  () {
    return ChatListPageViewModel();
  },
);
