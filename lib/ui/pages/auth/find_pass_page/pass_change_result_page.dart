import 'package:applus_market/ui/pages/auth/find_id_page/widgets/find_id_body.dart';
import 'package:applus_market/ui/pages/auth/find_id_page/widgets/find_id_result_body.dart';
import 'package:applus_market/ui/pages/auth/find_pass_page/widgets/pass_change_result_body.dart';
import 'package:flutter/material.dart';

class PassChangeResultPage extends StatelessWidget {
  const PassChangeResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              // TODO : 이전 페이지 띄우는 걸로 바꾸기
              Navigator.pushNamed(context, '/find_pass_change');
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text('비밀번호 재설정'),
      ),
      body: PassChangeResultBody(),
    ),);
  }
}
