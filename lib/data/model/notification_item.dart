class NotificationItem {
  final String? message;
  final int? productId;
  final int? userId;
  final String type;
  final DateTime? timestamp;
  final bool? isRead;

  NotificationItem(
      {required this.message,
      required this.timestamp,
      required this.isRead,
      required this.type,
      required this.productId,
      required this.userId});

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      productId: json['productId'] ?? 0, // null이면 기본값 0
      userId: json['userId'] ?? 0, // null이면 기본값 0
      message: json['message'] ?? "알림 메시지 없음", // null이면 기본 메시지
      timestamp: DateTime.now(), // 수신 시간 기록
      type: json['eventType'] ?? 'PRICE_UPDATED',
      isRead: false, // 기본적으로 읽지 않은 상태
    );
  }
  NotificationItem copyWith({
    String? message,
    DateTime? timestamp,
    bool? isRead,
    int? productId,
    int? userId,
    String? type,
  }) {
    return NotificationItem(
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'NotificationItem{message: $message, timestamp: $timestamp, isRead: $isRead}';
  }
}
