import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onResult;

  const MessageDialog({super.key, required this.message, this.onResult});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('dialog_title.message').tr(),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text('option.accept').tr(),
          onPressed: () {
            if (onResult != null) {
              onResult!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

Future<void> msgDialog(BuildContext context, String message) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return MessageDialog(message: message);
    },
  );
}
