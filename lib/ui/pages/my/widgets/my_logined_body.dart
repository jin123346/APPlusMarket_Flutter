import 'package:applus_market/_core/utils/dialog_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../_core/components/size.dart';
import '../../../../_core/components/theme.dart';
import '../../../../data/gvm/session_gvm.dart';
import '../../../../data/model/auth/login_state.dart';
import '../../../widgets/applus_pay_text_logo.dart';
import 'profile_card.dart';

class MyLoginedBody extends ConsumerWidget {
  const MyLoginedBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SessionGVM loginNotifier = ref.read(LoginProvider.notifier);
    SessionUser sessionUser = ref.watch(LoginProvider);

    return ListView(
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
                    _buildIconContainer('구매내역', Icons.shopping_bag_outlined),
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCountContainer('전체', 1),
                    Container(
                        height: 15, width: 1, color: Colors.grey.shade300),
                    _buildCountContainer('예약중', 1),
                    Container(
                        height: 15, width: 1, color: Colors.grey.shade300),
                    _buildCountContainer('채팅중', 0),
                    Container(
                        height: 15, width: 1, color: Colors.grey.shade300),
                    _buildCountContainer('종료', 0),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: EdgeInsets.zero,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(commonPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '마이메뉴',
                  style: getTextTheme(context).titleMedium,
                ),
                const SizedBox(height: 20),
                _buildListTile(
                    title: '회원정보',
                    onTap: () {
                      print('관심목록 클릭됨');
                      Navigator.pushNamed(context, '/my/info');
                    }),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  title: APPlusPayTextLogo(size: 16, spacing: 0.8),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 16.0, color: Colors.grey), // 오른쪽 화살표
                  onTap: () {
                    print('애쁠 페이');
                    DialogHelper.showAlertDialog(
                        context: context,
                        title: '애플페이를 시작하시겠습니까?',
                        isCanceled: true,
                        onConfirm: () {
                          //1. 계좌 생성하는 메서드가 호출되어야함
                          //2. 계좌 생성후 Navigiagto
                          //ref.read(accountProvider.notifier).createAccount(sessionUser.id);

                          /*
                      crateAccount 메서드
                           try{
                                if(id == null){return;}
                                Map<String,dynamic> resBody = accountRepository.createAccount(id);
                                    {//여기는 레파지토리 안
                                        Response response = await dio.get('/pay/account/{id}')
                                        Map<String,dynamic> resBody = response.data;
                                        retrun resBody;
                                        //백단 요청
                                    }

                                   if(resBody['status']== failed'){
                                   CustomSnackbar.
                                      return ;
                                   }
                                   //상태값 변화

                                   Map<String,dynamic> data = resBody['data'];
                                     Navigator.pushNamed(context,'my/payHome');



                            }catch(e){
                           }
                       */
                        });
                  }, // 클릭 이벤트
                ),
                _buildListTile(
                  title: '리뷰 작성하기',
                  onTap: () {
                    print('구매내역 클릭됨');
                  },
                ),
                _buildListTile(
                  title: '회원 탈퇴',
                  onTap: () {
                    print('구매내역 클릭됨');
                    Navigator.pushNamed(context, '/withdrawal');
                  },
                ),
                const SizedBox(height: 50),
                Center(
                  child: SizedBox(
                    width: getParentWith(context),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black45,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.black45)),
                          minimumSize: const Size(44, 44),
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          loginNotifier.logout();
                        },
                        child: Text('로그아웃')),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  _buildCountContainer(String text, int count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 8),
        Text(
          '$count',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  _buildIconContainer(String name, IconData mIcon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          mIcon,
          size: 25,
        ),
        const SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
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
