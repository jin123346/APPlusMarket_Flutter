import 'package:applus_market/data/model/auth/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../_core/utils/dio.dart';
import '../../../../data/model/auth/signup_controller.dart';
import '../../../../data/model/auth/user.dart';
import '../../../../data/repository/auth/auth_repository.dart';

class JoinInsertModelView extends Notifier<User> {
  final AuthRepository authRepository = AuthRepository();
  @override
  User build() {
    return User();
  }

  int _year = 0000;
  int _month = 00;
  int _day = 00;

  // 특정 필드 업데이트
  // 상태 업데이트 메서드 예제
  void updateUid(String uid) => state = state.copyWith(uid: uid);
  void updatePassword(String password) =>
      state = state.copyWith(password: password);
  void updateHp(String hp) => state = state.copyWith(hp: hp);
  void updateName(String name) => state = state.copyWith(name: name);
  void updateNickname(String nickname) =>
      state = state.copyWith(nickName: nickname);
  void updateBirthday(DateTime birthday) {
    state = state.copyWith(birthday: birthday);
  }

  void resetUser() => state = User();

  Map<String, dynamic> toUser(SignUpState signUpState) {
    // Map<String, dynamic> user = {
    //   "uid": signUpState.uidController!.text,
    //   "password": signUpState.passwordController!.text,
    //   "nickName": signUpState.nicknameController!.text,
    //   "name": signUpState.nameController!.text, // 공백 제거
    //   "email": signUpState.emailController!.text,
    //   "hp": signUpState.hpController!.text,
    //   "birthday": stringToDateTime(signUpState.birthDateController!.text),
    // };

    User saveUser = User(
      uid: signUpState.uidController!.text,
      nickName: signUpState.nicknameController!.text,
      birthday: stringToDateTime(signUpState.birthDateController!.text),
      hp: signUpState.hpController!.text,
      email: signUpState.emailController!.text,
      name: signUpState.nameController!.text,
      password: signUpState.passwordController!.text,
    );

    return saveUser.toJson();
  }

  void insertUser(Map<String, dynamic> UserData) async {
    Map<String, dynamic> responseBody =
        await authRepository.apiInsertUser(UserData);
  }

  String dateTimeToString(DateTime dateTime) {
    return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  }

  DateTime? stringToDateTime(String date) {
    try {
      return DateTime.parse(date); // "YYYY-MM-DD" 형식일 경우
    } catch (e) {
      return null; // 형식이 맞지 않으면 null 반환
    }
  }
}

final joinUserProvider = NotifierProvider<JoinInsertModelView, User>(
  () {
    return JoinInsertModelView();
  },
);
