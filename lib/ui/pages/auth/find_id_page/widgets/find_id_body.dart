import 'package:applus_market/_core/utils/custom_snackbar.dart';
import 'package:applus_market/_core/utils/dialog_helper.dart';
import 'package:applus_market/data/model_view/user/find_user_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FindIdBody extends ConsumerWidget {
  TextEditingController nameController;
  TextEditingController emailController;
  FindIdBody(this.nameController, this.emailController, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FindUserVm findUserVm = ref.read(findUserProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드가 올라왔을 때 화면 조정
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // 화면 터치 시 키보드 닫기
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  Text(
                    '이메일로 \n아이디를 확인하세요',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    cursorColor: Colors.grey[600],
                    cursorHeight: 20,
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: ' 이름*',
                      labelStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이름을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress, // 이메일 입력용 키보드 타입
                    cursorColor: Colors.grey[600],
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: ' 이메일*',
                      labelStyle: TextStyle(color: Colors.grey.shade500),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이메일을 입력해주세요';
                      }
                      // 이메일 형식 유효성 검사
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return '유효한 이메일 주소를 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Spacer(), // 남은 공간을 채우기 위해 Spacer 추가
                ],
              ),
            ),
            Positioned(
              bottom:
                  MediaQuery.of(context).viewInsets.bottom + 16, // 키보드 위로 버튼 위치
              left: 16,
              right: 16,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // 입력이 비어 있는지 확인
                    if (nameController.text == '' ||
                        emailController.text == '') {
                      CustomSnackbar.showSnackBar('정보를 모두 입력해주세요');
                      return; // 입력이 없으면 이후 코드 실행을 막음
                    }

                    // 비동기 함수 결과를 기다림
                    bool result = await findUserVm.findUserUid(
                        nameController.text, emailController.text);

                    // 일치하지 않는 경우 처리
                    if (!result) {
                      DialogHelper.showAlertDialog(
                        context: context,
                        title: '일치하는 정보가 없습니다.',
                        content: '다시 시도해주세요.',
                      );
                      return; // 정보를 찾지 못하면 이후 코드 실행을 막음
                    }

                    // 결과가 일치하면 필드 클리어하고, 페이지 이동
                    nameController.clearComposing();
                    emailController.clearComposing();

                    // 페이지 이동
                    Navigator.popAndPushNamed(context, '/find_id_result');
                  },
                  child: Text('아이디 찾기'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
