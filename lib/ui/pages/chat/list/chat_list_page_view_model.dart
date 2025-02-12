import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/chat/chat_message.dart';
import 'package:applus_market/data/model/chat/chat_room.dart';
import 'package:applus_market/data/service/chat_websocket_service.dart';
import 'package:flutter/cupertino.dart';
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

class ChatListPageViewModel extends AsyncNotifier<List<ChatRoomCard>> {
  final ChatRepository chatRepository = ChatRepository();
  final ChatService chatService = ChatService();
  @override
  Future<List<ChatRoomCard>> build() async {
    logger.e('build() 메서드 입성');
    SessionUser sessionUser = ref.watch(LoginProvider);

    try {
      final chatRooms = await selectChatRooms(sessionUser.id!);
      logger.i('채팅방 목록 불러오기 성공: ${chatRooms.length}개');
      setupMessageListener();
      return chatRooms;
    } catch (e, stackTrace) {
      logger.e('채팅방 목록 불러오기 실패: $e, $stackTrace');
      return [];
    }
  }

  Future<List<ChatRoomCard>> selectChatRooms(int currentUserId) async {
    return await chatRepository.getChatRoomCards(currentUserId);
  }

  // 메시지 수신 시 채팅방 목록을 업데이트하는 리스너 설정
  void setupMessageListener() {
    chatService.onMessageReceived = (ChatMessage newMessage) {
      logger.e("새 메시지 수신");
    };
  }
}

final chatListProvider =
    AsyncNotifierProvider<ChatListPageViewModel, List<ChatRoomCard>>(
        () => ChatListPageViewModel());
