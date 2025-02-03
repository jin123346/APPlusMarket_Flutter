import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../_core/components/size.dart';
import '../../../../_core/components/theme.dart';
import '../../../data/gvm/session_gvm.dart';
import 'widgets/my_logined_body.dart';
import 'widgets/profile_card.dart';

/*
* 2025.01.21 하진희 : 마이페이지 구성
* */

class MyLoginedPage extends StatelessWidget {
  const MyLoginedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: Text('마이페이지'),
          actions: [
            InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/my/settings');
                },
                child: Icon(Icons.settings_outlined)),
            const SizedBox(width: 4),
            Icon(Icons.shopping_bag_outlined),
            const SizedBox(width: 16)
          ],
        ),
        backgroundColor: Colors.grey[100],
        body: MyLoginedBody(),
      ),
    );
  }
}
