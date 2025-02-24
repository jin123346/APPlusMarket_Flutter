import 'package:flutter/material.dart';

class ChatMessage {
  final int chatRoomId;
  final String? messageId;
  final int userId;
  final String? content;
  final bool? isRead;
  final String? createdAt;
  final String? deletedAt;
  final String? date;
  final String? time;
  final String? location;
  final String? locationDescription;
  final int? reminderBefore;

  ChatMessage(
      {required this.chatRoomId,
      required this.userId,
      this.messageId,
      this.content,
      this.isRead,
      this.createdAt,
      this.deletedAt,
      this.date,
      this.time,
      this.location,
      this.locationDescription,
      this.reminderBefore});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageId: json['_id'],
      userId: json['senderId'],
      chatRoomId: json['chatRoomId'],
      content: json['content'] ?? json['date'],
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'],
      deletedAt: json['deletedAt'] ?? '',
      date: json['date'],
      time: json['time'],
      location: json['location'],
    );
  }

  @override
  String toString() {
    return 'ChatMessage{chatRoomId: $chatRoomId, messageId: $messageId, userId: $userId, content: $content, isRead: $isRead, createdAt: $createdAt, deletedAt: $deletedAt, date: $date, time: $time, location: $location, locationDescription: $locationDescription, reminderBefore: $reminderBefore}';
  }
}
