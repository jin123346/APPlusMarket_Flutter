class ChatData {
  final String sellerName;
  final int chatroomId;
  final int senderId;

  ChatData(
      {required this.sellerName,
      required this.chatroomId,
      required this.senderId});

  @override
  String toString() {
    return 'ChatData{sellerName: $sellerName, chatroomId: $chatroomId, senderId: $senderId}';
  }
}
