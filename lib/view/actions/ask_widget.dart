import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:werewolve_app/view/helpers/color_helpers.dart';

class AskWidget extends StatefulWidget {
  final String msg;
  final List<String> options;
  final String askedBy;
  final ValueChanged<String?>? onResult;

  const AskWidget({
    super.key,
    required this.msg,
    required this.askedBy,
    required this.options,
    this.onResult,
  });

  @override
  State<AskWidget> createState() => _AskWidgetState();
}

class _AskWidgetState extends State<AskWidget> {
  String? result;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20.0),
        Text(widget.msg, style: Theme.of(context).textTheme.headlineLarge),
        SizedBox(height: 5.0),
        Text(
          widget.askedBy,
          style: TextStyle(
            color: ColorHelpers.onSurfaceVariantColor(context),
            fontSize: 16.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: RadioGroup(
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
                      title: Text(
                        option,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ).tr(),
                      leading: Radio<String>(value: option),
                      onTap: () {
                        if (widget.onResult != null) {
                          widget.onResult!(option);
                        }
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
        ),
      ],
    );
  }
}
