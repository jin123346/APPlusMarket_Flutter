import 'package:flutter/material.dart';
import 'package:applus_market/ui/pages/chat/list/chat_list_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_list_container.dart';
import 'package:flutter/cupertino.dart';

class ChatListBody extends ConsumerWidget {
  const ChatListBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatList =
        ref.watch(ChatListNotiProvider); // 뷰모델을 구독// 데이터가 로드되었는지 확인

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
          const SizedBox(height: 20),
          Expanded(
            // 로딩 중이면 로딩 UI 표시
            child: ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                return ChatListContainer(
                  chatRoom: chatList[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
