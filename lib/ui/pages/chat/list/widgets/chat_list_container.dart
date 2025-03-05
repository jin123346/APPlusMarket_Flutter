import 'package:applus_market/_core/utils/apiUrl.dart';
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
              child: Image.network(
                chatRoom.userImage ??
                    '$apiUrl/uploads/1/e6c4fd7e-3ee7-4e1c-91e4-45c2fb5b5cad.png',
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
                      ),
                      Visibility(
                        visible: chatRoom.unRead != 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(25)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Center(
                              child: Text(
                                '${chatRoom.unRead}',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    chatRoom.recentMessage!, // 최근 메시지
                    style: TextStyle(fontSize: 13.5, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  )
                ],
              ),
            ),
            const SizedBox(width: 12),
            Image.network(
              chatRoom.productThumbnail,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
          ],
        ),
      ),
    );
  }
}
