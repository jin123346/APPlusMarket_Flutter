import 'package:applus_market/ui/pages/chat/room/widget/chat_room_body.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatelessWidget {
  final int chatRoomId;

  const ChatRoomPage({super.key, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return ChatRoomBody(chatRoomId: chatRoomId);
  }
}
