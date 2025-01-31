import 'package:applus_market/_core/components/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../_core/components/theme.dart';
import 'widgets/custom_textfield.dart';
import 'widgets/custom_two_button.dart';
import 'widgets/delivery_address_page.dart';
import 'widgets/delivery_body.dart';

class DeliveryPage extends StatelessWidget {
  DeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('마이페이지'),
          actions: [
            InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/my/settings');
                },
                child: Icon(Icons.settings_outlined)),
            const SizedBox(width: 16)
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '배송지 관리',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '* 주문시 기본 배송지로 자동 설정됩니다.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade500)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: true,
                          groupValue: true,
                          onChanged: (value) => !isSelected,
                          activeColor: Colors.black,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '[기본배송지/부산]',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '김민희',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '01057843378 / 010-5784-3378',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1, // 최대 줄 수 제한 설정
                                  '부산 사상구 모라로 136-20 (학산그린타운) 101-606',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 배송지 추가 기능
                        Navigator.pushNamed(context, '/my/delivery/register');
                      },
                      child: Text(
                        '배송지 추가',
                        style: CustomTextTheme.bodyMedium,
                      ),
                      style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.zero),
                          backgroundColor: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                CustomTwoButton(
                  button1: '배송지 삭제',
                  button2: '배송지 수정',
                  button1Function: () {},
                  button2Function: () {
                    //배송지 insert 로직 추가
                    Navigator.pushNamed(context, '/my/delivery/register');
                  },
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
