import 'package:flutter/material.dart';

import '../../../models/chat/chatRoomCard.dart';
import '../../common/components/image_container.dart';
import '../../components/time_ago.dart';

/*
* 2025.01.21 황수빈 : ChatRoom list뽑기
*
*/
class ChatListContainer extends StatelessWidget {
  final ChatRoomCard chatRoom;
  const ChatListContainer({required this.chatRoom, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/chatting_room');
      },
      child: Container(
        height: 90.0,
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              child: ImageContainer(
                borderRadius: 25,
                imgUri: chatRoom.user_image,
                width: 50,
                height: 50,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        chatRoom.user_name, // 사용자 이름
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        timeAgo(chatRoom.message_created_at), // 최근 메시지 시간
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      )
                    ],
                  ),
                  Text(
                    chatRoom.recent_message, // 최근 메시지
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  )
                ],
              ),
            ),
            const SizedBox(width: 12),
            ImageContainer(
              borderRadius: 5,
              imgUri: chatRoom.product_thumbnail,
              width: 50,
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
