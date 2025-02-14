import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../_core/utils/logger.dart';
import '../../pay_home_page.dart';

class ChargeCompletePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.d('👏 충전 완료 ChargeCompletePage() ');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40),
              child: Icon(
                Icons.check_circle,
                color: Colors.deepOrange,
                size: 60,
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                '김민희님\n1,000원이 충전되었습니다',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // *** 송금 상세 정보 -> 충전 상세 정보
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildInfoRow('충전 계좌', '기업 01057843378'),
                  _buildInfoRow('수수료', '0원 (무료 4회 남음)'),
                ],
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      // 버튼 클릭 처리
                      logger.i('🍎 여기는 충전 완료 페이지 → ((확인)) 버튼 클릭 이벤트 발생 !!!');
                      Navigator.pushReplacement(
                        // 충전 완료 페이지 → 애쁠 페이 홈 이동 (뒤로 가기 x)
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: PayHomePage(),
                          duration:
                              Duration(milliseconds: 300), // 3초 후 이동 (사용자 ux)
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF3B30),
                      // primary: Colors.deepOrange,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('확인'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey)),
          Text(value),
        ],
      ),
    );
  }
}
