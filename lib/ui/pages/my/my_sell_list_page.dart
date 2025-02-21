import 'package:applus_market/ui/pages/my/widgets/my_sell_list_body.dart';
import 'package:flutter/material.dart';

class MySellListPage extends StatelessWidget {
  const MySellListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: MySellListBody(),
      ),
    );
  }
}
