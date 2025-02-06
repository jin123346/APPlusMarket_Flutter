import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:applus_market/data/service/chat_websocket_service.dart';
import 'package:applus_market/ui/pages/chat/room/chat_room_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../data/model/product/product_card.dart';

import '../../../components/time_ago.dart';

/*
 * packageName    : lib/ui/pages/chat/room/widget/chat_room_body.dart
 * fileName       : chat_room_body.dart
 * author         : 황수빈
 * date           : 2024/01/21
 * description    : 채팅방 Widget 사용
 *
 * =============================================================
 * DATE              AUTHOR             NOTE
 * -------------------------------------------------------------
 * 2024/02/06       황수빈      MyId sessionUser에서 받아옴
 */

class ChatRoomBody extends ConsumerStatefulWidget {
  const ChatRoomBody({super.key});

  @override
  ChatRoomBodyState createState() => ChatRoomBodyState();
}

class ChatRoomBodyState extends ConsumerState<ChatRoomBody> {
  @override
  void initState() {
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();

  ChatRoomPageViewModel chatRoomViewModel = ChatRoomPageViewModel();

  final TextEditingController _messageController = TextEditingController();
  bool _showOptions = false;
  final FocusNode _focusNode = FocusNode();

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
        _focusNode.unfocus();
      } else {
        FocusScope.of(context).unfocus();
      }
      _showOptions = !_showOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO : 하드 코딩 고치기
    int chatRoomId = 1;

    SessionUser sessionUser = ref.watch(LoginProvider);
    int myId = sessionUser.id!;
    final chatRoomState = ref.watch(chatRoomProvider);
    final viewModel = ref.read(chatRoomProvider.notifier);

    viewModel.chatService.connect();

    return chatRoomState.when(
      data: (room) {
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
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                      shrinkWrap: true,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      controller: _scrollController,
                      itemCount: room.messages.length,
                      itemBuilder: (context, index) {
                        final message = room.messages[index];
                        final isMyMessage = message.senderId == myId;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: isMyMessage
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              _buildMessageTimestamp(
                                  isMyMessage, message.createdAt),
                              SizedBox(width: isMyMessage ? 5 : 0),
                              _buildMessageContainer(
                                  isMyMessage, message.content, context),
                              SizedBox(width: !isMyMessage ? 5 : 0),
                              _buildMessageTimestamp(
                                  !isMyMessage, message.createdAt),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
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
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 13),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 30,
                      child: IconButton(
                        icon: const Icon(CupertinoIcons.paperplane_fill),
                        onPressed: () {
                          setState(() {
                            viewModel.chatService.sendMessage(
                                chatRoomId, _messageController.text, myId);
                          });
                          _messageController.clear();
                          scrollToBottom();
                        },
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
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
                            _buildOptionButton('카메라',
                                CupertinoIcons.camera_fill, Colors.orange),
                            _buildOptionButton('자주쓰는문구',
                                CupertinoIcons.doc_text, Colors.brown),
                            _buildOptionButton('장소',
                                CupertinoIcons.location_solid, Colors.green),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('에러 발생: $error'),
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
    constraints:
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
      softWrap: true,
      overflow: TextOverflow.visible,
    ),
  );
}

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
