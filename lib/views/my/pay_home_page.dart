import 'package:flutter/material.dart';
import '../../size.dart';

/**
 * 2025.01.21 - 김민희 : 송금 홈 화면 레이아웃 구현
 */

class PayHomePage extends StatelessWidget {
  const PayHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF0F1F6),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close)),
          title: Image.asset(
            'assets/images/pay/lushpay_logo.png',
            width: 100,
            height: 28,
            fit: BoxFit.cover,
          ),
          actions: [
            // actions 를 AppBar 안으로 이동
            Icon(Icons.settings),
            SizedBox(width: commonPadding),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(commonPadding),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 400,
                color: Color(0xFFFFFFFF),
                child: Row(
                  children: [
                    // logo + 애쁠머니
                    Row(
                      children: [
                        Icon(Icons.monetization_on_sharp),
                        Text('애쁠머니'),
                      ],
                    ),
                    Spacer(),
                    // 내 계좌
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Container(
                            alignment: Alignment.center,
                            width: 80,
                            height: 35,
                            color: Color(0xFFF0F1F6),
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              '내 계좌',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        // Text('내 계좌'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
