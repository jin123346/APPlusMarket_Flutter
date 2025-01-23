import 'package:applus_market/size.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  String title;
  TextEditingController textEditingController;
  CustomTextfield(
      {required this.title, required this.textEditingController, super.key});

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${widget.title}'),
        const SizedBox(height: 4),
        TextField(
          controller: widget.textEditingController,
          autofocus: false,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            focusColor: Colors.grey,
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500, width: 0.5),
            ),
          ),
        )
      ],
    );
  }
}
