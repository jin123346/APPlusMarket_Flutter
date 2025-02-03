import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_list_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:applus_market/ui/pages/chat/list/chat_list_page_view_model.dart';

// ConsumerStateFulWidget <-- 이걸 사용
class ChatListBody extends ConsumerWidget {
  const ChatListBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatListState = ref.watch(chatListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('채 팅'),
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
                  decoration: const BoxDecoration(
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
      body: chatListState.when(
        data: (chatList) => ListView.builder(
          itemCount: chatList.length,
          itemBuilder: (context, index) {
            return ChatListContainer(chatRoom: chatList[index]);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('에러 발생: $error'),
        ),
      ),
    );
  }
}
