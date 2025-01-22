/*
* 2025.01.21 - 황수빈 : chatRoom 모델링 클래스
*
*/

// 채팅방 조회시 사용됨

import 'package:applus_market/models/product_card.dart';
import 'package:applus_market/models/user_card.dart';

class ChatRoom {
  final int chat_room_id;
  final ProductCard productCard;
  final List<UserCard> participants;
  final List<ChatMessage> messages;
  final bool isRead;

  ChatRoom({
    required this.chat_room_id,
    required this.productCard,
    required this.participants,
    required this.messages,
    required this.isRead,
  });

  @override
  String toString() {
    return 'ChatRoom{chat_room_id: $chat_room_id, productCard: $productCard, participants: $participants, messages: $messages, isRead: $isRead}';
  }
}

class ChatMessage {
  final int chat_message_id;
  final int sender_id;
  final String message;
  final bool isRead;
  final String created_at;

  ChatMessage(
      {required this.chat_message_id,
      required this.sender_id,
      required this.message,
      required this.isRead,
      required this.created_at});

  @override
  String toString() {
    return 'ChatMessage{chat_message_id: $chat_message_id, sender_id: $sender_id, message: $message, isRead: $isRead, created_at: $created_at}';
  }
}

ChatRoom chatRoomExample = ChatRoom(
  chat_room_id: 12345,
  participants: [
    UserCard(
      user_id: 1,
      name: "나",
      ProfileImage: "https://example.com/images/alice.png",
    ),
    UserCard(
      user_id: 2,
      name: "나는야멋쟁이",
      ProfileImage: "https://example.com/images/bob.png",
    ),
  ],
  productCard: ProductCard(
      is_negotiable: true,
      product_id: 1,
      name: '맥북 프로 14 2024년형 새상품 팝니다',
      price: 3000000,
      thumbnail_image: 'https://picsum.photos/id/910/200/100'),
  messages: [
    ChatMessage(
      chat_message_id: 1,
      sender_id: 1,
      message:
          "안녕하세요! 만나서 반가워요.안녕하세요! 만나서 반가워요.안녕하세요! 만나서 반가워요.안녕하세요! 만나서 반가워요.안녕하세요! 만나서 반가워요.안녕하세요! 만나서 반가워요.안녕하세요! 만나서 반가워요.안녕하세요! 만나서 반가워요.안녕하세요! 만나서 반가워요.안녕하세요! 만나서 반가워요.안녕하세요! 만나서 반가워요.안녕하세요! 만나서 반가워요.안녕하세요! 만나서 반가워요.",
      isRead: true,
      created_at: "2025-01-20T15:01:00Z",
    ),
    ChatMessage(
      chat_message_id: 2,
      sender_id: 2,
      message: "네, 반갑습니다! 어떻게 도와드릴까요?",
      isRead: true,
      created_at: "2025-01-20T15:02:00Z",
    ),
    ChatMessage(
      chat_message_id: 3,
      sender_id: 1,
      message: "이 앱에 대해 궁금한 게 있어서요.",
      isRead: false,
      created_at: "2025-01-20T15:05:00Z",
    ),
  ].reversed.toList(),
  isRead: false,
);
