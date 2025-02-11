import 'package:applus_market/_core/components/size.dart';
import 'package:applus_market/ui/pages/my/widgets/delivery_modify_body.dart';
import 'package:flutter/material.dart';

import '../../../../_core/components/theme.dart';
import 'widgets/custom_textfield.dart';
import 'widgets/delivery_address_page.dart';
import 'widgets/delivery_register_body.dart';

class DeliveryMoifyPage extends StatelessWidget {
  DeliveryMoifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/my/delivery');
                  },
                  icon: Icon(Icons.arrow_back_ios_new_outlined)),
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
            body: DeliveryModifyBody()));
  }
}
