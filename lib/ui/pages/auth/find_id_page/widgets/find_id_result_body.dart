import 'package:applus_market/_core/components/size.dart';
import 'package:flutter/material.dart';

import '../../../../../_core/components/theme.dart';

class FindIdResultBody extends StatelessWidget {
  const FindIdResultBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 230),

                Icon(Icons.check, color: Colors.green, size: 50), // 체크 아이콘
                const SizedBox(height: space16),
                Center(
                  child: Text(
                    '김사장님의 아이디는 bznav****입니다.',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: space8),
                Center(
                  child: Text(
                    '정보 보호를 위해 아이디의 일부만 보입니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const Spacer(), // 남은 공간 채우기
              ],
            ),
          ),
          Positioned(
            bottom:
                MediaQuery.of(context).viewInsets.bottom + 16, // 키보드 위로 버튼 위치
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  //
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: APlusTheme.primaryColor, // 버튼 색상
                  padding: EdgeInsets.symmetric(vertical: 16), // 버튼 높이
                ),
                child: Text('계속 연결하기'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
