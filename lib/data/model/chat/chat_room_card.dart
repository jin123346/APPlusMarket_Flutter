/*
* 2025.01.21 - 황수빈 : chatRoomCard 모델링 클래스
*
*/

// 채팅 리스트에서 사용 - /chatting

class ChatRoomCard {
  final int chatRoomId;
  final int userId;
  final String userNickname;
  final String userImage;
  final int productId;
  final String productThumbnail;
  final int sellerId; // 채팅방의 제품 판매자

  final String recentMessage;
  final String messageCreatedAt;

  ChatRoomCard(
      {required this.chatRoomId,
      required this.userId,
      required this.userNickname,
      required this.userImage,
      required this.productId,
      required this.productThumbnail,
      required this.sellerId,
      required this.recentMessage,
      required this.messageCreatedAt}); // JSON 데이터를 ChatRoomCard 객체로 변환하는 fromJson 메서드

  factory ChatRoomCard.fromJson(Map<String, dynamic> json) {
    return ChatRoomCard(
      chatRoomId: json['chatRoomId'],
      userId: json['userId'],
      userNickname: json['userNickname'],
      userImage: json['userImage'],
      productId: json['productId'],
      productThumbnail: json['productThumbnail'],
      sellerId: json['sellerId'],
      recentMessage: json['recentMessage'] ?? 'mongo로 분리할 생각 중 따로 쿼리문 작성',
      messageCreatedAt: json['messageCreatedAt'] ?? '2025-01-20 15:02:22',
    );
  }

  @override
  String toString() {
    return 'ChatRoomCard{chatRoomId: $chatRoomId, userId: $userId, userNickname: $userNickname, userImage: $userImage, productId: $productId, productThumbnail: $productThumbnail, sellerId: $sellerId, recentMessage: $recentMessage, messageCreatedAt: $messageCreatedAt}';
  }
}
