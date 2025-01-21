import 'package:applus_market/theme.dart';
import 'package:flutter/material.dart';
import '../../common/components/image_container.dart';

/*
* 2025.01.21 하진희 : 프로필 카드-  myPage의 상단 프로필 부분
* */

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                    ),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: ImageContainer(
                        width: 80,
                        height: 80,
                        borderRadius: 20,
                        imgUri: 'https://picsum.photos/id/237/200/300',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(17.5),
                              border: Border.all(
                                  color: APlusTheme.borderLightGrey,
                                  width: 0.5)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: AspectRatio(
                              aspectRatio: 3 / 2,
                              child: Image.asset(
                                'assets/icons/magic-wand.png',
                                width: 35,
                                height: 35,
                                fit: BoxFit.contain,
                              ),
                            ),
                          )),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '김민희 님',
                        style: getTextTheme(context).titleLarge,
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                          onDoubleTap: () {
                            print('회원정보클릭!');
                          },
                          child: Text(
                            '회원정보 변경',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300), // 외곽선
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 배송지 관리 버튼
                    InkWell(
                      onTap: () {
                        print('배송지 관리 클릭됨');
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, color: Colors.grey), // 아이콘
                          SizedBox(width: 8.0), // 아이콘과 텍스트 간격
                          Text(
                            '배송지 관리',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    // 구분선
                    Container(
                      height: 20.0,
                      width: 1.0,
                      color: Colors.grey.shade400,
                    ),
                    // PAY 관리 버튼
                    InkWell(
                      onTap: () {
                        //애쁠 페이 홈으로 전환됨
                        Navigator.pushNamed(context, '/payHome');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.payment, color: Colors.grey), // 아이콘
                          SizedBox(width: 8.0), // 아이콘과 텍스트 간격
                          Text(
                            '애쁠 페이',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
