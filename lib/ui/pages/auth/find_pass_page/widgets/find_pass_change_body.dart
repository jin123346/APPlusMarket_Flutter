import 'package:applus_market/_core/components/size.dart';
import 'package:flutter/material.dart';

class FindPassChangeBody extends StatelessWidget {
  FindPassChangeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드가 올라왔을 때 화면 조정
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // 화면 터치 시 키보드 닫기
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  Text(
                    '새로운 \n비밀번호를 입력해주세요',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    cursorColor: Colors.grey[600],
                    cursorHeight: 20,
                    decoration: InputDecoration(
                      labelText: ' 새 비밀번호*',
                      labelStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '아이디를 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: space16),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress, // 이메일 입력용 키보드 타입
                    cursorColor: Colors.grey[600],
                    decoration: InputDecoration(
                      labelText: ' 새 비밀번호 확인*',
                      labelStyle: TextStyle(color: Colors.grey.shade500),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Spacer(), // 남은 공간을 채우기 위해 Spacer 추가
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
                    // 아이디 찾기 로직
                    Navigator.pushNamed(context, '/pass_change_result');
                  },
                  child: Text('비밀번호 변경'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
