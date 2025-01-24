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
    final state = ref.watch(UserAppsettingProvider);
    final notifier = ref.read(UserAppsettingProvider.notifier);

    return Container(
      width: 100,
      height: 50,
      child: Transform.scale(
        scale: 0.8,
        child: CupertinoSwitch(
          value: state.isAlarmed,
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
