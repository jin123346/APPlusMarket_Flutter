import 'package:applus_market/_core/theme.dart';
import 'package:flutter/material.dart';

class FindIdResultBody extends StatelessWidget {
  const FindIdResultBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 50), // 체크 아이콘
          SizedBox(height: 16),
          Center(
            child: Text(
              '김사장님의 아이디는 bznav****입니다.',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              '정보 보호를 위해 아이디의 일부만 보입니다.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          // TODO :  버튼 위치 통일감 주기
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              //
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: APlusTheme.primaryColor, // 버튼 색상
              padding: EdgeInsets.symmetric(vertical: 16), // 버튼 높이
            ),
            child: Text('계속 연결하기'),
          ),
        ],
      ),
    );
  }
}
