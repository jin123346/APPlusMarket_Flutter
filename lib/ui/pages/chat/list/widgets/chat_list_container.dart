import 'package:applus_market/ui/pages/chat/room/chat_room_page.dart';
import 'package:flutter/material.dart';

import '../../../../../data/model/chat/chat_room_card.dart';
import '../../../../widgets/image_container.dart';
import '../../../components/time_ago.dart';

/*
*  2025.01.21 - 황수빈 : ChatListContainer 생성
*/

class ChatListContainer extends StatelessWidget {
  final ChatRoomCard chatRoom;
  const ChatListContainer({required this.chatRoom, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChatRoomPage(chatRoomId: chatRoom.chatRoomId), // 해당 ID를 전달
          ),
        );
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
                imgUri: chatRoom.userImage,
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
                        chatRoom.userNickname, // 사용자 이름
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        timeAgo(chatRoom.messageCreatedAt), // 최근 메시지 시간
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      )
                    ],
                  ),
                  Text(
                    chatRoom.recentMessage, // 최근 메시지
                    style: TextStyle(fontSize: 13.5, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  )
                ],
              ),
            ),
            const SizedBox(width: 12),
            ImageContainer(
              borderRadius: 5,
              imgUri: chatRoom.productThumbnail,
              width: 50,
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
