import 'dart:async';

import 'package:applus_market/_core/utils/shared_preferences.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../_core/utils/logger.dart';
import '../../../data/model/my/user_app_setting_state.dart';

class UserAppSettingNotifier extends AsyncNotifier<UserAppSetting> {
  @override
  Future<UserAppSetting> build() async {
    return await _init();
  }

  Future<UserAppSetting> _init() async {
    SessionUser user = ref.read(LoginProvider);
    bool? isAlarmed =
        await SharedPrefHelper.prefs.getBool('${user.id}isAlarmed');
    logger.i('현재 알람  : $isAlarmed');
    return UserAppSetting(user_id: user.id!, isAlarmed: isAlarmed ?? true);
  }

  void toggleAlarm() async {
    if (state.value == null) {
      state = AsyncData(await _init());
    } else {
      state =
          AsyncData(state.value!.copyWith(isAlarmed: !state.value!.isAlarmed!));
      await SharedPrefHelper.prefs.setBool(
          "${state.value!.user_id!}isAlarmed", state.value!.isAlarmed!);
    }
  }
}

final userAppSettingProvider =
    AsyncNotifierProvider<UserAppSettingNotifier, UserAppSetting>(
  () => UserAppSettingNotifier(),
);
