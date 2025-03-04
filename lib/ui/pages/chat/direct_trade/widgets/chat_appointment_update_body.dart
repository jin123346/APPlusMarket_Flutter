import 'package:applus_market/_core/components/theme.dart';
import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/chat/chat_data.dart';
import 'package:applus_market/data/model/chat/chat_message.dart';
import 'package:applus_market/ui/pages/chat/direct_trade/widgets/chat_appointment_common.dart';
import 'package:applus_market/ui/pages/chat/room/chat_room_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatAppointmentUpdateBody extends ConsumerStatefulWidget {
  final ChatData? chatData;
  final ChatMessage? chatMessage;
  const ChatAppointmentUpdateBody({super.key, this.chatMessage, this.chatData});

  @override
  ChatAppointmentUpdateBodyState createState() =>
      ChatAppointmentUpdateBodyState();
}

class ChatAppointmentUpdateBodyState
    extends ConsumerState<ChatAppointmentUpdateBody> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  late TextEditingController locationController;
  late TextEditingController descriptionController;
  String selectedNotification = '30분 전';
  int? reminderBefore;
  String? sellerName;

  List<String> notificationOptions = ['10분 전', '30분 전', '1시간 전', '당일'];

  @override
  void initState() {
    super.initState();

    locationController =
        TextEditingController(text: widget.chatMessage?.location ?? '');
    descriptionController = TextEditingController(
        text: widget.chatMessage?.locationDescription ?? '');

    if (widget.chatData != null) {
      sellerName = widget.chatData?.sellerName;
    }
    if (widget.chatMessage != null) {
      if (widget.chatMessage!.date != null) {
        selectedDate = DateTime.parse(widget.chatMessage!.date!);
      }
      if (widget.chatMessage!.time != null) {
        selectedTime = _parseTimeFromString(widget.chatMessage!.time!);
      }
      reminderBefore = widget.chatMessage!.reminderBefore;
      selectedNotification = _getNotificationText(reminderBefore);
    }
  }

  TimeOfDay? _parseTimeFromString(String timeString) {
    // 정규식으로 "TimeOfDay(09:34)"에서 시간과 분을 추출
    final RegExp timeRegex = RegExp(r'TimeOfDay\((\d{2}):(\d{2})\)');
    final match = timeRegex.firstMatch(timeString);

    if (match != null) {
      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      return TimeOfDay(hour: hour, minute: minute);
    }

    // "09:34 AM" 또는 "15:20" 같은 일반 시간 형식도 처리
    if (timeString.contains(":")) {
      var parts = timeString.split(":");
      int hour = int.tryParse(parts[0]) ?? 0;
      int minute = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(hour: hour, minute: minute);
    }

    return null; // 변환 실패 시 null 반환
  }

  @override
  void dispose() {
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  String _getNotificationText(int? reminderBefore) {
    switch (reminderBefore) {
      case 10:
        return '10분 전';
      case 30:
        return '30분 전';
      case 60:
        return '1시간 전';
      case 0:
        return '당일';
      default:
        return '30분 전';
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
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
      initialTime: selectedTime ?? TimeOfDay.now(), // 기존 선택한 시간이 있으면 유지
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(chatRoomProvider.notifier);
    final sessionUser = ref.read(LoginProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('$sellerName과의 약속 수정'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildTitle('날짜'),
            GestureDetector(
              onTap: _selectDate,
              child: buildSelectionContainer(
                selectedDate != null
                    ? '${selectedDate!.month}월 ${selectedDate!.day}일'
                    : '날짜 선택',
              ),
            ),
            buildTitle('시간'),
            GestureDetector(
              onTap: _selectTime,
              child: buildSelectionContainer(
                selectedTime != null
                    ? _formatTimeOfDay(selectedTime!)
                    : '시간 선택',
              ),
            ),
            buildTitle('장소'),
            TextFormField(controller: locationController),
            buildTitle('장소 상세 설명'),
            TextFormField(controller: descriptionController),
            buildTitle('약속 전 알림'),
            GestureDetector(
              onTap: _selectNotification,
              child: buildSelectionContainer(selectedNotification),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            ChatMessage chatSendMessage = ChatMessage(
              messageId: widget.chatMessage!.messageId,
              chatRoomId: widget.chatData!.chatroomId,
              userId: sessionUser.id!,
              date: selectedDate.toString(),
              time: selectedTime != null
                  ? _formatTimeOfDay(selectedTime!)
                  : null, // ✅ 변환된 값 저장
              location: locationController.text,
              locationDescription: descriptionController.text,
            );
            logger.e('chatUpdateMessage : $chatSendMessage');
            viewModel.updateAppointment(chatSendMessage);
            Navigator.pop(context);
          },
          child: Text('완료'),
        ),
      ),
    );
  }
}

String _formatTimeOfDay(TimeOfDay time) {
  final now = DateTime.now();
  final dateTime =
      DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat('hh:mm a').format(dateTime); // 12시간제 (AM/PM) 형식 변환
}
