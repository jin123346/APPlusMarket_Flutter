import 'package:applus_market/_core/utils/custom_snackbar.dart';
import 'package:applus_market/data/model/auth/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../_core/utils/logger.dart';
import '../../../../../data/model/auth/sign_up_state.dart';
import '../../../../../services/DateInputFormatter.dart';

class InsertNamePage extends ConsumerStatefulWidget {
  InsertNamePage({super.key});

  @override
  ConsumerState<InsertNamePage> createState() => _InsertNamePageState();
}

class _InsertNamePageState extends ConsumerState<InsertNamePage> {
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode nicknameFocusNode = FocusNode();
  final FocusNode birthFocusNode = FocusNode();
  bool isInsertedName = false;
  bool isInsertedNickname = false;
  bool isInsertedBirth = false;

  @override
  Widget build(BuildContext context) {
    SignUpController signUpNotifier =
        ref.read(SignUpControllerProvider.notifier);
    SignUpState signUpState = ref.watch(SignUpControllerProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: Text('회원정보 입력'),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // 화면 터치 시 키보드 닫기
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 70),
                    Text(
                      (!isInsertedName)
                          ? '이름을 입력하세요 '
                          : (!isInsertedNickname)
                              ? '닉네임을 임력하세요'
                              : '생년월일을 입력하세요',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),

                    Visibility(
                      visible: isInsertedNickname,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          TextFormField(
                            autofocus: true,
                            focusNode: birthFocusNode,
                            controller: signUpState.birthDateController,
                            keyboardType: TextInputType.datetime,
                            cursorColor: Colors.grey[600],
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly, // 숫자만 입력 허용
                              LengthLimitingTextInputFormatter(8), // 최대 8자리 제한
                              DateInputFormatter(), // 생년월일 포맷터 추가
                            ],
                            decoration: InputDecoration(
                              hintText: 'YYYY-MM-DD',
                              labelText: ' 생년월일',
                              labelStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            textInputAction: TextInputAction.newline,
                          ),
                        ],
                      ),
                    ),

                    Visibility(
                      visible: isInsertedName,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          TextFormField(
                            autofocus: true,
                            focusNode: nicknameFocusNode,
                            controller: signUpState.nicknameController,
                            cursorColor: Colors.grey[600],
                            decoration: InputDecoration(
                              labelText: ' 닉네임',
                              labelStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),
                    // 닉네임과 생일 입력 필드 반응형 구성
                    TextFormField(
                      autofocus: true,
                      focusNode: nameFocusNode,
                      controller: signUpState.nameController,
                      cursorColor: Colors.grey[600],
                      cursorHeight: 20,
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
                    ),
                    const SizedBox(height: 16), // 닉네임과 생일 필드 간격

                    const Spacer(), // 남은 공간을 채우기 위해 Spacer 추가
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                // 키보드 위로 버튼 위치
                left: 16,
                right: 16,
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      bool isValid = true;

                      if (signUpState.nameController!.text.isNotEmpty) {
                        String? nameValidation = signUpNotifier.checkName();
                        if (nameValidation != null) {
                          CustomSnackbar.showSnackBar(nameValidation);
                          nameFocusNode.requestFocus();
                          isValid = false;
                        } else {
                          setState(() {
                            isInsertedName = true;
                            nicknameFocusNode.requestFocus();
                          });
                        }
                      }

                      if (isInsertedName &&
                          signUpState.nicknameController!.text.isNotEmpty) {
                        String? nickValidation =
                            signUpNotifier.nickNameValidation();
                        if (nickValidation != null) {
                          CustomSnackbar.showSnackBar(nickValidation);
                          nicknameFocusNode.requestFocus();
                          isValid = false;
                        } else {
                          setState(() {
                            isInsertedNickname = true;
                            birthFocusNode.requestFocus();
                          });
                        }
                      }

                      if (isInsertedNickname &&
                          signUpState.birthDateController!.text.isNotEmpty) {
                        String? birthValidate =
                            signUpNotifier.birthDateValidation();
                        logger.i('birthday!! $birthValidate');
                        if (birthValidate != null) {
                          CustomSnackbar.showSnackBar(birthValidate);
                          birthFocusNode.requestFocus();

                          isValid = false;
                        } else {
                          setState(() {
                            isInsertedBirth = true;
                          });
                        }
                      }

                      if (isValid && isInsertedBirth) {
                        Navigator.pushNamed(context, '/join/insertUid');
                      }
                    },
                    child: Text('다음'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
