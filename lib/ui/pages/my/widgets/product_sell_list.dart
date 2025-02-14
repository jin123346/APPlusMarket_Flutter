import 'package:flutter/material.dart';

class ProductSellList extends StatelessWidget {
  const ProductSellList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(),
          Row(
            children: [
              ElevatedButton(onPressed: () {}, child: Text('받은 후기 보기')),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
            ],
          )
        ],
      ),
    );
  }
}
