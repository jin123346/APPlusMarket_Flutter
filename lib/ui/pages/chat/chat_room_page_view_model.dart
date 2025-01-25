import '../../../data/model/chat/chat_room.dart';
import '../../../data/model/product/product_card.dart';
import '../../../data/model/user_card.dart';

class ChatRoomPageViewModel {
  ChatRoom _chatRoom = ChatRoom(
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
      isRead: false);

  ChatRoom get chatroom => _chatRoom;

  int _messageIdCounter = 4;

  void addMessage(int sender_id, String message) {
    _chatRoom.messages.add(ChatMessage(
      chat_message_id: _messageIdCounter,
      sender_id: sender_id,
      message: message,
      isRead: false,
      created_at: DateTime.now().toString(),
    ));
    _messageIdCounter++;
  }
}
