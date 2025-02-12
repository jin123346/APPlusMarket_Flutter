import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model_view/user/my_info_vm.dart';
import 'package:applus_market/ui/pages/my/widgets/my_info_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/auth/user.dart';

class MyInfoPage extends ConsumerWidget {
  MyInfoPage({super.key});
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MyInfoVM myInfoNotifier = ref.read(myInfoProvider.notifier);
    User user = ref.watch(myInfoProvider) ?? User();
    SessionGVM sessionGVM = ref.read(LoginProvider.notifier);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text('회원정보 수정'),
        actions: [
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  // await ref.read(userProfileProvider.notifier).updateProfile();
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('프로필이 업데이트되었습니다')),
                  // );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('업데이트 실패: $e')),
                  );
                }
              }
            },
            child: InkWell(
                onTap: () {
                  myInfoNotifier.updateMyInfo(
                      nickName: nicknameController.text,
                      hp: phoneNumberController.text,
                      email: emailController.text);
                },
                child: Text('저장')),
          ),
        ],
      ),
      body: MyInfoBody(
        formKey: formKey,
        nameController: nameController,
        birthDateController: birthDateController,
        emailController: emailController,
        nicknameController: nicknameController,
        phoneNumberController: phoneNumberController,
      ),
    ));
  }
}
