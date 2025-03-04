import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/model/chat/chat_room.dart';
import 'package:dio/dio.dart';

import '../../../_core/utils/dio.dart';
import '../../model/chat/chat_message.dart';
import '../../model/chat/chat_room_card.dart'; // ChatRoomCard 모델 임포트

class ChatRepository {
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
}
