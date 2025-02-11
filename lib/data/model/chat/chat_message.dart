class ChatMessage {
  final int? messageId;
  final int senderId;
  final int chatRoomId;
  final String content;
  final bool? isRead;
  final String createdAt;
  final String? deletedAt;

  ChatMessage(
      {this.messageId,
      required this.senderId,
      required this.content,
      required this.chatRoomId,
      this.isRead = false,
      required this.createdAt,
      this.deletedAt});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
        messageId: json['chatMessageId'] ?? 0,
        senderId: json['senderId'],
        chatRoomId: json['chatRoomId'],
        content: json['content'],
        isRead: json['isRead'] ?? false,
        createdAt: json['createdAt'],
        deletedAt: json['deletedAt'] ?? '');
  }

  @override
  String toString() {
    return 'ChatMessage{messageId: $messageId, senderId: $senderId, chatRoomId: $chatRoomId, content: $content, isRead: $isRead, createdAt: $createdAt, deletedAt: $deletedAt}';
  }
}
