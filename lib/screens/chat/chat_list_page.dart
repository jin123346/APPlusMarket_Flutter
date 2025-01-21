import 'package:applus_market/screens/chat/components/chat_list_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/chat/chatRoomCard.dart';

/*
* 2025.01.21 황수빈 : 채팅 list page 만들기
*
*/

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  int selectedIndex = 0;

  List<ChatRoomCard> getFilteredChatList(int tabIndex) {
    switch (tabIndex) {
      case 0: // 전체
        return chatRoomCards;
      case 1: // 판매
        return chatRoomCards.where((chat) => chat.isSeller).toList();
      case 2: // 구매
        return chatRoomCards.where((chat) => !chat.isSeller).toList();
      case 3: // 안 읽은 채팅방
        return chatRoomCards;
      default:
        return chatRoomCards;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('채 팅'),
        actions: [
          Stack(
            children: [
              const Icon(CupertinoIcons.bell, color: Colors.black, size: 22),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTab('전체', 0),
                const SizedBox(width: 8),
                _buildTab('판매', 1),
                const SizedBox(width: 8),
                _buildTab('구매', 2),
                const SizedBox(width: 8),
                _buildTab('안 읽은 채팅방', 3),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: getFilteredChatList(selectedIndex).length,
              itemBuilder: (context, index) {
                return ChatListContainer(
                    chatRoom: getFilteredChatList(selectedIndex)[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black87 : Colors.white,
          border: Border.all(
              color: isSelected ? Colors.black87 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
