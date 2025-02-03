import 'dart:core';
import 'dart:core';

import 'package:applus_market/_core/utils/exception_handler.dart';
import 'package:applus_market/data/model/auth/sign_up_state.dart';
import 'package:applus_market/data/model/auth/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpController extends Notifier<SignUpState> {
  @override
  SignUpState build() {
    return SignUpState(
      uidController: TextEditingController(),
      passwordController: TextEditingController(),
      confirmPasswordController: TextEditingController(),
      emailController: TextEditingController(),
      verificationCodeController: TextEditingController(),
      hpController: TextEditingController(),
      hpAgencyController: TextEditingController(),
      nicknameController: TextEditingController(),
      nameController: TextEditingController(),
      birthDateController: TextEditingController(),
    );
  }

  //아이디 유효성 검사
  String? checkUid() {
    String? uid = state.uidController?.text.trim();
    if (uid == null || uid.isEmpty) {
      // ExceptionHandler.handleException('아이디를 입력해주세요', StackTrace.current);
      return '아이디를 입력해주세요';
    }
    if (uid.length < 5 || uid.length > 20) {
      // ExceptionHandler.handleException('아이디를 입력해주세요', StackTrace.current);
      return '아이디를 입력해주세요';
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(uid)) {
      // ExceptionHandler.handleException('아이디는 영문과 숫자만 가능합니다.', StackTrace.current);
      return 'fail';
    }
    state = state.copyWith(uidValidation: true);
    return null;
  }

  //이름
  String? checkName() {
    String? name = state.nameController?.text.trim();

    if (name == null || name.isEmpty) {
      //  ExceptionHandler.handleException('이름을 입력해주세요.', StackTrace.current);
      return '이름을 입력해주세요.';
    }

    if (!RegExp(r'^[가-힣a-zA-Z]{2,10}$').hasMatch(name)) {
      // ExceptionHandler.handleException('이름은 2~10자의 한글 또는 영문만 가능합니다.', StackTrace.current);
      return '이름은 2~10자의 한글 또는 영문만 가능합니다.';
    }

    // 이름을 User 객체에 반영
    state = state.copyWith(nameValidation: true);
    return null;
  }

  //닉네임

  String? nickNameValidation() {
    String? nickName = state.nicknameController?.text.trim() ?? '';

    if (nickName == null || nickName.isEmpty) {
      //ExceptionHandler.handleException('닉네임을 입력해주세요.', StackTrace.current);
      return '닉네임을 입력해주세요.';
    }

    if (!RegExp(r'^[가-힣a-zA-Z0-9]{2,15}$').hasMatch(nickName)) {
      // ExceptionHandler.handleException('닉네임은 2~15자의 한글, 영문, 숫자만 가능합니다.', StackTrace.current);
      return '닉네임은 2~15자의 한글, 영문, 숫자만 가능합니다.';
    }

    state = state.copyWith(nickValidation: true);
    return null;
  }
  //비밀번호 유효성 검사

  String? passwordValidation() {
    String? password = state.passwordController?.text.trim() ?? '';
    String? confirmPassword =
        state.confirmPasswordController?.text.trim() ?? '';

    if (password == null || password.isEmpty) {
      //ExceptionHandler.handleException('비밀번호를 입력해주세요', StackTrace.current);
      return '비밀번호를 입력해주세요';
    }
    if (confirmPassword == null || confirmPassword.isEmpty) {
      // ExceptionHandler.handleException('비밀번호를 확인해주세요', StackTrace.current);
      return '비밀번호를 확인해주세요';
    }

    //
    // if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%^&*()_+{}:;<>,.?~]).{8,}$')
    //     .hasMatch(password)) {
    //   ExceptionHandler.handleException('비밀번호는 대문자, 소문자, 숫자, 특수문자를 포함해야 합니다.', StackTrace.current);
    // }
    state = state.copyWith(passValidation: true);
    return null;
  }

  String? confirmPasswordValidation() {
    String password = state.passwordController!.text.trim() ?? '';
    String confirmPassword = state.confirmPasswordController!.text.trim() ?? '';
    if (password != confirmPassword) {
      // ExceptionHandler.handleException('비밀번호가 일치하지 않습니다.', StackTrace.current);
      return '비밀번호가 일치하지 않습니다.';
    }
    return null;
  }

  //이메일 검사
  String? checkEmail() {
    String? email = state.emailController?.text.trim() ?? '';
    if (email == null || email.isEmpty) {
      //  ExceptionHandler.handleException('이메일을 입력해주세요.', StackTrace.current);
      return '이메일을 입력해주세요.';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email)) {
      //ExceptionHandler.handleException('올바른 이메일 형식이 아닙니다.', StackTrace.current);
      return "올바른 이메일 형식이 아닙니다.";
    }

    state = state.copyWith(emailValidation: true);
    return null;
  }

  String? validateEamil(String emailCode) {
    //TODO : 임시 emailCode;
    emailCode = "123456";
    String? emailcode = state.verificationCodeController?.text.trim() ?? '';
    if (emailcode == null || emailcode.isEmpty) {
      //   ExceptionHandler.handleException('인증번호를 입력해주세요', StackTrace.current);
      return '인증번호를 입력해주세요';
    }

    if (emailcode != emailCode) {
      //ExceptionHandler.handleException('.인증번호가 일치하지 않습니다', StackTrace.current);
      return '인증번호가 일치하지 않습니다.';
    }

    state = state.copyWith(codeValidation: true);
  }

  //휴대폰 검사

  String? phoneValidation() {
    String? phone = state.hpController?.text.trim() ?? '';
    if (phone == null || phone.isEmpty) {
      //  ExceptionHandler.handleException('휴대폰 번호를 입력해주세요.', StackTrace.current);
      return '휴대폰 번호를 입력해주세요.';
    }
    if (!RegExp(r'^\d{10,11}$').hasMatch(phone)) {
      // ExceptionHandler.handleException('휴대폰 번호는 10~11자리 숫자여야 합니다.', StackTrace.current);
      return '휴대폰 번호는 10~11자리 숫자여야 합니다.';
    }

    state = state.copyWith(hpValidation: true);
    return null;
  }

  //생일 유효성 검사
  String? birthDateValidation() {
    String? birthDate = state.birthDateController?.text.trim() ?? '';
    if (birthDate == null || birthDate.isEmpty) {
      // ExceptionHandler.handleException('생년월일을 입력해주세요.', StackTrace.current);
      return '생년월일을 입력해주세요.';
    }
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(birthDate)) {
      // ExceptionHandler.handleException('올바른 생년월일 형식이 아닙니다. (예: YYYY-MM-DD)', StackTrace.current);

      return '올바른 생년월일 형식이 아닙니다. (예: YYYY-MM-DD)';
    }
    List<String> parts = birthDate.split('-');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    // 월 (MM)이 1~12 범위를 벗어나면 오류
    if (month < 1 || month > 12) {
      return '올바른 월(MM)을 입력해주세요. (1~12)';
    }

    // 해당 월의 최대 일 수를 초과하면 오류
    if (day < 1 || day > 31) {
      return '올바른 일(dd)을 입력해주세요.(1~31)';
    }

    // 14세 이상 검증
    DateTime? birthDateTime = DateTime.tryParse(birthDate);
    if (birthDateTime == null) {
      // ExceptionHandler.handleException('올바른 날짜를 입력해주세요.', StackTrace.current);
      return '올바른 날짜를 입력해주세요.';
    }
    DateTime now = DateTime.now();
    DateTime minDate = DateTime(now.year - 14, now.month, now.day);
    if (birthDateTime.isAfter(minDate)) {
      // ExceptionHandler.handleException('만 14세 이상만 가입할 수 있습니다.', StackTrace.current);
      return '만 14세 이상만 가입할 수 있습니다.';
    }

    state = state.copyWith(birthdayValidation: true);
    return null;
  }

  bool validateForm() {
    return state.birthdayValidation == true &&
        state.uidValidation == true &&
        state.nickValidation == true &&
        state.hpValidation == true &&
        state.emailValidation == true &&
        state.passValidation == true &&
        state.nameValidation == true;
  }

  void clearControllers() {
    state.uidController?.clear();
    state.passwordController?.clear();
    state.confirmPasswordController?.clear();
    state.nameController?.clear();
    state.nicknameController?.clear();
    state.hpController?.clear();
    state.hpAgencyController?.clear();
    state.emailController?.clear();
    state.verificationCodeController?.clear();
  }

  void dispose() {
    state.uidController!.dispose();
    state.passwordController!.dispose();
    state.confirmPasswordController!.dispose();
    state.nameController!.dispose();
    state.nicknameController!.dispose();
    state.hpController!.dispose();
    state.hpAgencyController!.dispose();
    state.emailController!.dispose();
    state.verificationCodeController!.dispose();
  }
}

final SignUpControllerProvider =
    NotifierProvider<SignUpController, SignUpState>(
  () {
    return SignUpController();
  },
);
