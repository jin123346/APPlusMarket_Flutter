import 'package:applus_market/ui/pages/my/widgets/my_info_body.dart';
import 'package:flutter/material.dart';

class MyInfoPage extends StatelessWidget {
  MyInfoPage({super.key});
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
            child: Text('저장'),
          ),
        ],
      ),
      body: MyInfoBody(
        formKey: formKey,
      ),
    ));
  }
}
