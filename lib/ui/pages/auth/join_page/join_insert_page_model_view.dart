import 'package:applus_market/data/model/auth/user.dart';
import 'package:applus_market/data/model/auth/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../_core/dio.dart';
import '../../../../data/repository/auth/auth_repository.dart';

class JoinInsertModelView extends Notifier<User> {
  final AuthRepository authRepository = AuthRepository(dio: dio);
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

  User toUser(SignUpController signProvider) {
    User user = User(
      uid: signProvider.uidController.text,
      password: signProvider.passwordController.text,
      nickName: signProvider.nicknameController.text,
      name: signProvider.nameController.text,
      email: signProvider.emailController.text,
      hp: signProvider.hpController.text,
      birthday: stringToDateTime(signProvider.birthDateController.text),
    );

    return user;
  }

  void insertUser(User user) {
    authRepository.apiInsertUser(user);
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
