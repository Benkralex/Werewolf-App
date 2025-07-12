import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<void> msgDialog(
  BuildContext context,
  String message,
) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('message').tr(),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('option.accept').tr(),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}