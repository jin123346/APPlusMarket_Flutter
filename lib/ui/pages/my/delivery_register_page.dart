import 'package:applus_market/_core/components/size.dart';
import 'package:flutter/material.dart';

import '../../../../_core/components/theme.dart';
import 'widgets/custom_textfield.dart';
import 'widgets/delivery_address_page.dart';
import 'widgets/delivery_body.dart';

class DeliveryRegisterPage extends StatelessWidget {
  DeliveryRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('마이페이지'),
              actions: [
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/my/settings');
                    },
                    child: Icon(Icons.settings_outlined)),
                const SizedBox(width: 16)
              ],
            ),
            body: DeliveryBody()));
  }
}
