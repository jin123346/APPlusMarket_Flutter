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
        messageId: json['chatMessageId'] ?? 0,
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
