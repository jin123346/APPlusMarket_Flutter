/*
* 2025.01.21 - 황수빈 : chatRoom 모델링 클래스
*
*/

// 채팅방 조회시 사용됨

import 'package:applus_market/data/model/chat/chat_message.dart';

import '../product/product_card.dart';
import '../user_card.dart';

/**
*  2025.01.24(금) - 황수빈 :  데이터 메시지 리스트 수정
**/

class ChatRoom {
  final int? chatRoomId;
  final ProductCard? productCard;
  final List<UserCard> participants;
  final List<ChatMessage> messages;

  ChatRoom({
    this.chatRoomId,
    required this.productCard,
    required this.participants,
    required this.messages,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      chatRoomId: json['chatRoomId'],
      productCard: ProductCard.fromJson(json['productCard']),
      participants: (json['participants'] as List)
          .map((item) => UserCard.fromJson(item))
          .toList(),
      messages: (json['messages'] is List)
          ? (json['messages'] as List)
              .map((item) => ChatMessage.fromJson(item))
              .toList()
              .reversed
              .toList()
          : [],
    );
  }

  // 메시지를 추가할 때마다 새로 상태를 반환
  ChatRoom copyWith({List<ChatMessage>? messages}) {
    return ChatRoom(
      chatRoomId: this.chatRoomId,
      productCard: this.productCard,
      participants: this.participants,
      messages: messages ?? this.messages,
    );
  }

  @override
  String toString() {
    return 'ChatRoom{chat_room_id: $chatRoomId, productCard: $productCard, participants: $participants, messages: $messages}';
  }
}
