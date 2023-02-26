// ignore_for_file: use_build_context_synchronously

import 'package:journey/main.dart';
import 'package:journey/widget/input.dart';
import 'package:flutter/material.dart';

class AddTripPage extends StatefulWidget {
  const AddTripPage({super.key});

  @override
  State<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  @override
  Widget build(BuildContext context) {
    InputForm name =
        InputForm(label: "Enter the Trip name:", size: 80, lines: 1);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Trip'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        name,
        const SizedBox(height: 120),
        ElevatedButton(
            onPressed: () async {
              if (name.value.isEmpty) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                          title: Text('Error'),
                          content: Text('please insert the name of the Trip'));
                    });
                return;
              }
              await addTrip(name.value);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text('Congratulations'),
                        content: RichText(
                          text: TextSpan(
                            style: textStyle,
                            children: <TextSpan>[
                              const TextSpan(text: 'Trip '),
                              TextSpan(text: name.value, style: textStyleBold),
                              const TextSpan(text: ' created successfully')
                            ],
                          ),
                        ));
                  });
              name.txt.text = "";
            },
            child: const Text('CREATE'))
      ]),
    );
  }
}
