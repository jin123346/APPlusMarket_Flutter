import 'package:applus_market/data/model/auth/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    SignUpController signUpControllerNotifier =
        ref.read(SignUpControllerProvider.notifier);
    TextEditingController nameController =
        signUpControllerNotifier.nameController;
    TextEditingController nicknameController =
        signUpControllerNotifier.nicknameController;
    TextEditingController birthDateController =
        signUpControllerNotifier.birthDateController;

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
                            controller: birthDateController,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                birthDateController.clear();
                                return '생년월일을 입력해주세요';
                              }
                              // 유효성 검사: 10자리 및 YYYY-MM-DD 형식 확인
                              final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                              if (!regex.hasMatch(value)) {
                                birthDateController.clear();
                                return '올바른 형식의 생년월일을 입력해주세요 (YYYY-MM-DD)';
                              }
                              // 날짜가 유효한지 확인
                              try {
                                final parts = value.split('-');
                                final year = int.parse(parts[0]);
                                final month = int.parse(parts[1]);
                                final day = int.parse(parts[2]);

                                if (month < 1 ||
                                    month > 12 ||
                                    day < 1 ||
                                    day > 31) {
                                  birthDateController.clear();
                                  return '올바른 날짜를 입력해주세요';
                                }
                              } catch (e) {
                                birthDateController.clear();
                                return '유효한 생년월일을 입력해주세요';
                              }
                              return null;
                            },
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
                            controller: nicknameController,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '닉네임을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),
                    // 닉네임과 생일 입력 필드 반응형 구성
                    TextFormField(
                      autofocus: true,
                      focusNode: nameFocusNode,
                      controller: nameController,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '이름을 입력해주세요';
                        }
                        return null;
                      },
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
                      if (!isInsertedName) {
                        setState(() {
                          isInsertedName = true;
                          nicknameFocusNode.requestFocus();
                        });
                      } else if (!isInsertedNickname) {
                        setState(() {
                          isInsertedNickname = true;
                          birthFocusNode.requestFocus();
                        });
                      } else if (birthDateController.text.isNotEmpty) {
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
