import 'package:applus_market/_core/components/theme.dart';
import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:applus_market/data/model/chat/chat_data.dart';
import 'package:applus_market/data/model/chat/chat_message.dart';
import 'package:applus_market/ui/pages/chat/direct_trade/chat_appointment_update_page.dart';
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
 * DATE           AUTHOR             NOTE
 * -------------------------------------------------------------
 * 2024/02/06     황수빈      MyId sessionUser에서 받아옴
 * 2024/02/07     황수빈      chatRoomId 추가 id로 채팅방 조회
 * 2024/02/18     황수빈      내용이 없을 땐 전송이 안되도록 수정
 * 2024/02/27     황수빈      직거래 약속 잡기 기능 추가
 */

class ChatRoomBody extends ConsumerStatefulWidget {
  final int chatRoomId;

  const ChatRoomBody({super.key, required this.chatRoomId});

  @override
  ChatRoomBodyState createState() => ChatRoomBodyState();
}

class ChatRoomBodyState extends ConsumerState<ChatRoomBody> {
  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(chatRoomProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setChatRoomId(widget.chatRoomId);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels <=
          _scrollController.position.minScrollExtent + 100) {
        logger.e('채팅방 이전 메시지  조회 로직');
        viewModel.loadPreviousMessages();
      }
    });
  }

  final ScrollController _scrollController = ScrollController();

  ChatRoomPageViewModel chatRoomViewModel = ChatRoomPageViewModel();

  final TextEditingController _messageController = TextEditingController();
  bool _showOptions = false;
  final FocusNode _focusNode = FocusNode();

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 이 시점에 UI가 완전히 업데이트 되지 않아서 Future.delayed 이용
      Future.delayed(Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
    logger.e('상세보기 화면 파괴됨');
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
    int chatRoomId = widget.chatRoomId;
    SessionUser sessionUser = ref.watch(LoginProvider);

    int myId = sessionUser.id!;
    ChatData chatData;

    final viewModel = ref.read(chatRoomProvider.notifier);
    final chatRoomState = ref.watch(chatRoomProvider);
    bool isFirst;

    if (!viewModel.isInitialized()) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return chatRoomState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('$error'),
      data: (room) {
        isFirst = room.messages.isEmpty;
        final otherUser =
            room.participants.firstWhere((user) => user.userId != myId);

        chatData = ChatData(
            chatroomId: widget.chatRoomId,
            sellerName: otherUser.nickname,
            senderId: myId);
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(otherUser.nickname),
          ),
          body: Column(
            children: [
              _buildProductCard(room.productCard!, context, chatData),
              const SizedBox(height: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: room.messages.isEmpty
                        ? Center(
                            child: Text('메시지가 없습니다'),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: room.messages.length,
                            itemBuilder: (context, index) {
                              final ChatMessage message = room.messages[index];
                              final isMyMessage = message.userId == myId;
                              logger.e(message);

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment: isMyMessage
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    _buildMessageTimestamp(
                                        isMyMessage, message.createdAt!),
                                    SizedBox(width: isMyMessage ? 5 : 0),
                                    message.date == null &&
                                            message.content != null
                                        ? _buildMessageContainer(isMyMessage,
                                            message.content!, context)
                                        : _buildDateBox(
                                            message, chatData, context),
                                    SizedBox(width: !isMyMessage ? 5 : 0),
                                    _buildMessageTimestamp(
                                        !isMyMessage, message.createdAt!),
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
                            viewModel.sendMessage(ChatMessage(
                              chatRoomId: chatRoomId,
                              content: _messageController.text,
                              userId: myId,
                              isFirst: isFirst,
                            ));
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
                                '앨범', CupertinoIcons.photo, Colors.grey),
                            _buildOptionButton('카메라',
                                CupertinoIcons.camera_fill, Colors.orange),
                            _buildOptionButton(
                                '약속', CupertinoIcons.calendar, Colors.blue),
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

_buildProductCard(
    ProductCard productCard, BuildContext context, ChatData chatData) {
  return Column(
    children: [
      const Divider(height: 1),
      Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.network(
              productCard.thumbnailImage,
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
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    Text(
                      '${productCard.price}원',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      productCard.isNegotiable! ? '(가격제안가능)' : '(가격제안불가)',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  ],
                ),
              ],
            ),
            Spacer(),
            Container(
              height: 35,
              width: 80,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(5)),
              child: InkWell(
                onTap: () {
                  //TODO : 직거래 / 택배거래 뜨도록
                  _showPurchaseOptions(context, chatData);
                },
                child: Center(
                  child: Text(
                    '구매하기',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      const SizedBox(
        width: 16,
      )
    ],
  );
}

void _showPurchaseOptions(BuildContext context, ChatData chatData) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true, // 모달 바깥 클릭 시 닫히도록 설정
    barrierLabel: '',
    transitionDuration: Duration(milliseconds: 300), // 부드러운 애니메이션
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '거래 방식을 선택하세요',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _onDirectTradeSelected(context, chatData);
                    },
                    borderRadius: BorderRadius.circular(16),
                    splashColor: Colors.grey[100],
                    hoverColor: Colors.grey[50], // hover 시 색상 적용
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[30],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.person_crop_circle,
                              color: Colors.blue),
                          SizedBox(width: 10),
                          Text(
                            '직거래',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _onParcelTradeSelected();
                    },
                    borderRadius: BorderRadius.circular(16),
                    splashColor: Colors.grey[100],
                    hoverColor: Colors.grey[50], // hover 시 색상 적용
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[30],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.cube_box_fill,
                              color: Colors.green),
                          SizedBox(width: 10),
                          Text(
                            '택배거래',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0, 1);
      var end = Offset.zero;
      var curve = Curves.easeOutCubic;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

void _onDirectTradeSelected(BuildContext context, ChatData chatData) {
  // 직거래 선택 시 처리할 로직
  logger.d("직거래 선택됨");
  logger.e('chatData : $chatData');
  Navigator.pushNamed(context, '/chat/appointment', arguments: chatData);
}

void _onParcelTradeSelected() {
  // 택배거래 선택 시 처리할 로직
  logger.d("택배거래 선택됨");
  // 예: 배송지 입력 화면으로 이동 등
}

Widget _buildDateBox(
    ChatMessage chatMessage, ChatData chatData, BuildContext context) {
  return Center(
    child: Container(
      width: 270,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: const Text(
                  '약속 정하기',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '📅',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      //TODO : 형식 바꾸기
                      '${chatMessage.date}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      '⏰',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${chatMessage.time}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📍',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${chatMessage.location}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (chatMessage.locationDescription != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              chatMessage.locationDescription!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (chatMessage.reminderBefore != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  size: 16,
                  color: Color(0xFFFEE500),
                ),
                const SizedBox(width: 4),
                Text(
                  '${chatMessage.reminderBefore} 전 알림',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                logger.e('chatMessage : $chatMessage');
                Navigator.pushNamed(
                  context,
                  '/chat/appointment/update',
                  arguments: [chatMessage, chatData],
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: APlusTheme.primaryColor,
                // 카카오 노란색
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                '변경하기',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
