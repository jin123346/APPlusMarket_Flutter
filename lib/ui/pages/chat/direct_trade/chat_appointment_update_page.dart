import 'package:applus_market/data/model/chat/chat_data.dart';
import 'package:applus_market/data/model/chat/chat_message.dart';
import 'package:applus_market/ui/pages/chat/direct_trade/chat_appointment_page.dart';
import 'package:applus_market/ui/pages/chat/direct_trade/widgets/chat_appointment_body.dart';
import 'package:applus_market/ui/pages/chat/direct_trade/widgets/chat_appointment_update_body.dart';
import 'package:flutter/cupertino.dart';

class ChatAppointmentUpdatePage extends StatelessWidget {
  final ChatMessage? chatMessage;
  const ChatAppointmentUpdatePage({super.key, this.chatMessage});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List?;
    final ChatMessage? chatMessage = args?[0] as ChatMessage?;
    final ChatData? chatData = args?[1] as ChatData?;
    return ChatAppointmentUpdateBody(
        chatMessage: chatMessage, chatData: chatData);
  }
}
