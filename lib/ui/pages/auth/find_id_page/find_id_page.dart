import 'package:applus_market/ui/pages/auth/find_id_page/widgets/find_id_body.dart';
import 'package:flutter/material.dart';

class FindIdPage extends StatelessWidget {
  const FindIdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              // TODO : Navigator 참조
              Navigator.pushNamed(context, '/login');
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text('아이디 찾기'),
      ),
      body: FindIdBody(),
    ),);
  }
}
