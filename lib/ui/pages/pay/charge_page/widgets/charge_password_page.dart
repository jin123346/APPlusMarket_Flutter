import 'package:flutter/material.dart';
import '../../../../../../_core/utils/logger.dart';
import 'charge_complete_page.dart';

// ===============================================================
// 📝 2025.02.12 - 김민희
// 목적: 충전 비밀번호 입력 페이지 구현
// 기능:
// 1. 6자리 비밀번호 키패드 구현
// 2. 결제 취소 기능 구현
// 3. 6자리 입력 시 자동 페이지 이동
// ===============================================================

// StatefulWidget: 상태 변경이 필요한 위젯 클래스
class ChargePasswordPage extends StatefulWidget {
  @override
  _ChargePasswordPageState createState() => _ChargePasswordPageState();
}

// State 클래스: 실제 위젯의 상태를 관리하는 클래스
class _ChargePasswordPageState extends State<ChargePasswordPage> {
  // 📌 상태 관리를 위한 변수들
  final List<String> _inputNumbers = []; // 입력된 비밀번호 저장 리스트
  final int _maxLength = 6; // 비밀번호 최대 길이 제한

  // ===============================================================
  // 🔍 비밀번호 검사 및 페이지 이동 메서드
  // TODO: [향후 개발] 실제 비밀번호 유효성 검사 로직 추가 필요
  // - PIN 번호 형식 검사
  // - 서버 측 비밀번호 검증
  // - 보안 관련 추가 검증
  // ===============================================================
  void _checkPasswordAndNavigate() {
    if (_inputNumbers.length == _maxLength) {
      // 🔍 데이터 흐름 추적을 위한 로그
      logger.d('⌨️ 비밀번호 입력 완료: ${_inputNumbers.join('')}');
      logger.d('➡️ ChargeCompletePage 로 이동 준비');

      // UX를 위한 딜레이 후 페이지 이동
      Future.delayed(Duration(milliseconds: 300), () {
        logger.d('🚀 ChargeCompletePage 로 이동 실행');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChargeCompletePage()),
        );
      });
    }
  }

  // ===============================================================
  // 💫 닫기 확인 다이얼로그 표시 메서드
  // 목적: 사용자가 실수로 닫는 것을 방지
  // ===============================================================
  Future<void> _showExitDialog(BuildContext context) async {
    logger.d('❌ 닫기 버튼 클릭: 다이얼로그 표시');
    return showDialog(
      context: context,
      barrierDismissible: false, // 배경 터치로 닫기 방지
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '충전을 취소하시겠습니까?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '충전 진행이 취소되며, 처음부터 다시 시도하셔야 합니다.',
            style: TextStyle(fontSize: 14),
          ),
          actions: <Widget>[
            // ❌ 취소 버튼
            TextButton(
              child: Text('취소', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                logger.d('📌 다이얼로그 취소 버튼 클릭');
                Navigator.of(context).pop(); // 다이얼로그만 닫기
              },
            ),
            // ✅ 확인 버튼
            TextButton(
              child: Text('확인', style: TextStyle(color: Color(0xFFFF3B30))),
              onPressed: () {
                logger.d('📌 다이얼로그 확인 버튼 클릭: 페이지 종료');
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pop(); // 페이지 닫기
              },
            ),
          ],
        );
      },
    );
  }

  // ===============================================================
  // 🔢 키패드 숫자 버튼 생성 메서드
  // 목적: 재사용 가능한 숫자 버튼 위젯 생성
  // ===============================================================
  Widget _buildNumberButton(String number) {
    return Container(
      margin: EdgeInsets.all(10),
      child: MaterialButton(
        onPressed: () {
          if (_inputNumbers.length < _maxLength) {
            setState(() {
              _inputNumbers.add(number);
              // 🔍 숫자 입력 추적
              logger.d('📱 숫자 입력: $number, 현재 길이: ${_inputNumbers.length}');
            });
            _checkPasswordAndNavigate(); // 비밀번호 길이 검사
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

  // ===============================================================
  // 🔒 비밀번호 입력 상태 표시 인디케이터 생성 메서드
  // 목적: 사용자에게 비밀번호 입력 진행 상태를 시각적으로 표시
  // ===============================================================
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
            // 입력된 숫자만큼 빨간색으로 표시, 나머지는 회색
            color: index < _inputNumbers.length
                ? Color(0xFFFF3B30)
                : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // 📱 메인 UI 빌드 메서드
  // ===============================================================
  @override
  Widget build(BuildContext context) {
    logger.d('🎨 ChargePasswordPage UI 빌드 시작');
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // 🔄 상단 닫기 버튼
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => _showExitDialog(context),
              ),
            ),

            // 🔒 잠금 아이콘
            SizedBox(height: 20),
            Icon(
              Icons.lock_outline,
              size: 40,
              color: Color(0xFFFF3B30),
            ),

            // 📝 안내 텍스트
            SizedBox(height: 20),
            Text(
              '비밀번호를 입력해주세요',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            // 🔢 비밀번호 입력 상태 표시
            SizedBox(height: 40),
            _buildPasswordIndicator(),

            // ⌨️ 키패드 영역
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 숫자 키패드 행 1-9
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
                    // 숫자 0 및 삭제 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(width: 95), // 빈 공간
                        _buildNumberButton('0'),
                        // ⌫ 삭제 버튼
                        Container(
                          margin: EdgeInsets.all(10),
                          child: MaterialButton(
                            onPressed: () {
                              if (_inputNumbers.isNotEmpty) {
                                setState(() {
                                  _inputNumbers.removeLast();
                                  // 🔍 삭제 동작 추적
                                  logger.d(
                                      '⌫ 숫자 삭제: 현재 길이: ${_inputNumbers.length}');
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
