import 'package:applus_market/ui/pages/auth/find_id_page/widgets/find_id_body.dart';
import 'package:applus_market/ui/pages/auth/find_pass_page/widgets/find_pass_body.dart';
import 'package:applus_market/ui/pages/auth/find_pass_page/widgets/find_pass_change_body.dart';
import 'package:flutter/material.dart';

class FindPassPage extends StatelessWidget {
  FindPassPage({super.key});
  TextEditingController uidController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                // TODO : Navigator 참조
                Navigator.pushNamed(context, '/login');
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: Text('비밀번호 재설정'),
        ),
        body: FindPassBody(
            uidController: uidController, emailController: emailController),
      ),
    );
  }
}
