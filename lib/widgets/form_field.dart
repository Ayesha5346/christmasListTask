import 'package:flutter/material.dart';

class CusFormField extends StatelessWidget {
  const CusFormField(this.controller,this.hintText,{super.key});
  final TextEditingController controller;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText
        ),
        validator:(value) {
          if(value == null || value.isEmpty)
          {return 'Can not leave field empty';}
        }
    );
  }
}
