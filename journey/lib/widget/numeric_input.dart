import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericInputForm extends StatefulWidget {
  NumericInputForm({super.key, required this.label, required this.size});
  @override
  State<NumericInputForm> createState() => _NumericInputFormState();
  String value = "", label;
  final double size;
  TextEditingController txt = TextEditingController();
}

class _NumericInputFormState extends State<NumericInputForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      height: widget.size,
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: widget.label,
        ),
        onChanged: (val) => widget.value = val,
        controller: widget.txt,
      ),
    );
  }
}
