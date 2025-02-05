import 'package:flutter/material.dart';
import '../../../../_core/utils/logger.dart';
import '../../../../_core/components/theme.dart';

/**
 * 2025.01.27 - 김민희 : 송금 비밀번호 입력 화면 구현
 */

class PayPasswordPage extends StatefulWidget {
  final String accountNumber; // 송금할 계좌번호
  final String bankName; // 은행명
  final int amount; // 송금 금액

  const PayPasswordPage({
    required this.accountNumber,
    required this.bankName,
    required this.amount,
    super.key,
  });

  @override
  State<PayPasswordPage> createState() => _PayPasswordPageState();
}

class _PayPasswordPageState extends State<PayPasswordPage> {
  // 비밀번호 저장 변수
  String password = '';

  // 비밀번호 입력 처리
  void _handleNumberInput(String number) {
    if (password.length < 6) {
      setState(() {
        password += number;
        // 6자리가 모두 입력되면 다음 페이지로 이동
        if (password.length == 6) {
          //_processPayment();
        }
      });
    }
  }

  // 백스페이스 처리
  void _handleBackspace() {
    if (password.isNotEmpty) {
      setState(() {
        password = password.substring(0, password.length - 1);
      });
    }
  }

  // 송금 처리 함수
  // void _processPayment() {
  //   // TODO: 실제 송금 처리 로직 구현
  //   // 송금 진행 페이지로 이동
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => TransferProgressPage(
  //         accountNumber: widgets.accountNumber,
  //         bankName: widgets.bankName,
  //         amount: widgets.amount,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    logger.d('🔒 비밀번호 입력 페이지 <---------------');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: APlusTheme.labelPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '비밀번호 입력',
          style: CustomTextTheme.titleMedium,
        ),
      ),
      backgroundColor: APlusTheme.systemBackground,
      body: Column(
        children: [
          // 송금 정보 표시
          Container(
            padding: EdgeInsets.all(APlusTheme.spacingM),
            child: Column(
              children: [
                Text(
                  '${widget.bankName} ${widget.accountNumber}',
                  style: CustomTextTheme.bodyLarge,
                ),
                SizedBox(height: APlusTheme.spacingS),
                Text(
                  '${widget.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: APlusTheme.labelPrimary,
                  ),
                ),
              ],
            ),
          ),

          // 비밀번호 표시 dots
          Container(
            padding: EdgeInsets.symmetric(
              vertical: APlusTheme.spacingXL,
              horizontal: APlusTheme.spacingL,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < password.length
                        ? APlusTheme.labelPrimary
                        : APlusTheme.borderLightGrey,
                  ),
                ),
              ),
            ),
          ),

          Spacer(), // 키패드를 아래쪽으로 밀어내기 위한 공간

          // 키패드
          Container(
            padding: EdgeInsets.all(APlusTheme.spacingM),
            child: Column(
              children: [
                // 숫자 키패드 행들
                for (var i = 0; i < 3; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      3,
                      (j) => _buildKeypadButton((i * 3 + j + 1).toString()),
                    ),
                  ),
                // 마지막 행 (빈 공간, 0, 백스페이스)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildEmptyButton(),
                    _buildKeypadButton('0'),
                    _buildKeypadButton('←', isBackspace: true),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: APlusTheme.spacingL), // 하단 여백
        ],
      ),
    );
  }

  // 키패드 버튼 위젯
  Widget _buildKeypadButton(String text, {bool isBackspace = false}) {
    return Container(
      width: 80,
      height: 80,
      margin: EdgeInsets.all(5),
      child: TextButton(
        onPressed: () {
          if (isBackspace) {
            _handleBackspace();
          } else {
            _handleNumberInput(text);
          }
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            color: APlusTheme.labelPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // 빈 버튼 위젯
  Widget _buildEmptyButton() {
    return Container(
      width: 80,
      height: 80,
      margin: EdgeInsets.all(5),
    );
  }
}
