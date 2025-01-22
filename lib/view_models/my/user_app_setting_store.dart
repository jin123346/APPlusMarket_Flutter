import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/my/user_app_setting_state.dart';

class UserAppSettingNotifier extends Notifier<UserAppSetting> {
  @override
  UserAppSetting build() {
    // TODO: implement build
    return UserAppSetting(user_id: 1, isAlarmed: true);
  }

  void toggleAlarm() {
    state.isAlarmed = !state.isAlarmed;
  }
}

final UserAppsettingProvider =
    NotifierProvider<UserAppSettingNotifier, UserAppSetting>(
  () => UserAppSettingNotifier(),
);
