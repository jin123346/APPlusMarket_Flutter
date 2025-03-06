import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../_core/utils/logger.dart';
import '../../../../_core/components/theme.dart';
import 'widgets/charge_password_page.dart';

/*
 * 2025.02.04 김민희 - 충전 페이지 구현 (금액 입력 및 빠른 금액 선택 기능)
 * 2025.02.11 김민희 - Provider 연동 준비, 입력값 검증 로직 강화
 */

/// 충전 페이지 위젯
///
/// [StatefulWidget]을 사용하는 이유:
/// 1. 현재 입력된 금액(_currentAmount)의 로컬 상태 관리 필요
/// 2. 사용자 입력에 따른 UI 업데이트 필요
/// 3. 향후 Provider 연동 시 위젯 내부에서 상태 구독 필요

class ChargePage extends StatefulWidget {
  const ChargePage({super.key});

  @override
  State<ChargePage> createState() => _ChargePageState();
}

class _ChargePageState extends State<ChargePage> {
  /// 현재 입력된 금액
  /// 추후 Notifier로 상태 관리 이전 예정
  String _currentAmount = '';

  /// 입력 가능한 최대 금액 (천만원)
  static const int _maxAmount = 10000000;

  /// 충전 버튼 활성화 상태
  ///
  /// 금액이 입력되어 있고, 0원 초과인 경우에만 활성화
  bool get _isChargeButtonEnabled =>
      _currentAmount.isNotEmpty && int.parse(_currentAmount) > 0;

  /// 숫자 입력 처리
  ///
  /// [value]: 입력된 숫자 문자열
  /// 최대 금액(천만원) 초과 입력 방지
  void _onNumberInput(String value) {
    setState(() {
      if (_currentAmount.length < 8) {
        final newAmount = _currentAmount + value;
        if (int.parse(newAmount) <= _maxAmount) {
          _currentAmount = newAmount;
        }
      }
    });
  }

  /// 백스페이스 처리

  /// 입력된 금액이 있는 경우 마지막 숫자 삭제
  void _onBackspacePressed() {
    setState(() {
      if (_currentAmount.isNotEmpty) {
        _currentAmount = _currentAmount.substring(0, _currentAmount.length - 1);
      }
    });
  }

  /// 빠른 금액 선택 처리
  ///
  /// [amount]: 선택된 금액
  /// 최대 금액 초과하지 않는 경우에만 적용
  void _onQuickAmountSelected(int amount) {
    if (amount <= _maxAmount) {
      setState(() {
        _currentAmount = amount.toString();
      });
    }
  }

  /// 충전 요청 처리
  ///
  /// TODO: API 연동 예정
  /// - 충전 요청 API 호출
  /// - 응답 처리 및 에러 핸들링
  /// - 성공/실패 시 피드백 제공
  Future<void> _onChargeRequested() async {
    logger.d('💰 충전 요청 - 금액: $_currentAmount원');
    // TODO: Provider를 통한 충전 요청 처리
    // TODO: 로딩 상태 관리
    // TODO: 에러 핸들링

    logger.d('충전하기 → 비밀번호 입력 페이지 이동 💨 ');
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: ChargePasswordPage(),
        duration: Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    logger.d('''💰 어서오십셔 충전 페이지 'Home' 임미도''');
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildAccountInfo(),
            _buildAmountDisplay(),
            _buildQuickAmountButtons(),
            _buildNumberPad(),
            _buildChargeButton(),
          ],
        ),
      ),
    );
  }

  /// AppBar 구성
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close, color: APlusTheme.labelPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text('충전', style: CustomTextTheme.titleMedium),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  /// 계좌 정보 섹션
  Widget _buildAccountInfo() {
    return Padding(
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
    );
  }

  /// 금액 표시 섹션
  Widget _buildAmountDisplay() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: APlusTheme.spacingL),
      child: Column(
        children: [
          Text(
            '얼마를 충전할까요?',
            style: CustomTextTheme.titleLarge,
          ),
          SizedBox(height: APlusTheme.spacingS),
          if (_currentAmount.isNotEmpty)
            Text(
              '${_currentAmount}원',
              style: CustomTextTheme.titleLarge?.copyWith(
                color: Colors.grey[700], // 회색으로 설정
              ),
            ),
          SizedBox(height: APlusTheme.spacingM),
          Text(
            '애쁠머니 잔액',
            style: CustomTextTheme.bodyMedium?.copyWith(
              color: APlusTheme.labelSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 빠른 금액 선택 버튼 섹션
  Widget _buildQuickAmountButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: APlusTheme.spacingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickAmountButton(10000, '+1만원'),
          _buildQuickAmountButton(50000, '+5만원'),
          _buildQuickAmountButton(100000, '+10만원'),
        ],
      ),
    );
  }

  /// 빠른 금액 선택 버튼 생성
  ///
  /// [amount]: 선택할 금액
  /// [label]: 버튼에 표시될 텍스트
  Widget _buildQuickAmountButton(int amount, String label) {
    return OutlinedButton(
      onPressed: () => _onQuickAmountSelected(amount),
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

  /// 숫자 키패드 섹션
  Widget _buildNumberPad() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        children: [
          ...List.generate(
            9,
            (index) => _buildKeypadButton((index + 1).toString()),
          ),
          _buildKeypadButton('00'),
          _buildKeypadButton('0'),
          _buildKeypadButton('←', isBackspace: true),
        ],
      ),
    );
  }

  // 충전하기 버튼 → 비밀번호 입력 페이지 이동
  Widget _buildChargeButton() {
    return Padding(
      padding: EdgeInsets.all(APlusTheme.spacingM),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isChargeButtonEnabled ? _onChargeRequested : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isChargeButtonEnabled
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
              color: _isChargeButtonEnabled
                  ? Colors.white
                  : APlusTheme.labelTertiary,
            ),
          ),
        ),
      ),
    );
  }

  /// 키패드 버튼 생성
  Widget _buildKeypadButton(String text, {bool isBackspace = false}) {
    return TextButton(
      onPressed: () =>
          isBackspace ? _onBackspacePressed() : _onNumberInput(text),
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
}
