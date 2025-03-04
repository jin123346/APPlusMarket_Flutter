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

  final bool? isFirst;

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
      this.reminderBefore,
      this.isFirst = false});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
        messageId: json['messageId'],
        userId: json['userId'],
        chatRoomId: json['chatRoomId'],
        content: json['content'] ?? json['date'],
        isRead: json['isRead'] ?? false,
        createdAt: json['createdAt'],
        deletedAt: json['deletedAt'] ?? '',
        date: json['date'],
        time: json['time'],
        location: json['location'],
        isFirst: json['isFirst']);
  }
  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'chatRoomId': chatRoomId,
      'userId': userId,
      'date': date,
      'time': time,
      'location': location,
      'locationDescription': locationDescription,
      'isFirst': isFirst
    };
  }

  @override
  String toString() {
    return 'ChatMessage{chatRoomId: $chatRoomId, messageId: $messageId, userId: $userId, content: $content, isRead: $isRead, createdAt: $createdAt, deletedAt: $deletedAt, date: $date, time: $time, location: $location, locationDescription: $locationDescription, reminderBefore: $reminderBefore}';
  }
}
