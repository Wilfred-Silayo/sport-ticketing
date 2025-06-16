import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final String title;
  final String content;

  const CustomDialog(
      {Key? key,
      required this.onConfirm,
      required this.title,
      required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
