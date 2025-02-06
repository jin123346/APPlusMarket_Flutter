import 'package:applus_market/ui/pages/auth/find_id_page/widgets/find_id_body.dart';
import 'package:applus_market/ui/pages/auth/find_pass_page/widgets/find_pass_body.dart';
import 'package:applus_market/ui/pages/auth/find_pass_page/widgets/find_pass_change_body.dart';
import 'package:flutter/material.dart';

class FindPassChangePage extends StatelessWidget {
  FindPassChangePage({super.key});

  TextEditingController newController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                // TODO : Navigator 참조
                Navigator.popAndPushNamed(context, '/find_pass');
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: Text('비밀번호 재설정'),
        ),
        body: FindPassChangeBody(
            newController: newController, confirmController: confirmController),
      ),
    );
  }
}
