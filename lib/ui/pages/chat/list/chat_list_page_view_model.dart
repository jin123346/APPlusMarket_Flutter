import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
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

  @override
  Future<List<ChatRoomCard>> build() async {
    logger.e('build() 메서드 입성');
    SessionUser sessionUser = ref.watch(LoginProvider);

    try {
      final chatRooms = await selectChatRooms(sessionUser.id!);
      logger.i('채팅방 목록 불러오기 성공: ${chatRooms.length}개');
      return chatRooms;
    } catch (e, stackTrace) {
      logger.e('채팅방 목록 불러오기 실패: $e, $stackTrace');
      return [];
    }
  }

  Future<List<ChatRoomCard>> selectChatRooms(int currentUserId) async {
    return await chatRepository.getChatRoomCards(currentUserId);
  }
}

final chatListProvider =
    AsyncNotifierProvider<ChatListPageViewModel, List<ChatRoomCard>>(
        () => ChatListPageViewModel());
