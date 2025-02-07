import 'package:applus_market/_core/utils/dialog_helper.dart';
import 'package:applus_market/_core/utils/exception_handler.dart';
import 'package:applus_market/data/model/auth/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../_core/utils/dio.dart';
import '../../../../data/model/auth/signup_controller.dart';
import '../../../../data/model/auth/user.dart';
import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../main.dart';

class JoinInsertModelView extends Notifier<(User, bool? isSuccess)> {
  final AuthRepository authRepository = AuthRepository();
  final mContext = navigatorkey.currentContext!;

  @override
  (User, bool) build() {
    return (User(), false);
  }

  int _year = 0000;
  int _month = 00;
  int _day = 00;

  // 특정 필드 업데이트
  // 상태 업데이트 메서드 예제
  void updateUid(String uid) => state = (state.$1.copyWith(uid: uid), state.$2);

  void updatePassword(String password) =>
      state = (state.$1.copyWith(password: password), state.$2);

  void updateHp(String hp) => state = (state.$1.copyWith(hp: hp), state.$2);

  void updateName(String name) =>
      state = (state.$1.copyWith(name: name), state.$2);

  void updateNickname(String nickname) =>
      state = (state.$1.copyWith(nickName: nickname), state.$2);

  void updateBirthday(DateTime birthday) {
    state = (state.$1.copyWith(birthday: birthday), state.$2);
  }

  void updateSuccess() {
    state = (User(), true);
  }

  void resetUser() => state = (User(), false);

  //객체 -> map 처리
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

  //회원가입 요청
  void insertUser(Map<String, dynamic> UserData) async {
    try {
      Map<String, dynamic> responseBody =
          await authRepository.apiInsertUser(UserData);

      if (responseBody['status'] == 'failed') {
        ExceptionHandler.handleException(
            responseBody['message'], StackTrace.current);
        return;
      }
      updateSuccess();
      DialogHelper.showAlertDialog(
          context: mContext,
          title: '회원가입 성공',
          onConfirm: () {
            resetUser();
            ref.invalidate(SignUpControllerProvider);

            Navigator.popAndPushNamed(mContext, '/login');
          });
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('회원가입 중 오류 발생', stackTrace);
    }
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

final joinUserProvider = NotifierProvider<JoinInsertModelView, (User, bool?)>(
  () {
    return JoinInsertModelView();
  },
);
