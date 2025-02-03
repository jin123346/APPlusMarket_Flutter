import 'package:applus_market/_core/components/size.dart';
import 'package:applus_market/_core/components/theme.dart';
import 'package:flutter/material.dart';

class PassChangeResultBody extends StatelessWidget {
  PassChangeResultBody({super.key});

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
                    '성공적으로 비밀번호가 변경되었습니다.',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: space8),
                Center(
                  child: Text(
                    '새로운 비밀번호로 로그인해보세요.',
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
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: APlusTheme.primaryColor, // 버튼 색상
                  padding: EdgeInsets.symmetric(vertical: 16), // 버튼 높이
                ),
                child: Text('로그인'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
