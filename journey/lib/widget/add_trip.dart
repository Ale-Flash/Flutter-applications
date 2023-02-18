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
    InputForm name = InputForm(label: "Enter the Trip name:");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Trip'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          name,
          const SizedBox(height: 150),
          ElevatedButton(onPressed: () {
            
          }, child: const Text('CREATE'))
      ]),
    );
  }
}