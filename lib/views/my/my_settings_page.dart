import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../size.dart';
import '../../theme.dart';
import '../common/utils/logger.dart';
import 'components/notification_toggle.dart';
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
                            title: Text(
                              '캐시 데이터 삭제',
                              style: TextStyle(),
                            ),
                            content: const Text('캐시 데이터를 삭제하시겠습니까?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('취소'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // 여기에 캐시 삭제 로직 추가
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('캐시 데이터가 삭제되었습니다.')),
                                  );
                                },
                                child: const Text('확인'),
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
                            title: const Text('쿠키 삭제'),
                            content: const Text('쿠키 데이터를 삭제하시겠습니까?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('취소'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // 여기에 쿠키 삭제 로직 추가
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('쿠키 데이터가 삭제되었습니다.')),
                                  );
                                },
                                child: const Text('확인'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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
