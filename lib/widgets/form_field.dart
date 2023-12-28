import 'package:flutter/material.dart';

class CusFormField extends StatelessWidget {
  const CusFormField(this.controller, this.hintText, this._key, {super.key});
  final TextEditingController controller;
  final String hintText;
  final Key _key;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        key: _key,
        controller: controller,
        decoration: InputDecoration(hintText: hintText),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Can not leave field empty';
          }
        });
  }
}
