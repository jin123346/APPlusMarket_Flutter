import 'package:flutter/material.dart';

class CustomTwoButton extends StatelessWidget {
  final String button1;
  final String button2;
  final VoidCallback? button1Function;
  final VoidCallback? button2Function;
  const CustomTwoButton(
      {required this.button1,
      required this.button2,
      this.button1Function,
      this.button2Function,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: button1Function ?? () {},
            child: Text('$button1'),
            style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade500),
                    borderRadius: BorderRadius.zero),
                backgroundColor: Colors.grey[200]),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: button2Function ?? () {},
            child: Text('$button2'),
            style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                backgroundColor: Colors.black),
          ),
        ),
      ],
    );
  }
}
