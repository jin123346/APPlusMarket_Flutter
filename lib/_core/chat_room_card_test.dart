import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/model/chat/chat_room_card.dart';
import 'package:applus_market/data/repository/chat/chat_repository.dart';
import 'package:flutter/material.dart';

void main() async {
  ChatRepository chatRepository = ChatRepository();

  List<ChatRoomCard> responseBody = await chatRepository.selectChatRoomCards(1);
  logger.d(responseBody);
}
