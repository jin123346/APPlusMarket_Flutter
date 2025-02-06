import 'package:applus_market/data/model_view/user/find_user_vm.dart';
import 'package:applus_market/ui/pages/auth/find_id_page/widgets/find_id_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FindIdPage extends ConsumerWidget {
  FindIdPage({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FindUserVm findUserVm = ref.read(findUserProvider.notifier);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                nameController.clearComposing();
                emailController.clearComposing();
                findUserVm.clearState();
                Navigator.pushNamed(context, '/login');
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: Text('아이디 찾기'),
        ),
        body: FindIdBody(nameController, emailController),
      ),
    );
  }
}
