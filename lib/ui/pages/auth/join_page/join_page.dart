import 'package:flutter/material.dart';
import 'widgets/join_body.dart';

class JoinPage extends StatelessWidget {
  JoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: const Text('회원가입')),
      body: JoinBody(),
    );
  }
}
