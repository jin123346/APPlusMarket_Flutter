import 'package:applus_market/screens/my/components/profile_card.dart';
import 'package:applus_market/size.dart';
import 'package:applus_market/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Icon(Icons.arrow_back_ios),
          title: Text('마이페이지'),
          actions: [
            Icon(Icons.settings_outlined),
            const SizedBox(width: 4),
            Icon(Icons.shopping_bag_outlined),
            const SizedBox(width: 16)
          ],
        ),
        backgroundColor: Colors.grey[100],
        body: ListView(
          children: [
            ProfileCard(),
            const SizedBox(height: 8),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //관심목록
                        _buildIconContainer('관심목록', CupertinoIcons.heart),
                        //판매내역
                        _buildIconContainer('판매내역', CupertinoIcons.list_bullet),

                        //구매내역
                        _buildIconContainer(
                            '구매내역', Icons.shopping_bag_outlined),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //관심목록
                        _buildIconContainer('상점후기', Icons.rate_review_outlined),
                        //판매내역
                        _buildIconContainer('친구초대', Icons.people_outline),

                        //구매내역
                        _buildIconContainer(
                            '공지사항', Icons.indeterminate_check_box_outlined),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '나의 거래',
                      style: getTextTheme(context).titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCountContainer('전체', 1),
                        Container(height: 15, width: 1, color: Colors.black54),
                        _buildCountContainer('예약중', 1),
                        Container(height: 15, width: 1, color: Colors.black54),
                        _buildCountContainer('채팅중', 0),
                        Container(height: 15, width: 1, color: Colors.black54),
                        _buildCountContainer('종료', 0),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      '판매',
                      style: getTextTheme(context).titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCountContainer('전체', 1),
                        Container(height: 15, width: 1, color: Colors.black54),
                        _buildCountContainer('예약중', 1),
                        Container(height: 15, width: 1, color: Colors.black54),
                        _buildCountContainer('채팅중', 0),
                        Container(height: 15, width: 1, color: Colors.black54),
                        _buildCountContainer('종료', 0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  children: [
                    _buildListTile(
                        title: '찜목록',
                        icon: CupertinoIcons.heart,
                        onTap: () {
                          print('관심목록 클릭됨');
                        }),
                    Divider(color: Colors.grey.shade300, thickness: 1), // 구분선
                    _buildListTile(
                        title: '판매내역',
                        icon: CupertinoIcons.square_list,
                        onTap: () {
                          print('판매내역 클릭됨');
                        }),
                    Divider(color: Colors.grey.shade300, thickness: 1), // 구분선
                    _buildListTile(
                        title: '구매내역',
                        icon: Icons.shopping_bag_outlined,
                        onTap: () {
                          print('구매내역 클릭됨');
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCountContainer(String text, int count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        Text('$count'),
      ],
    );
  }

  _buildIconContainer(String name, IconData mIcon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          mIcon,
          size: 30,
        ),
        Text(
          name,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey,
        size: iconList,
      ), // 아이콘
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400), // 텍스트 스타일
      ),
      trailing: Icon(Icons.arrow_forward_ios,
          size: 16.0, color: Colors.grey), // 오른쪽 화살표
      onTap: onTap, // 클릭 이벤트
    );
  }
}
