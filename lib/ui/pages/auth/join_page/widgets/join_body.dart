import 'package:applus_market/ui/pages/auth/login_page/widgets/login_form_field.dart';
import 'package:flutter/material.dart';

class JoinBody extends StatelessWidget {
  JoinBody({super.key});

  final TextEditingController uidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  void sendEmailVerification() {
    // Logic to send email verification
    print("Sending email verification to: ${emailController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          const Text(
            "가장 편한 방법으로 시작해 보세요!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "1분 이면 회원가입 가능해요",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),
          buildOptionButton(
            text: "이메일로 계속하기",
            color: Colors.blue,
            textColor: Colors.white,
            onTap: () {
              Navigator.pushNamed(context, '/join/emailLogin');
            },
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "또는",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 20),
          buildOptionButton(
            text: "카카오로 계속하기",
            color: Colors.yellow,
            textColor: Colors.black,
            onTap: () {
              Navigator.pushNamed(context, "/kakaoLogin");
            },
            icon: Icons.chat,
          ),
          buildOptionButton(
            text: "네이버로 계속하기",
            color: Colors.green,
            textColor: Colors.white,
            onTap: () {
              Navigator.pushNamed(context, "/naverLogin");
            },
            icon: Icons.language,
          ),
          buildOptionButton(
            text: "Google로 계속하기",
            color: Colors.white,
            textColor: Colors.black,
            onTap: () {
              Navigator.pushNamed(context, "/googleLogin");
            },
            icon: Icons.g_mobiledata,
          ),
        ],
      ),
    );
  }

  Widget buildOptionButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor, size: 20),
                const SizedBox(width: 10),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
