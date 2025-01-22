import 'package:flutter/material.dart';

class MySettingsPage extends StatelessWidget {
  const MySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/my');
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text('설정'),
      ),
      body: ListView(),
    ));
  }
}
