import 'package:flutter/material.dart';
import '../../../../_core/components/theme.dart';
import '../../../../_core/utils/logger.dart';
import 'pay_password_page.dart';

/**
 * 2025.01.27 - 김민희 : 송금 금액 입력 화면 구현
 */

class PayAmountInputPage extends StatefulWidget {
  final String? accountNumber; // 이전 페이지에서 전달받은 계좌번호 (입력된 계좌번호)
  final String? bankName; // 이전 페이지에서 전달받은 은행명 (선택된 은행명)

  const PayAmountInputPage({
    this.accountNumber,
    this.bankName,
    super.key,
  });

  @override
  State<PayAmountInputPage> createState() => _PayAmountInputPageState();
}

class _PayAmountInputPageState extends State<PayAmountInputPage> {
  // 금액을 문자열로 관리 (콤마 처리를 위해)
  String amount = '';
  bool isNextEnabled = false;

  // 숫자 입력 처리
  void _handleNumberInput(String number) {
    setState(() {
      if (amount.length < 10) {
        // 최대 10자리까지만 입력 가능
        amount += number;
        _validateAmount();
      }
    });
  }

  // 백스페이스 처리
  void _handleBackspace() {
    setState(() {
      if (amount.isNotEmpty) {
        amount = amount.substring(0, amount.length - 1);
        _validateAmount();
      }
    });
  }

  // 금액 유효성 검사
  void _validateAmount() {
    final numericAmount = int.tryParse(amount) ?? 0;
    isNextEnabled = numericAmount > 0 && numericAmount <= 10000000; // 1천만원 제한
  }

  // 금액을 형식화된 문자열로 변환 (예: 1,234,567)
  String _formatAmount() {
    if (amount.isEmpty) return '0';
    final numericAmount = int.tryParse(amount) ?? 0;
    return numericAmount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    logger.d('💰 금액 입력 페이지 <---------------');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: APlusTheme.labelPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '금액 입력',
          style: CustomTextTheme.titleMedium,
        ),
        actions: [
          // TextButton(
          //   onPressed: isNextEnabled
          //       ? () {
          //           // 다음 페이지(비밀번호 입력)로 이동
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => PayPasswordPage(
          //                 accountNumber: widget.accountNumber,
          //                 bankName: bankName,
          //                 amount: int.parse(amount),
          //               ),
          //             ),
          //           );
          //         }
          //       : null,
          //   child: Text(
          //     '다음',
          //     style: TextStyle(
          //       color: isNextEnabled
          //           ? APlusTheme.labelPrimary
          //           : APlusTheme.labelTertiary,
          //     ),
          //   ),
          // ),
        ],
      ),
      backgroundColor: APlusTheme.systemBackground,
      body: Column(
        children: [
          // 수취인 정보
          Container(
            padding: EdgeInsets.all(APlusTheme.spacingM),
            child: Row(
              children: [
                Text(
                  '${widget.bankName} ${widget.accountNumber}',
                  style: CustomTextTheme.bodyLarge,
                ),
              ],
            ),
          ),

          // 금액 표시
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: APlusTheme.spacingL),
              child: Text(
                '${_formatAmount()}원',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: APlusTheme.labelPrimary,
                ),
              ),
            ),
          ),

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
                // 마지막 행 (00, 0, 백스페이스)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildKeypadButton('00'),
                    _buildKeypadButton('0'),
                    _buildKeypadButton('←', isBackspace: true),
                  ],
                ),
              ],
            ),
          ),
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
}
