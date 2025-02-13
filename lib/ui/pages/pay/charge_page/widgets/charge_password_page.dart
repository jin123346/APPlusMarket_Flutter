import 'package:flutter/material.dart';

import '../../../../../../_core/utils/logger.dart';
import '../../../../../_core/utils/logger.dart';


// 2025.02.12 - 김민희 : 충전 비밀번호 입력 페이지 구현
//                     (6자리 비밀번호 키패드 및 결제 취소 기능 구현)

class ChargePasswordPage extends StatefulWidget {
  @override
  _ChargePasswordPageState createState() => _ChargePasswordPageState();
}

class _ChargePasswordPageState extends State<ChargePasswordPage> {
  // 행위 [x] 닫기 확인 다이얼로그 표시 메서드
  Future<void> _showExitDialog(BuildContext context) async {
    logger.d(' ❌ 비밀번호 입력창을 닫으시겠읍니까 -? ');
    return showDialog(
      context: context,
      barrierDismissible: false, // 배경 터치로 닫기 방지
      builder: (BuildContext context) {
        return AlertDialog(
          // 제목 부분
          title: Text(
            '충전을 취소하시겠습니까?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          // 내용 부분
          content: Text(
            '충전 진행이 취소되며, 처음부터 다시 시도하셔야 합니다.',
            style: TextStyle(fontSize: 14),
          ),
          // 버튼 부분
          actions: <Widget>[
            // 취소 버튼
            TextButton(
              child: Text(
                '취소',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
            // 확인 버튼
            TextButton(
              child: Text(
                '확인', // 충전 취소
                style: TextStyle(
                  color: Color(0xFFFF3B30),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pop(); // 페이지 닫기
              },
            ),
          ],
        );
      },
    );
  }

  // 입력된 비밀번호를 저장할 리스트
  List<String> _inputNumbers = [];
  // 비밀번호 최대 길이
  final int _maxLength = 6;

  // 키패드 숫자 버튼 생성 메서드
  // 🔐 비밀번호 입력 확인 및 페이지 이동 로직 추가
  Widget _buildNumberButton(String number) {
    logger.d('여기는 충전 비밀번호 페이지 ChargePasswordPage()');
    return Container(
      margin: EdgeInsets.all(10),
      child: MaterialButton(
        onPressed: () {
          if (_inputNumbers.length < _maxLength) {
            setState(() {
              _inputNumbers.add(number);
            });
          }
        },
        child: Text(
          number,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        height: 75,
        minWidth: 75,
        shape: CircleBorder(),
        color: Colors.white,
      ),
    );
  }

  // 비밀번호 인디케이터 생성 메서드
  Widget _buildPasswordIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _maxLength,
        (index) => Container(
          margin: EdgeInsets.all(8),
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < _inputNumbers.length
                ? Color(0xFFFF3B30)
                : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // 상단 닫기 버튼
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                // 닫기 기능 구현
                // 닫기 버튼 클릭 시 다이얼로그 표시
                onPressed: () => _showExitDialog(context),
              ),
            ),

            // 상단 잠금 아이콘
            SizedBox(height: 20),
            Icon(
              Icons.lock_outline,
              size: 40,
              color: Color(0xFFFF3B30),
            ),

            // "결제 비밀번호를 입력해주세요" 텍스트
            SizedBox(height: 20),
            Text(
              '비밀번호를 입력해주세요',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            // 비밀번호 인디케이터
            SizedBox(height: 40),
            _buildPasswordIndicator(),

            // 키패드
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: ['1', '2', '3']
                          .map((number) => _buildNumberButton(number))
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: ['4', '5', '6']
                          .map((number) => _buildNumberButton(number))
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: ['7', '8', '9']
                          .map((number) => _buildNumberButton(number))
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(width: 95), // 빈 공간
                        _buildNumberButton('0'),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: MaterialButton(
                            onPressed: () {
                              if (_inputNumbers.isNotEmpty) {
                                setState(() {
                                  _inputNumbers.removeLast();
                                });
                              }
                            },
                            child: Icon(Icons.backspace_outlined),
                            height: 75,
                            minWidth: 75,
                            shape: CircleBorder(),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
