import 'package:flutter/material.dart';

class MultipleLinesInputForm extends StatefulWidget {
  MultipleLinesInputForm({super.key, required this.label, required this.size, required this.lines});

  @override
  State<MultipleLinesInputForm> createState() => _MultipleLinesInputFormState();
  String value = "", label;
  final double size;
  final int lines;
}

class _MultipleLinesInputFormState extends State<MultipleLinesInputForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      height: widget.size,
      child: TextFormField(
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          hintMaxLines: widget.lines,
          labelText: widget.label,
        ),
        maxLines: widget.lines,
        onChanged: (val) => widget.value = val,
      ),
    );
  }
}
