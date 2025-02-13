import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static SharedPreferences? _prefs;

  // 초기화 (앱 시작 시 한 번만 호출)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 전역으로 재사용 가능
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception(
          'SharedPreferences not initialized! Call SharedPrefHelper.init() first.');
    }
    return _prefs!;
  }
}
