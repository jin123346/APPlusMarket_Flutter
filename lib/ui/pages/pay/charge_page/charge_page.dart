import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../_core/utils/logger.dart';
import '../../../../_core/components/theme.dart';

/**
 * 2025.02.04 - 충전 페이지 구현
 * - iOS 스타일 준수
 * - 금액 입력 기능 구현
 * - 빠른 금액 선택 기능 추가
 */

class ChargePage extends StatefulWidget {
  const ChargePage({super.key});

  @override
  State<ChargePage> createState() => _ChargeMoneyPageState();
}

class _ChargeMoneyPageState extends State<ChargePage> {
  // 현재 입력된 금액
  String _currentAmount = '';

  // 충전 버튼 활성화 상태
  bool get _isChargeEnabled =>
      _currentAmount.isNotEmpty && int.parse(_currentAmount) > 0;

  // 금액 입력 처리
  void _handleNumberInput(String value) {
    setState(() {
      if (_currentAmount.length < 8) {
        // 최대 천만원까지 입력 가능
        _currentAmount += value;
      }
    });
  }

  // 백스페이스 처리
  void _handleBackspace() {
    setState(() {
      if (_currentAmount.isNotEmpty) {
        _currentAmount = _currentAmount.substring(0, _currentAmount.length - 1);
      }
    });
  }

  // 빠른 금액 선택
  void _handleQuickAmount(int amount) {
    setState(() {
      _currentAmount = amount.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.d('💰 충전 페이지 진입');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: APlusTheme.labelPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '충전',
          style: CustomTextTheme.titleMedium,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 계좌 정보
            Padding(
              padding: EdgeInsets.all(APlusTheme.spacingM),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/pay/bank_ibk.png',
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '내 기업은행 계좌에서',
                        style: CustomTextTheme.bodyLarge,
                      ),
                      Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '3150688640101',
                    style: CustomTextTheme.titleLarge,
                  ),
                ],
              ),
            ),

            // 금액 표시
            Padding(
              padding: EdgeInsets.symmetric(vertical: APlusTheme.spacingL),
              child: Column(
                children: [
                  Text(
                    '얼마를 충전할까요?',
                    style: CustomTextTheme.titleLarge,
                  ),
                  SizedBox(height: APlusTheme.spacingM),
                  Text(
                    '당근머니 잔액 ${_currentAmount.isEmpty ? "0" : _currentAmount}원',
                    style: CustomTextTheme.bodyMedium?.copyWith(
                      color: APlusTheme.labelSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // 빠른 금액 선택
            Padding(
              padding: EdgeInsets.symmetric(horizontal: APlusTheme.spacingM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickAmountButton(10000, '+1만원'),
                  _buildQuickAmountButton(50000, '+5만원'),
                  _buildQuickAmountButton(100000, '+10만원'),
                ],
              ),
            ),

            // 숫자 키패드
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                children: [
                  ...List.generate(
                      9, (index) => _buildKeypadButton((index + 1).toString())),
                  _buildKeypadButton('00'),
                  _buildKeypadButton('0'),
                  _buildKeypadButton('←', isBackspace: true),
                ],
              ),
            ),

            // 충전하기 버튼
            Padding(
              padding: EdgeInsets.all(APlusTheme.spacingM),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isChargeEnabled ? () => _handleCharge() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isChargeEnabled
                        ? APlusTheme.primaryColor
                        : APlusTheme.borderLightGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(APlusTheme.radiusM),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    '충전하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _isChargeEnabled
                          ? Colors.white
                          : APlusTheme.labelTertiary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 빠른 금액 선택 버튼 위젯
  Widget _buildQuickAmountButton(int amount, String label) {
    return OutlinedButton(
      onPressed: () => _handleQuickAmount(amount),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(color: APlusTheme.borderLightGrey),
      ),
      child: Text(
        label,
        style: CustomTextTheme.bodyMedium,
      ),
    );
  }

  // 키패드 버튼 위젯
  Widget _buildKeypadButton(String text, {bool isBackspace = false}) {
    return TextButton(
      onPressed: () =>
          isBackspace ? _handleBackspace() : _handleNumberInput(text),
      style: TextButton.styleFrom(
        foregroundColor: APlusTheme.labelPrimary,
        padding: EdgeInsets.zero,
      ),
      child: isBackspace
          ? Icon(Icons.backspace_outlined)
          : Text(
              text,
              style: CustomTextTheme.titleLarge,
            ),
    );
  }

  // 충전 처리
  void _handleCharge() {
    // TODO: 충전 로직 구현 (2025.02.04 화)
    logger.d('💰 충전 금액: $_currentAmount원');
  }
}
