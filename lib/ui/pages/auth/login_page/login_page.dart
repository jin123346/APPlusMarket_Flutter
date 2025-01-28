import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../_core/size.dart';
import '../../../../_core/theme.dart';
import '../../../../services/api/login_api.dart';
import 'widgets/login_body.dart';
import 'widgets/login_form.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginController loginNotifier =
        ref.read(LoginControllerProvider.notifier);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              // TODO : Navigator 참조
              Navigator.pushNamed(context, '/home');
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      resizeToAvoidBottomInset: false, // 키보드와 bottomNavigationBar 충돌 방지
      body: LoginBody(
        passwordController: loginNotifier.passwordController,
        uidController: loginNotifier.uidController,
        formKey: loginNotifier.formKey,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(halfPadding),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              loginNotifier.login(context);
            },
            child: const Text('로그인'),
          ),
        ),
      ),
    ));
  }
}
