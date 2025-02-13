import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/model/chat/chat_message.dart';
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
 * 2024/02/05    황수빈    setupMessageListener() 추가 - 화면 반영
 * 2024/02/07    황수빈    id 로 채팅방 조회 완료
 *                         id가 초기화 되지 않았을 땐 로딩 처리
 */

// TODO : (중요) AutoDispose.family 로 수정 해야함
class ChatRoomPageViewModel extends AsyncNotifier<ChatRoom> {
  final ChatRepository chatRepository = ChatRepository();
  final ChatService chatService = ChatService();

  late int chatRoomId; // 나중에 ChatRoomBody 에서 초기화 해줄 것
  bool _isInitialized = false;
  @override
  Future<ChatRoom> build() async {
    if (!isInitialized()) {
      state = const AsyncLoading();
      return await Future.delayed(Duration.zero);
    }

    return await getChatRoomDetail(chatRoomId);
  }

  bool isInitialized() {
    return _isInitialized;
  }

  // ChatRoomBody 에서 들어온 id 값으로 초기화
  void setChatRoomId(int id) {
    chatRoomId = id;
    _isInitialized = true;
    // 로딩 상태 설정
    setupMessageListener();

    _refreshData();
  }

  Future<void> _refreshData() async {
    try {
      final roomDetail = await getChatRoomDetail(chatRoomId);
      state = AsyncData(roomDetail);
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }

  // 구독한 방에서 받아온 메시지를 화면에 반영하기 위함
  void setupMessageListener() {
    chatService.onMessageReceived = (ChatMessage newMessage) {
      logger.e('여긴 확실히 올 듯 ');
      state.whenData((currentRoom) {
        final updatedMessages = [...currentRoom.messages, newMessage];
        state = AsyncData(currentRoom.copyWith(messages: updatedMessages));
      });
    };
  }

  Future<int> createChatRoom(int sellerId, int productId, int userId) async {
    Map<String, dynamic> body = {
      "sellerId": sellerId,
      "productId": productId,
      "userId": userId,
    };
    return await chatRepository.createChatRoom(body);
  }

  Future<ChatRoom> getChatRoomDetail(int chatRoomId) async {
    return await chatRepository.getChatRoomDetail(chatRoomId);
  }
}

final chatRoomProvider = AsyncNotifierProvider<ChatRoomPageViewModel, ChatRoom>(
  () => ChatRoomPageViewModel(),
);
