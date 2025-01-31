import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../_core/components/size.dart';
import '../../../../_core/components/theme.dart';
import '../../../_core/utils/logger.dart';
import '../../widgets/applus_text_logo.dart';
import 'widgets/notification_toggle.dart';

/*
 2025.01.22 하진희 : 앱설정 화면 구현
 */

class MySettingsPage extends StatelessWidget {
  const MySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    logger.d('설정페이지 화면 build');
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey[200],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            title: Text('설정'),
          ),
          _buildPushAlarm(),
          SliverToBoxAdapter(
            child: SizedBox(height: 8), // 20px 높이의 빈 공간 추가
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    Text(
                      '기타설정',
                      style: CustomTextTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        '캐시 데이터 삭제',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 15, color: Colors.grey),
                      onTap: () {
                        // 캐시 데이터 삭제 기능 추가
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            title: Center(
                              child: Text(
                                '캐시 데이터를 삭제하시겠습니까?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            content:
                                SizedBox(height: 0), // Removes extra padding
                            actionsPadding: const EdgeInsets.all(0),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      '취소',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.grey[200],
                                      // minimumSize: Size(150, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Add cookie deletion logic here
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('캐시 데이터가 삭제되었습니다.'),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      '확인',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      minimumSize: Size(150, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        '쿠키 삭제',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 18, color: Colors.grey),
                      onTap: () {
                        // 쿠키 삭제 기능 추가
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            title: Center(
                              child: Text(
                                '쿠키 데이터를 삭제하시겠습니까?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            content:
                                SizedBox(height: 0), // Removes extra padding
                            actionsPadding: const EdgeInsets.all(0),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      '취소',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.grey[200],
                                      minimumSize: Size(150, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Add cookie deletion logic here
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('쿠키 데이터가 삭제되었습니다.'),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      '확인',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      minimumSize: Size(150, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: space32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(space8)),
                                color: Colors.white,
                              ),
                              child: APPlusTextLogo(
                                size: 18,
                              ),
                              padding: EdgeInsets.all(space8),
                            ),
                            const SizedBox(width: halfPadding),
                            Text('현재버전 0.0.1'),
                          ],
                        ),
                        Text(
                          '최신 버전 사용중',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  _buildPushAlarm() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(commonPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '푸시알림',
                style: CustomTextTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '새로운 제품과 다양한 소식을 받으세요!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  NotificationToggle(),
                ],
              ),
              SizedBox(height: 10),
              Text(
                '알람이 오지 않거나 알림 받기가 안되는 경우\n'
                '기기 설정에서 알림 허용이 필요해요',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 35,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 16),
                        side: BorderSide(color: Colors.grey.shade500)),
                    onPressed: () {},
                    child: Text(
                      '기기 알림 켜기',
                      style: TextStyle(
                          color: Colors.black45, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
