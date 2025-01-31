/*
* 2025.01.21 - 황수빈 : chatRoomCard 모델링 클래스
*
*/

// 채팅 리스트에서 사용 - /chatting

class ChatRoomCard {
  final int chatRoomId;
  final String productThumbnail;
  final int productId;
  final bool isSeller; // 채팅방의 제품 판매자
  final String userImage;
  final String userName;
  final String recentMessage;
  final String messageCreatedAt;

  ChatRoomCard(
      {required this.chatRoomId,
      required this.productThumbnail,
      required this.productId,
      required this.isSeller,
      required this.userImage,
      required this.userName,
      required this.recentMessage,
      required this.messageCreatedAt});

  // JSON 데이터를 ChatRoomCard 객체로 변환하는 fromJson 메서드
  factory ChatRoomCard.fromJson(Map<String, dynamic> json) {
    return ChatRoomCard(
      chatRoomId: json['chatRoomId'],
      productThumbnail: json['productThumbnail'],
      productId: json['productId'],
      isSeller: json['isSeller'],
      userImage: json['userImage'] ??
          'https://picsum.photos/id/900/200/100', // null 처리
      userName: json['userName'],
      recentMessage: json['recentMessage'],
      messageCreatedAt: json['messageCreatedAt'],
    );
  }

  @override
  String toString() {
    return 'ChatRoomCard{chatRoomId: $chatRoomId, productThumbnail: $productThumbnail, productId: $productId, isSeller: $isSeller, userImage: $userImage, userName: $userName, recentMessage: $recentMessage, messageCreatedAt: $messageCreatedAt}';
  }

// ChatRoomCard 객체를 JSON 데이터로 변환하는 toJson 메서드 (필요 시)
  // Map<String, dynamic> toJson() {
  //   return {
  //     'chatRoomId': chatRoomId,
  //     'productThumbnail': productThumbnail,
  //     'productId': productId,
  //     'isSeller': isSeller,
  //     'userImage': userImage,
  //     'userName': userName,
  //     'recentMessage': recentMessage,
  //     'messageCreatedAt': messageCreatedAt,
  //   };
  // }
}
