/*
* 2025.01.21 - 황수빈 : chatRoom 모델링 클래스
*
*/

// 채팅방 조회시 사용됨

import '../product/product_card.dart';
import '../user_card.dart';

/**
*  2025.01.24(금) - 황수빈 :  데이터 메시지 리스트 수정
**/

class ChatRoom {
  final int? chat_room_id;
  final ProductCard productCard;
  final List<UserCard> participants;
  final List<ChatMessage> messages;

  ChatRoom({
    this.chat_room_id,
    required this.productCard,
    required this.participants,
    required this.messages,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      chat_room_id: json['chatRoomId'],
      productCard: ProductCard.fromJson(json['productCard']),
      participants: (json['participants'] as List)
          .map((item) => UserCard.fromJson(item))
          .toList(),
      messages: (json['messages'] as List)
          .map((item) => ChatMessage.fromJson(item))
          .toList(),
    );
  }

  // 메시지를 추가할 때마다 새로 상태를 반환
  ChatRoom copyWith({List<ChatMessage>? messages}) {
    return ChatRoom(
      chat_room_id: this.chat_room_id,
      productCard: this.productCard,
      participants: this.participants,
      messages: messages ?? this.messages,
    );
  }

  @override
  String toString() {
    return 'ChatRoom{chat_room_id: $chat_room_id, productCard: $productCard, participants: $participants, messages: $messages}';
  }
}

class ChatMessage {
  final int? messageId;
  final int senderId;
  final String content;
  final bool? isRead;
  final String createdAt;
  final String? deletedAt;

  ChatMessage(
      {this.messageId,
      required this.senderId,
      required this.content,
      this.isRead = false,
      required this.createdAt,
      this.deletedAt});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
        messageId: json['messageId'] ?? 0,
        senderId: json['senderId'],
        content: json['content'],
        isRead: json['isRead'] ?? false,
        createdAt: json['createdAt'],
        deletedAt: json['deletedAt'] ?? '');
  }

  @override
  String toString() {
    return 'ChatMessage{chatMessageId: $messageId, senderId: $senderId, message: $content, isRead: $isRead, createdAt: $createdAt}';
  }
}
