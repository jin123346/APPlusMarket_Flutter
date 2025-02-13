import 'package:applus_market/data/model/my/user_app_setting_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../my_setting_page_view_model.dart';

class NotificationToggle extends ConsumerStatefulWidget {
  const NotificationToggle({super.key});

  @override
  ConsumerState<NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends ConsumerState<NotificationToggle> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userAppSettingProvider);
    final notifier = ref.read(userAppSettingProvider.notifier);

    if (state is AsyncLoading) {
      return Center(child: CircularProgressIndicator()); // 로딩 UI
    }

    return Container(
      width: 100,
      height: 50,
      child: Transform.scale(
        scale: 0.8,
        child: CupertinoSwitch(
          value: state.value!.isAlarmed ?? true,
          onChanged: (bool value) {
            setState(() {
              notifier.toggleAlarm();
            });
          },
          // activeColor: APlusTheme.labelTertiary,
        ),
      ),
    );
  }
}
