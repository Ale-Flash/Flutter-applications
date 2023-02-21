import 'package:flutter/material.dart';

class InputForm extends StatefulWidget {
  InputForm(
      {super.key,
      required this.label,
      required this.size,
      required this.lines});

  @override
  State<InputForm> createState() => _InputFormState();
  String value = "", label;
  final double size;
  TextEditingController txt = TextEditingController();
  final int lines;
}

class _InputFormState extends State<InputForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      height: widget.size,
      child: TextFormField(
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: widget.label,
        ),
        onChanged: (val) {
          widget.value = val;
        },
        controller: widget.txt,
        maxLines: widget.lines,
      ),
    );
  }
}
