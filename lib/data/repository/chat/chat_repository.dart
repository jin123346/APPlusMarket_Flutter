import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/model/chat/chat_room.dart';
import 'package:dio/dio.dart';

import '../../../_core/utils/dio.dart';
import '../../model/chat/chat_message.dart';
import '../../model/chat/chat_room_card.dart'; // ChatRoomCard 모델 임포트

class ChatRepository {
  /** 채팅 목록 조회
   * @param userId
   */
  Future<List<ChatRoomCard>> getChatRoomCards(int userId) async {
    logger.e('getChatRoomCards 들어옴');
    logger.e(dio);
    try {
      // Dio의 Response 객체 사용
      Response response = await dio.get('/chat-rooms?userId=$userId');
      logger.d('chatRepository 메서드 - response : $response');

      // 응답에서 'data' 부분 추출
      Map<String, dynamic> responseBody = response.data;

      // 'data' 배열을 ChatRoomCard 객체 리스트로 파싱
      List<dynamic> chatRoomData = responseBody['data'];
      List<ChatRoomCard> chatRoomCards = chatRoomData
          .map((item) => ChatRoomCard.fromJson(item))
          .toList()
          .reversed
          .toList();

      logger.d('chatRoomCards : $chatRoomCards');

      return chatRoomCards;
    } catch (e) {
      logger.e('Error: $e');
      throw Exception('Error fetching chat room cards');
    }
  }

  /** 채팅 상세 조회
   *  @param chatRoomId
   */
  Future<ChatRoom> getChatRoomDetail(int chatRoomId) async {
    try {
      Response response = await dio.get('/chat-rooms/$chatRoomId');

      Map<String, dynamic> responseBody = response.data;
      Map<String, dynamic> data = responseBody['data'];
      logger.e('채팅방 상세 : 🎇 $data');
      return ChatRoom.fromJson(data);
    } catch (e) {
      throw Exception('채팅방 정보 불러오는 중 오류 발생 : $e');
    }
  }

  /** 구독할 채팅방 번호 조회
   * @param userId
   */
  Future<List<int>> getChatRoomsId(int userId) async {
    try {
      Response response = await dio.get('/chat-rooms/id?userId=$userId');

      Map<String, dynamic> responseBody = response.data;
      List<int> data = responseBody['data'];
      logger.e('구독할 채팅방 Id 목록 : 🎇 $data');

      return data;
    } catch (e) {
      throw Exception(' 구독할 아이디 조회 오류 발생 : $e');
    }
  }

  Future<Map<String, dynamic>> createChatRoom(
      Map<String, dynamic> reqData) async {
    try {
      Response response = await dio.post('/chat-rooms', data: reqData);

      Map<String, dynamic> responseBody = response.data;
      logger.e(response.data);
      Map<String, dynamic> data = responseBody['data'];

      logger.e('생성된 채팅방 : 🎇$data');

      return data;
    } catch (e) {
      logger.e(e);
      throw Exception('채팅방 생성 요청 중 오류 발생');
    }
  }

  Future<ChatMessage> updateAppointment(ChatMessage chatMessage) async {
    try {
      Response response = await dio.put(
          '/chat-rooms/${chatMessage.chatRoomId}/messages/${chatMessage.messageId}',
          data: chatMessage);
      logger.e('채팅 메시지 수정 결과 : 🎇 ${response.data}');

      return chatMessage;
    } catch (e) {
      logger.e('채팅 메시지 수정 중 오류 발생 : $e');
      throw Exception('채팅 메시지 수정 요청 중 오류 발생');
    }
  }

  Future<List<ChatMessage>> getPreviousMessagesByTime(
      int chatRoomId, String lastCreatedAt) async {
    try {
      final response = await dio.get(
        '/chat-rooms/$chatRoomId/messages',
        queryParameters: {
          'beforeCreatedAt': lastCreatedAt, // 가장 오래된 메시지 시간 이전의 메시지 가져오기
          'limit': 20, // 한 번에 20개씩 가져오기
        },
      );

      if (response.statusCode == 200) {
        // ✅ 응답 데이터 추출
        List<dynamic> data = response.data['data'];
        logger.e('이전 메시지 응답 데이터: $data');

        // ✅ Map으로 변환 후 ChatMessage 리스트로 매핑
        List<ChatMessage> messages = data
            .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
            .toList();

        // ✅ ChatMessage 리스트를 Map<String, dynamic>으로 변환
        List<Map<String, dynamic>> jsonList =
            messages.map((msg) => msg.toJson()).toList();

        logger.e('변환된 메시지 리스트: $jsonList');

        return messages;
      } else {
        throw Exception('이전 메시지 로드 실패');
      }
    } catch (e) {
      logger.e('이전 메시지 로드 중 오류: $e');
      throw Exception('이전 메시지 로드 중 오류 발생');
    }
  }

  Future<void> markMessagesAsRead(
      int chatRoomId, int userId, String timestamp) async {
    logger.e('chatRoomId : $chatRoomId');
    logger.e('userId : $userId');
    logger.e(timestamp);
    try {
      final response = await dio.post(
        '/chat-rooms/markAsRead',
        data: {
          "chatRoomId": chatRoomId,
          "userId": userId,
          "timestamp": timestamp
        },
      );
      logger.e('response ${response.data}');
      if (response.statusCode == 200) {
        logger.d("✅ 읽음 처리 완료: 채팅방 $chatRoomId, 사용자 $userId");
      } else {
        throw Exception("❌ 읽음 처리 실패: ${response.statusCode}");
      }
    } catch (e) {
      logger.d("❌ 읽음 처리 요청 오류: $e");
      rethrow;
    }
  }
}
