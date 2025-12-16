import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AskDialog extends StatefulWidget {
  final String msg;
  final List<String> options;
  final String askedBy;

  const AskDialog({
    super.key,
    required this.msg,
    required this.askedBy,
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
      title: Text(widget.msg),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.askedBy),
          //SizedBox(height: 12.0),
          RadioGroup(
            groupValue: result,
            onChanged: (String? value) {
              setState(() {
                result = value;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.options.map((option) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(option).tr(),
                      leading: Radio<String>(value: option),
                      onTap: () {
                        setState(() {
                          result = option;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    SizedBox(height: 4.0),
                  ],
                );
              }).toList(),
            ),
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
  String askedBy,
  List<String> options,
) async {
  String? result;
  while (result == null) {
    result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AskDialog(msg: msg, askedBy: askedBy, options: options);
      },
    );
  }
  return result;
}
