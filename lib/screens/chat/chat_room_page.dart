import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../models/chat/chatRoom.dart';
import '../../models/productCard.dart';
import '../components/time_ago.dart';

/*
* 2025.01.21 황수빈 : Chatting Room Page 구현
*
*/

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  bool _showOptions = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleOptions() async {
    setState(() {
      if (_showOptions) {
        // 옵션을 닫을 때는 키보드를 띄울 수 있도록 포커스를 다시 요청
        _focusNode.unfocus(); // 포커스를 해제하여 키보드를 내림
      } else {
        // 옵션을 열 때는 키보드를 내림
        FocusScope.of(context).unfocus(); // 키보드 내려주기
      }
      _showOptions = !_showOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    ChatRoom chatRoom = chatRoomExample;

    // TODO : (채팅) 현재 아이디 하드코딩 - 로그인한 유저로 바꾸기
    final int myId = 1;

    final otherUser =
        chatRoom.participants.firstWhere((user) => user.user_id != myId);

    return Scaffold(
      appBar: AppBar(
        title: Text(otherUser.name),
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          // 상품 카드 정보 표시
          _buildProductCard(chatRoom.productCard),
          const Divider(height: 1),
          const SizedBox(height: 16),
          // 메시지 목록 표시
          Expanded(
            child: ListView.builder(
              itemCount: chatRoom.messages.length,
              itemBuilder: (context, index) {
                final message = chatRoom.messages[index];
                final isMyMessage = message.sender_id == myId;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: isMyMessage
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      _buildMessageTimestamp(isMyMessage, message.created_at),
                      SizedBox(width: isMyMessage ? 5 : 0),
                      _buildMessageContainer(
                          isMyMessage, message.message, context),
                      SizedBox(width: !isMyMessage ? 5 : 0),
                      _buildMessageTimestamp(!isMyMessage, message.created_at),
                    ],
                  ),
                );
              },
            ),
          ),
          // 텍스트필드 영역
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: IconButton(
                    icon: Icon(_showOptions ? Icons.close : Icons.add),
                    onPressed: _toggleOptions,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Stack(children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: _messageController,
                          focusNode: _focusNode,
                          onTap: () {
                            // 메시지 입력창이 탭될 때 옵션 목록을 숨김
                            setState(() {
                              _showOptions = false;
                            });
                          },
                          cursorColor: Colors.grey[600],
                          cursorHeight: 17,
                          decoration: InputDecoration(
                            hintText: '메시지 보내기',
                            hintStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 13),
                          ),
                        )),
                    Positioned(
                      right: 13,
                      top: 2,
                      child: SizedBox(
                        width: 30,
                        child: IconButton(
                          icon: const Icon(
                            Icons.sentiment_satisfied_outlined,
                            size: 27,
                          ),
                          onPressed: () {},
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 30,
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.paperplane_fill),
                    onPressed: () {},
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16)
              ],
            ),
          ),
          if (_showOptions)
            Flexible(
              child: Container(
                height: 300,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildOptionButton(
                            '앨범', CupertinoIcons.photo, Colors.blue),
                        _buildOptionButton(
                            '카메라', CupertinoIcons.camera_fill, Colors.orange),
                        _buildOptionButton(
                            '자주쓰는문구', CupertinoIcons.doc_text, Colors.brown),
                        _buildOptionButton(
                            '장소', CupertinoIcons.location_solid, Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}

_buildOptionButton(String label, IconData icon, Color color) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
      const SizedBox(height: 8),
      Text(label, style: TextStyle(fontSize: 12)),
    ],
  );
}

_buildMessageTimestamp(bool isMyMessage, String timestamp) {
  return Visibility(
    visible: isMyMessage,
    child: Text(
      timeAgo(timestamp),
      style: TextStyle(fontSize: 13, color: Colors.black26),
    ),
  );
}

_buildMessageContainer(bool isMyMessage, String message, context) {
  return Container(
    constraints: // 자식 영역 텍스트 줄바꿈을 위해 추가하였음
        BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    margin: EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: isMyMessage ? Colors.grey.shade100 : Colors.white,
      border: isMyMessage
          ? Border.all(color: Colors.grey.shade100)
          : Border.all(color: Colors.black12),
      borderRadius: BorderRadius.circular(25),
    ),
    child: Text(
      message,
      style: TextStyle(fontSize: 15),
      softWrap: true, // 텍스트 줄바꿈 허용
      overflow: TextOverflow.visible,
    ),
  );
}

_buildProductCard(ProductCard productCard) {
  return Container(
    padding: EdgeInsets.all(16.0),
    child: Row(
      children: [
        Image.network(
          productCard.thumbnail_image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productCard.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Row(
              children: [
                Text(
                  '${productCard.price}원',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                Text(
                  productCard.is_negotiable! ? '(가격제안가능)' : '(가격제안불가)',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
