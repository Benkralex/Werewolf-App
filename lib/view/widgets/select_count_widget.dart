import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SelectCountWidget extends StatefulWidget {
  final int minCount;
  final int maxCount;
  final int count;
  final ValueChanged<int> onCountChanged;
  final String label;

  const SelectCountWidget({
    super.key,
    required this.minCount,
    required this.maxCount,
    required this.count,
    required this.onCountChanged,
    required this.label,
  });

  @override
  State<SelectCountWidget> createState() => _SelectCountWidgetState();
}

class _SelectCountWidgetState extends State<SelectCountWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  if (widget.count > widget.minCount) {
                    widget.onCountChanged(widget.count - 1);
                  }
                });
              },
            ),
            Expanded(
              child: Slider(
                year2023: false,
                value: widget.count.toDouble(),
                label: widget.count.toString(),
                onChanged: (double newValue) {
                  setState(() {
                    widget.onCountChanged(newValue.toInt());
                  });
                },
                min: widget.minCount.toDouble(),
                max: widget.maxCount.toDouble(),
                divisions: (widget.maxCount - widget.minCount).toInt(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  if (widget.count < widget.maxCount) {
                    widget.onCountChanged(widget.count + 1);
                  }
                });
              },
            ),
          ],
        ),
        Text(widget.label.tr(namedArgs: {"count": widget.count.toString()})),
      ],
    );
  }
}
