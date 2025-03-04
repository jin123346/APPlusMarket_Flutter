/*
* 2025.01.21 - 황수빈 : chatRoomCard 모델링 클래스
*
*/

// 채팅 리스트에서 사용 - /chatting

import 'package:applus_market/_core/utils/apiUrl.dart';

class ChatRoomCard {
  final int chatRoomId;
  final int userId;
  final String userNickname;
  final String? userImage;
  final int productId;
  final String productThumbnail;
  final int sellerId; // 채팅방의 제품 판매자
  final int? unRead;

  final String? recentMessage;
  final String messageCreatedAt;

  ChatRoomCard(
      {required this.chatRoomId,
      required this.userId,
      required this.userNickname,
      required this.userImage,
      required this.productId,
      required this.productThumbnail,
      required this.sellerId,
      this.unRead = 0,
      this.recentMessage,
      required this.messageCreatedAt}); // JSON 데이터를 ChatRoomCard 객체로 변환하는 fromJson 메서드

  factory ChatRoomCard.fromJson(Map<String, dynamic> json) {
    return ChatRoomCard(
      chatRoomId: json['chatRoomId'],
      userId: json['userId'],
      userNickname: json['userNickname'],
      userImage: json['userImage'],
      productId: json['productId'],
      unRead: json['unRead'],
      productThumbnail:
          '$apiUrl/uploads/${json['productId']}/${json['productThumbnail']}',
      sellerId: json['sellerId'],
      recentMessage: json['recentMessage'] ?? '약속 정하기',
      messageCreatedAt: json['messageCreatedAt'] ?? '',
    );
  }
  // copyWith 메서드 추가
  ChatRoomCard copyWith({
    String? userImage,
    String? productThumbnail,
    String? recentMessage,
    String? messageCreatedAt,
    int? unRead,
  }) {
    return ChatRoomCard(
      chatRoomId: this.chatRoomId,
      userId: this.userId,
      userNickname: this.userNickname,
      userImage: userImage ?? this.userImage,
      productId: this.productId,
      unRead: unRead ?? this.unRead,
      productThumbnail: productThumbnail ?? this.productThumbnail,
      sellerId: this.sellerId,
      recentMessage: recentMessage ?? this.recentMessage,
      messageCreatedAt: messageCreatedAt ?? this.messageCreatedAt,
    );
  }

  @override
  String toString() {
    return 'ChatRoomCard{chatRoomId: $chatRoomId, userId: $userId, userNickname: $userNickname, userImage: $userImage, productId: $productId, productThumbnail: $productThumbnail, sellerId: $sellerId, recentMessage: $recentMessage, messageCreatedAt: $messageCreatedAt}';
  }
}
