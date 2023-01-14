import 'package:flutter/material.dart';

class InputForm extends StatefulWidget {
  InputForm({super.key, required this.label});

  @override
  State<InputForm> createState() => _InputFormState();
  String value = "", label;
}

class _InputFormState extends State<InputForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      height: 50,
      child: TextFormField(
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: widget.label,
        ),
        onChanged: (val) => widget.value = val,
      ),
    );
  }
}
