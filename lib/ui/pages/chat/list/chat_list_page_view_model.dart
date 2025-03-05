import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/gvm/websocket/websocket_notifier.dart';
import 'package:applus_market/data/model/chat/chat_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/model/auth/login_state.dart';
import '../../../../data/model/chat/chat_room_card.dart';
import 'package:applus_market/data/repository/chat/chat_repository.dart';

/*
 * packageName    : lib/ui/pages/chat/room/chat_room_page_list_model.dart
 * fileName       : chat_room_list_model.dart
 * author         : 황수빈
 * date           : 2024/01/21
 * description    : 채팅 목록 뷰 모델
 *
 * =============================================================
 *   DATE         AUTHOR             NOTE
 * -------------------------------------------------------------
 *
 */
class ChatListPageViewModel extends StateNotifier<List<ChatRoomCard>> {
  final ChatRepository chatRepository;
  final Ref ref;

  ChatListPageViewModel(this.ref, this.chatRepository) : super([]) {
    _fetchChatRooms();
  }

  Future<void> _fetchChatRooms() async {
    try {
      SessionUser sessionUser = ref.watch(LoginProvider);
      final notifier = ref.read(webSocketProvider.notifier);

      final chatRooms = await chatRepository.getChatRoomCards(sessionUser.id!);

      logger.i('채팅방 목록 불러오기 성공: ${chatRooms.length}개');
      logger.i('채팅방 구독 시작중');
      if (chatRooms.isNotEmpty) {
        notifier.subscribeChatroom(chatRooms);

        logger.i('채팅방 구독 완료');
        state = chatRooms;
      } else {
        state = [];
      }
    } catch (e, stackTrace) {
      logger.e('채팅방 목록 불러오기 실패: $e, $stackTrace');
    }
  }

  Future<void> refreshChatRooms() async {
    try {
      SessionUser sessionUser = ref.read(LoginProvider);

      final chatRooms = await chatRepository.getChatRoomCards(sessionUser.id!);

      if (chatRooms.isNotEmpty) {
        state = chatRooms;
      } else {
        state = [];
      }
    } catch (e, stackTrace) {
      logger.e('채팅방 목록 불러오기 실패: $e, $stackTrace');
    }
  }

  void setupMessageListener(ChatMessage newMessage) {
    SessionUser sessionUser = ref.watch(LoginProvider);
    // 새로운 메시지가 들어온 채팅방을 찾아서 copyWith으로 업데이트
    state = state.map((chatRoom) {
      if (chatRoom.chatRoomId == newMessage.chatRoomId) {
        return chatRoom.copyWith(
            recentMessage: newMessage.content, // 최신 메시지 업데이트
            messageCreatedAt: newMessage.createdAt, // 메시지 시간 업데이트

            unRead: sessionUser.id == newMessage.userId
                ? chatRoom.unRead
                : (chatRoom.unRead ?? 0) + 1 // 안 읽은 메시지 증가
            );
      }
      return chatRoom;
    }).toList();
  }
}

final unreadMessagesProvider = Provider<int>((ref) {
  final chatRooms = ref.watch(chatListProvider);
  return chatRooms.fold<int>(0, (sum, room) => sum + (room.unRead ?? 0));
});
final chatListProvider =
    StateNotifierProvider<ChatListPageViewModel, List<ChatRoomCard>>(
  (ref) => ChatListPageViewModel(ref, ChatRepository()),
);
