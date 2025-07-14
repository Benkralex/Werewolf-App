import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AskDialog extends StatefulWidget {
  final String msg;
  final List<String> options;

  const AskDialog({
    super.key,
    required this.msg,
    required this.options,
  });

  @override
  State<AskDialog> createState() => _AskDialogState();
}

class _AskDialogState extends State<AskDialog> {
  String? result;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('dialog_title.ask').tr(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.msg),
          const SizedBox(height: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.options.map((option) {
              return RadioListTile<String>(
                title: Text(option).tr(),
                value: option,
                groupValue: result,
                onChanged: (value) {
                  setState(() {
                    result = value;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('option.accept').tr(),
          onPressed: () {
            Navigator.of(context).pop(result);
          },
        ),
      ],
    );
  }
}

Future<String?> askDialog(
  BuildContext context,
  String msg,
  List<String> options,
) async {
  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AskDialog(
        msg: msg,
        options: options,
      );
    },
  );
}