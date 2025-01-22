import 'dart:ffi';

/*
  2025.1.22 하진희 : 유저 휴태폰 셋팅 객체
 */
class UserAppSetting {
  int user_id;
  bool isAlarmed;
  UserAppSetting({required this.user_id, this.isAlarmed = false});

  UserAppSetting init(UserAppSetting mySetting) {
    return UserAppSetting(
        user_id: mySetting.user_id, isAlarmed: mySetting.isAlarmed);
  }
}
