import 'package:applus_market/ui/pages/auth/find_id_page/widgets/find_id_body.dart';
import 'package:applus_market/ui/pages/auth/find_id_page/widgets/find_id_result_body.dart';
import 'package:flutter/material.dart';

class FindIdResultPage extends StatelessWidget {
  const FindIdResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text('아이디 찾기'),
      ),
      body: FindIdResultBody(),
    ),);
  }
}
