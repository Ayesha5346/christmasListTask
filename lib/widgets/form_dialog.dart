import 'package:flutter/material.dart';

class FormDialog extends StatelessWidget {
  const FormDialog(this.title, this.child, this._key, {super.key});
  final Widget title;
  final Widget child;
  final Key _key;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: _key,
      title: title,
      content: child,
    );
  }
}
