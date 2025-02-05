import 'package:flutter/material.dart';
import '../../../../_core/utils/logger.dart';
import '../../../../_core/components/theme.dart';
import 'pay_amount_input_page.dart';

/**
 * 2025.01.24 - 김민희 : 송금 화면 구현
 * 2025.01.26 - 김민희 : 은행 선택 -> 모달 위젯 ()
 * 2025.01.27 - 김민희 : StatefulWidget 변환 및 컨트롤러 추가
 */

class PaySendPage extends StatefulWidget {
  const PaySendPage({super.key});

  @override
  State<PaySendPage> createState() => _PaySendPageState();
}

class _PaySendPageState extends State<PaySendPage> {
  // 컨트롤러 선언
  final TextEditingController accountController = TextEditingController();
  final TextEditingController bankController = TextEditingController();

  // 다음 버튼 활성화 상태
  bool isNextEnabled = false;

  @override
  void initState() {
    super.initState();
    // 텍스트 필드 변경 감지
    accountController.addListener(_validateInputs);
    bankController.addListener(_validateInputs);
  }

  // 입력값 검증
  void _validateInputs() {
    setState(() {
      isNextEnabled =
          accountController.text.isNotEmpty && bankController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    accountController.dispose();
    bankController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('🍎 송금 클릭 <---------------');
    return Scaffold(
      // iOS 스타일 네비게이션 바
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: APlusTheme.labelPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '계좌송금',
          style: CustomTextTheme.titleMedium,
        ),
        actions: [
          TextButton(
            onPressed:
                isNextEnabled ? () => _navigateToAmountPage(context) : null,
            child: Text(
              '다음',
              style: TextStyle(
                color: isNextEnabled
                    ? APlusTheme.labelPrimary
                    : APlusTheme.labelTertiary,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: APlusTheme.systemBackground,
      body: Padding(
        padding: EdgeInsets.all(APlusTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 계좌번호 입력 필드
            TextField(
              controller: accountController,
              decoration: InputDecoration(
                hintText: '계좌번호를 입력하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(APlusTheme.radiusM),
                  borderSide: BorderSide(color: APlusTheme.borderLightGrey),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: APlusTheme.spacingM),

            // 은행 선택 필드
            TextField(
              controller: bankController,
              decoration: InputDecoration(
                hintText: '은행을 선택하세요',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(APlusTheme.radiusM),
                  borderSide: BorderSide(color: APlusTheme.borderLightGrey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(APlusTheme.radiusM),
                  borderSide: BorderSide(color: APlusTheme.borderLightGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(APlusTheme.radiusM),
                  borderSide: BorderSide(color: APlusTheme.borderLightGrey),
                ),
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: APlusTheme.borderLightGrey,
                ),
              ),
              readOnly: true,
              onTap: () => _showBankSelector(context), // 은행 선택 모달 표시
            ),
            SizedBox(height: APlusTheme.spacingM),

            // 다음 버튼
            Container(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed:
                    isNextEnabled ? () => _navigateToAmountPage(context) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isNextEnabled
                      ? APlusTheme.primaryColor
                      : Color(0xFFDDDEE3),
                  foregroundColor:
                      isNextEnabled ? Colors.white : Color(0xFFADB0B7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(APlusTheme.radiusM),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  '다음',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // 내 계좌
            Padding(
              padding: EdgeInsets.only(
                top: APlusTheme.spacingXL,
                bottom: APlusTheme.spacingM,
              ),
              child: Text(
                '내 계좌',
                style: CustomTextTheme.titleLarge,
              ),
            ),

            // 계좌 정보 카드
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(APlusTheme.radiusM),
                side: BorderSide(color: APlusTheme.borderLightGrey),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(APlusTheme.spacingM),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/pay/bank_ibk.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '기업',
                      style: CustomTextTheme.titleMedium,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          '315068864010111',
                          style: CustomTextTheme.bodyLarge?.copyWith(
                            color: APlusTheme.labelSecondary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: APlusTheme.secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '주계좌',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () => _selectMyAccount(), // 내 계좌 선택 처리
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 금액 입력 페이지로 이동
  void _navigateToAmountPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PayAmountInputPage(
          accountNumber: accountController.text,
          bankName: bankController.text,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  // 은행 선택 모달
  void _showBankSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('국민은행'),
            onTap: () {
              setState(() {
                bankController.text = '국민은행';
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('신한은행'),
            onTap: () {
              setState(() {
                bankController.text = '신한은행';
              });
              Navigator.pop(context);
            },
          ),
          // 더 많은 은행 추가
        ],
      ),
    );
  }

  // 내 계좌 선택 처리
  void _selectMyAccount() {
    setState(() {
      accountController.text = '315068864010111';
      bankController.text = '기업';
      _validateInputs();
    });
  }
}
