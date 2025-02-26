import 'package:applus_market/_core/components/theme.dart';
import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/model/chat/chat_data.dart';
import 'package:applus_market/data/model/chat/chat_message.dart';
import 'package:applus_market/ui/pages/chat/room/chat_room_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatDirectBody extends ConsumerStatefulWidget {
  const ChatDirectBody({super.key});

  @override
  ChatDirectBodyState createState() => ChatDirectBodyState();
}

class ChatDirectBodyState extends ConsumerState<ChatDirectBody> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String selectedLocation = '장소 선택';
  String selectedNotification = '30분 전';

  List<String> notificationOptions = ['10분 전', '30분 전', '1시간 전', '당일'];

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: APlusTheme.primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: APlusTheme.primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _selectLocation() {
    setState(() {
      selectedLocation = '광안역 수영역 중간';
    });
  }

  void _selectNotification() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: notificationOptions.map((String option) {
              return ListTile(
                title: Text(option),
                onTap: () {
                  setState(() {
                    selectedNotification = option;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  BoxDecoration _defaultBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatData = ModalRoute.of(context)!.settings.arguments as ChatData;
    final viewModel = ref.read(chatRoomProvider.notifier);
    final chatroomState = ref.watch(chatRoomProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${chatData.sellerName}님과의 약속',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTitle('날짜'),
            SizedBox(height: 8),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                height: 47,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: _defaultBoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.month}월 ${selectedDate!.day}일 ${_getWeekday(selectedDate!.weekday)}'
                          : '날짜 선택',
                      style: TextStyle(
                          color: selectedDate == null
                              ? Colors.grey
                              : Colors.black),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildTitle('시간'),
            SizedBox(height: 8),
            GestureDetector(
              onTap: _selectTime,
              child: Container(
                height: 47,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: _defaultBoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedTime != null
                          ? selectedTime!.format(context)
                          : '시간 선택',
                      style: TextStyle(
                          color: selectedTime == null
                              ? Colors.grey
                              : Colors.black),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildTitle('장소'),
            SizedBox(height: 8),
            GestureDetector(
              onTap: _selectLocation,
              child: Container(
                height: 47,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: _defaultBoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedLocation,
                      style: TextStyle(
                          color: selectedLocation == '장소 선택'
                              ? Colors.grey
                              : Colors.black),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildTitle('장소 상세 설명'),
            SizedBox(height: 8),
            TextFormField(
                decoration: InputDecoration(
              focusColor: Colors.grey,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            )),
            SizedBox(height: 16),
            _buildTitle('약속 전 나에게 알림'),
            SizedBox(height: 8),
            GestureDetector(
              onTap: _selectNotification,
              child: Container(
                height: 47,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: _defaultBoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedNotification,
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: ElevatedButton(
          onPressed: () {
            ChatMessage chatSendMessage = ChatMessage(
              chatRoomId: chatData.chatroomId,
              userId: chatData.senderId,
              date: selectedDate.toString(),
              time: selectedTime.toString(),
              location: selectedLocation,
              // TODO : selectedNotification int로 수정 , description controller추가
              //   String selectedNotification = '30분 전';
            );
            viewModel.sendMessage(chatSendMessage);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('완료', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
    );
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return '월요일';
      case 2:
        return '화요일';
      case 3:
        return '수요일';
      case 4:
        return '목요일';
      case 5:
        return '금요일';
      case 6:
        return '토요일';
      case 7:
        return '일요일';
      default:
        return '';
    }
  }
}
