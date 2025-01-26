import 'package:flutter/material.dart';

class UnifiedSignupPage extends StatefulWidget {
  UnifiedSignupPage({super.key});

  @override
  State<UnifiedSignupPage> createState() => _UnifiedSignupPageState();
}

class _UnifiedSignupPageState extends State<UnifiedSignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('회원가입'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 입력 단계 표시
              Expanded(
                child: IndexedStack(
                  index: currentStep,
                  children: [
                    buildStep(
                      label: '이름',
                      hint: '이름을 입력하세요',
                      controller: nameController,
                    ),
                    buildStep(
                      label: '닉네임',
                      hint: '닉네임을 입력하세요',
                      controller: nicknameController,
                    ),
                    buildStep(
                      label: '생년월일',
                      hint: 'YYYY-MM-DD',
                      controller: birthDateController,
                      keyboardType: TextInputType.datetime,
                    ),
                    buildStep(
                      label: '이메일',
                      hint: '이메일을 입력하세요',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    buildStep(
                      label: '휴대폰 번호',
                      hint: '010-1234-5678',
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),

              // 현재까지 입력된 내용 표시
              Expanded(
                child: ListView(
                  children: [
                    if (nameController.text.isNotEmpty)
                      ListTile(
                        leading: Text('이름'),
                        title: TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    if (nicknameController.text.isNotEmpty)
                      ListTile(
                        title: Text('닉네임'),
                        subtitle: Text(nicknameController.text),
                      ),
                    if (birthDateController.text.isNotEmpty)
                      ListTile(
                        title: Text('생년월일'),
                        subtitle: Text(birthDateController.text),
                      ),
                    if (emailController.text.isNotEmpty)
                      ListTile(
                        title: Text('이메일'),
                        subtitle: Text(emailController.text),
                      ),
                    if (phoneNumberController.text.isNotEmpty)
                      ListTile(
                        title: Text('휴대폰 번호'),
                        subtitle: Text(phoneNumberController.text),
                      ),
                  ],
                ),
              ),

              // 이전/다음 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentStep > 0)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentStep--;
                        });
                      },
                      child: Text('이전'),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (currentStep < 4) {
                          currentStep++;
                        } else {
                          // 최종 완료 처리
                          print('회원가입 완료');
                        }
                      });
                    },
                    child: Text(currentStep < 4 ? '다음' : '완료'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStep({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
