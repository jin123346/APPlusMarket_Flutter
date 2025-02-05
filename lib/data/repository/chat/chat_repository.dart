import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/model/chat/chat_room.dart';
import 'package:dio/dio.dart';

import '../../../_core/utils/dio.dart';
import '../../model/chat/chat_room_card.dart'; // ChatRoomCard 모델 임포트

class ChatRepository {
  Future<List<ChatRoomCard>> getChatRoomCards(int currentUserId) async {
    logger.e('getChatRoomCards 들어옴');
    logger.e(dio);
    try {
      // Dio의 Response 객체 사용
      Response response = await dio.get('/chat-rooms?userId=$currentUserId');
      logger.d('chatRepository 메서드 - response : $response');

      // 응답에서 'data' 부분 추출
      Map<String, dynamic> responseBody = response.data;

      // 'data' 배열을 ChatRoomCard 객체 리스트로 파싱
      List<dynamic> chatRoomData = responseBody['data'];
      List<ChatRoomCard> chatRoomCards =
          chatRoomData.map((item) => ChatRoomCard.fromJson(item)).toList();

      logger.d('chatRoomCards : $chatRoomCards');

      return chatRoomCards;
    } catch (e) {
      logger.e('Error: $e');
      throw Exception('Error fetching chat room cards');
    }
  }

  // getChatRoomDetail
  Future<ChatRoom> getChatRoomDetail(int chatRoomId) async {
    try {
      Response response = await dio.get('/chat-rooms/$chatRoomId');

      Map<String, dynamic> responseBody = response.data;
      Map<String, dynamic> data = responseBody['data'];
      logger.e('채팅방 목록 : 🎇 $data');

      return ChatRoom.fromJson(data);
    } catch (e) {
      throw Exception('채팅방 정보 불러오는 중 오류 발생 : $e');
    }
  }
}
