import 'package:flutter/material.dart';

class FormFieldSample extends StatefulWidget {
  FormFieldSample({super.key});

  @override
  State<FormFieldSample> createState() => _FormFieldSampleState();
  String password = "";
}

class _FormFieldSampleState extends State<FormFieldSample> {
  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: TextFormField(
        decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: 'Enter your password:',
            suffixIcon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: SizedBox(
                  child: GestureDetector(
                    onTap: _toggle,
                    child: Icon(_obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                  ),
                ))),
        validator: (val) =>
            (val != null && val.length < 6 ? 'Password too short' : null),
        onChanged: (val) => widget.password = val,
        obscureText: _obscureText,
      ),
    );
  }
}
