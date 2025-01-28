import 'dart:async';

import 'package:applus_market/ui/pages/auth/join_page/join_insert_page_model_view.dart';
import 'package:applus_market/ui/pages/auth/login_page/widgets/login_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../_core/logger.dart';
import '../../../../../data/model/auth/user.dart';
import '../../../../../data/model/auth/signup_controller.dart';

class InsertEmailPage extends ConsumerStatefulWidget {
  InsertEmailPage({super.key});

  @override
  ConsumerState<InsertEmailPage> createState() => _InsertEmailPageState();
}

class _InsertEmailPageState extends ConsumerState<InsertEmailPage> {
  bool isSubmitted = false;
  bool isTimerRunning = false;
  int remainingSeconds = 180; // 3분
  Timer? timer;

  void startTimer() {
    setState(() {
      remainingSeconds = 180; // 3분으로 초기화
      isTimerRunning = true;
    });

    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          isTimerRunning = false;
        });
      }
    });
  }

  void resendVerificationCode() {
    // 인증번호 재전송 로직
    print("인증번호를 재전송했습니다.");
    startTimer();
  }

  String formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  bool allConsent = false;
  List<bool> individualConsents = [false, false, false];

  final List<String> consentTitles = [
    "서비스 이용 약관 동의 (필수)",
    "개인정보 수집 및 이용 동의 (필수)",
    "마케팅 정보 수신 동의 (선택)",
  ];

  void toggleAllConsent(bool value) {
    setState(() {
      allConsent = value;
      for (int i = 0; i < individualConsents.length; i++) {
        individualConsents[i] = value;
      }
    });
  }

  void toggleIndividualConsent(int index, bool value) {
    setState(() {
      individualConsents[index] = value;
      allConsent = individualConsents.every((consent) => consent);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SignUpController controllerNotifier =
        ref.read(SignUpControllerProvider.notifier);
    final TextEditingController emailController =
        controllerNotifier.emailController;
    final TextEditingController verificationCodeController =
        controllerNotifier.verificationCodeController;

    TextEditingController();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text('회원정보 입력'),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // 화면 터치 시 키보드 닫기
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Text(
                  '이메일을 입력하세요.',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: emailController,
                        cursorColor: Colors.grey[600],
                        cursorHeight: 20,
                        decoration: InputDecoration(
                          labelText: ' 이메일',
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
                            return '이메일을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 75,
                      height: 55,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isSubmitted = true;
                          });
                          resendVerificationCode(); // 인증번호 전송
                        },
                        child: Text('인증하기'),
                        style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.all(0),
                            side: BorderSide(color: Colors.grey.shade300),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey.shade500),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            backgroundColor: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Visibility(
                  visible: isSubmitted,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: verificationCodeController,
                        cursorColor: Colors.grey[600],
                        onChanged: (value) {
                          if (value.length == 6) {
                            // 예: 6자리 인증번호 입력 시 자동 확인
                            if (value == "123456") {
                              // 테스트용 인증번호
                              print("인증번호 확인 성공");
                              // 추가 로직
                            } else {
                              print("인증번호 확인 실패");
                            }
                          }
                        },
                        cursorHeight: 20,
                        decoration: InputDecoration(
                          labelText: ' 인증번호',
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
                            return '인증번호를 입력해주세요';
                          }
                          return '인증번호를 전송했습니다.';
                        },
                        onSaved: (newValue) {},
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "인증번호를 전송했습니다.",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Row(
                            children: [
                              Text(
                                "남은 시간 ${formatTime(remainingSeconds)}",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.red),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: isTimerRunning
                                    ? null
                                    : () {
                                        resendVerificationCode();
                                      },
                                child: Text(
                                  "시간연장",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isTimerRunning
                                        ? Colors.grey
                                        : Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 전체 동의
                const Spacer(),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          height: 250,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade50),
            ),
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Checkbox(
                  value: allConsent,
                  onChanged: (value) => toggleAllConsent(true),
                ),
                title: Text(
                  "모든 약관에 동의합니다",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: consentTitles.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Checkbox(
                        value: individualConsents[index],
                        onChanged: (value) =>
                            toggleIndividualConsent(index, value!),
                      ),
                      title: Text(
                        consentTitles[index],
                        style: TextStyle(
                          fontSize: 14,
                          color: consentTitles[index].contains("(필수)")
                              ? Colors.black
                              : Colors.grey.shade600,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('약관 상세보기'),
                              content:
                                  Text('${consentTitles[index]}에 대한 상세 내용입니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('확인'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (individualConsents[0] && individualConsents[1]) {
                  // 필수 동의 항목을 체크했는지 확인
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("회원가입 완료"),
                        content: Text("회원가입이 완료되었습니다."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              JoinInsertModelView notifier =
                                  ref.read(joinUserProvider.notifier);
                              User user = notifier.toUser(controllerNotifier);
                              notifier.insertUser(user);
                              Navigator.pop(context); // 팝업 닫기
                              Navigator.pushNamed(
                                  context, '/login'); // 로그인 페이지로 이동
                            },
                            child: Text("확인"),
                          ),
                        ],
                      );
                    },
                  );
                  // Navigator.pushNamed(context, '/login');
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('동의 필요'),
                      content: Text('필수 항목에 동의해야 진행할 수 있습니다.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('확인'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('회원가입'),
            ),
          ),
        ),
      ),
    );
  }
}
