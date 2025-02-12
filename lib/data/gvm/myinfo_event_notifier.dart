import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserAction {
  none,
  changed, // 정보가 변경될때
  reload,
}

class MyInfoEventNotifier extends Notifier<UserAction> {
  @override
  UserAction build() {
    return UserAction.none;
  }

  void changedUser() => state = UserAction.changed;
  void reloadUser() => state = UserAction.reload;
  void reset() => state = UserAction.none;
}

final myInfoEventProvider = NotifierProvider<MyInfoEventNotifier, UserAction>(
  () => MyInfoEventNotifier(),
);
