import 'package:flutter/material.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({super.key});

  @override
  State<SettingsRoute> createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_rounded)
          ),
        ),
      )
    );
  }
}