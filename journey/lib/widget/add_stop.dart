import 'package:journey/widget/input.dart';
import 'package:flutter/material.dart';

class AddStopPage extends StatefulWidget {
  const AddStopPage({super.key});

  @override
  State<AddStopPage> createState() => _AddStopPageState();
}

class _AddStopPageState extends State<AddStopPage> {
  @override
  Widget build(BuildContext context) {
    InputForm name = InputForm(label: "Enter the Stop name:");
    InputForm info = InputForm(label: "Enter the Stop informations:");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Trip'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        name,
        const SizedBox(height: 20),
        info,
        // TODO completare aggiungere posizione, e la visualizzazione delle altre fermate, pensare la struttura della pagina
        const SizedBox(height: 150),
        ElevatedButton(onPressed: () {}, child: const Text('CREATE'))
      ]),
    );
  }
}
