import 'package:flutter/material.dart';

class SignUpState {
  final TextEditingController? uidController;
  final TextEditingController? passwordController;
  final TextEditingController? confirmPasswordController;
  final TextEditingController? emailController;
  final TextEditingController? verificationCodeController;
  final TextEditingController? hpController;
  final TextEditingController? hpAgencyController;
  final TextEditingController? nicknameController;
  final TextEditingController? nameController;
  final TextEditingController? birthDateController;

  final bool? uidValidation;
  final bool? passValidation;
  final bool? emailValidation;
  final bool? codeValidation;
  final bool? hpValidation;
  final bool? nickValidation;
  final bool? birthdayValidation;
  final bool? nameValidation;

  SignUpState(
      {required this.uidController,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.emailController,
      required this.verificationCodeController,
      required this.hpController,
      required this.hpAgencyController,
      required this.nicknameController,
      required this.nameController,
      required this.birthDateController,
      this.uidValidation = false,
      this.passValidation = false,
      this.emailValidation = false,
      this.codeValidation = false,
      this.hpValidation = false,
      this.nickValidation = false,
      this.birthdayValidation = false,
      this.nameValidation = false});

  SignUpState copyWith({
    TextEditingController? uidController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
    TextEditingController? emailController,
    TextEditingController? verificationCodeController,
    TextEditingController? hpController,
    TextEditingController? hpAgencyController,
    TextEditingController? nicknameController,
    TextEditingController? nameController,
    TextEditingController? birthDateController,
    bool? uidValidation,
    bool? passValidation,
    bool? emailValidation,
    bool? codeValidation,
    bool? hpValidation,
    bool? nickValidation,
    bool? birthdayValidation,
    bool? nameValidation,
  }) {
    return SignUpState(
      uidController: uidController ?? this.uidController,
      passwordController: passwordController ?? this.passwordController,
      confirmPasswordController:
          confirmPasswordController ?? this.confirmPasswordController,
      emailController: emailController ?? this.emailController,
      verificationCodeController:
          verificationCodeController ?? this.verificationCodeController,
      hpController: hpController ?? this.hpController,
      hpAgencyController: hpAgencyController ?? this.hpAgencyController,
      nicknameController: nicknameController ?? this.nicknameController,
      nameController: nameController ?? this.nameController,
      birthDateController: birthDateController ?? this.birthDateController,
      uidValidation: uidValidation ?? this.uidValidation,
      passValidation: passValidation ?? this.passValidation,
      emailValidation: emailValidation ?? this.emailValidation,
      codeValidation: codeValidation ?? this.codeValidation,
      hpValidation: hpValidation ?? this.hpValidation,
      nickValidation: nickValidation ?? this.nickValidation,
      birthdayValidation: birthdayValidation ?? this.birthdayValidation,
      nameValidation: nameValidation ?? this.nameValidation,
    );
  }
}
