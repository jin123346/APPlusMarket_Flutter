import 'package:applus_market/ui/pages/chat/chat_room_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../_core/utils/logger.dart';
import '../../../data/model/chat/chat_room.dart';
import '../../../data/model/product/product_card.dart';

import '../components/time_ago.dart';
/*
* 2025.01.21 황수빈 : ChatRoomPage 구현, 더미ㅇ 데이터 출력
* 2025.01.22 황수빈 : chat view_models 구현, 채팅 입력 시 화면 재 build
*/

// TODO : StatefulWidget과 StatelessWidget 분리

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final ScrollController _scrollController = ScrollController();

  ChatRoomPageViewModel chatRoomViewModel = ChatRoomPageViewModel();
  final TextEditingController _messageController = TextEditingController();

  bool _showOptions = false;
  final FocusNode _focusNode = FocusNode();

  // 키보드가 올라가면 ListView의 최하단으로 스크롤하는 메서드
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
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
    // TODO : 일단 myId 하드 코딩 - 로그인 유저 id로 수정 예정
    final int myId = 1;
    final ChatRoom room = chatRoomViewModel.chatroom;
    final otherUser =
        room.participants.firstWhere((user) => user.user_id != myId);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(otherUser.name),
      ),
      body: Column(
        children: [
          _buildProductCard(room.productCard),

          const SizedBox(height: 16),
          // 메시지 목록 표시
          Expanded(
            child: GestureDetector(

              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(

                  shrinkWrap: true,
                  // 리스트를 드래그하면 키보드가 내려가도록 하는 코드
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: _scrollController,
                  itemCount: room.messages.length,
                  itemBuilder: (context, index) {
                    final message = room.messages[index];
                    final isMyMessage = message.sender_id == myId;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: isMyMessage
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          _buildMessageTimestamp(
                              isMyMessage, message.created_at),
                          SizedBox(width: isMyMessage ? 5 : 0),
                          _buildMessageContainer(
                              isMyMessage, message.message, context),
                          SizedBox(width: !isMyMessage ? 5 : 0),
                          _buildMessageTimestamp(
                              !isMyMessage, message.created_at),
                        ],
                      ),
                    );
                  },
                ),
              ),
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
                  child: Container(
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
                            scrollToBottom();
                          });
                        },
                        cursorColor: Colors.grey[600],
                        cursorHeight: 17,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              CupertinoIcons.smiley,
                              size: 25,
                            ),
                            onPressed: () {},
                            color: Colors.grey[600],
                          ),
                          hintText: '메시지 보내기',
                          hintStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 13),
                        ),
                      )),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 30,
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.paperplane_fill),
                    onPressed: () {
                      setState(() {
                        // 메시지를 추가하는 비지니스 로직
                        chatRoomViewModel.addMessage(
                            myId, _messageController.text);
                        logger.d(chatRoomViewModel.chatroom);
                      });
                      _messageController.clear();

                      // 메시지 전송 후 스크롤 하단으로
                      scrollToBottom();
                    },
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

// 앨범 / 카메라 / 자주쓰는문구 / 장소
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

// 메시지 전송 시간
_buildMessageTimestamp(bool isMyMessage, String timestamp) {
  return Visibility(
    visible: isMyMessage,
    child: Text(
      timeAgo(timestamp),
      style: TextStyle(fontSize: 13, color: Colors.black26),
    ),
  );
}

// 메시지 컨테이너
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

// 상품 정보 섹션
_buildProductCard(ProductCard productCard) {
  return Column(
    children: [
      const Divider(height: 1),
      Container(
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      ),
    ],
  );
}
