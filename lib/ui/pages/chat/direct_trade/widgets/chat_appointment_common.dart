import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void selectNotification(
    BuildContext context, List<String> options, Function(String) onSelected) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((String option) {
            return ListTile(
              title: Text(option),
              onTap: () {
                onSelected(option);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      );
    },
  );
}

String formatTimeOfDay(TimeOfDay time) {
  final now = DateTime.now();
  final dateTime =
      DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat('hh:mm a').format(dateTime); // 12시간제 (AM/PM) 형식 변환
}

String getWeekday(int weekday) {
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

BoxDecoration defaultBoxDecoration() {
  return BoxDecoration(
    border: Border.all(color: Colors.grey.shade300),
    borderRadius: BorderRadius.circular(10),
  );
}

Widget buildTitle(String title) {
  return Text(
    title,
    style: TextStyle(
        fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
  );
}

Widget buildSelectionContainer(String text) {
  return Container(
    height: 47,
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: defaultBoxDecoration(),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: TextStyle(color: Colors.black)),
        Icon(Icons.arrow_drop_down, color: Colors.grey),
      ],
    ),
  );
}
