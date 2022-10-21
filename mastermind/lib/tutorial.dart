import 'package:flutter/material.dart';
/*
class TutorialRotta extends StatelessWidget {
  const TutorialRotta({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tutorial'),
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
*/
class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Cacca'),
      ),
    );
  }
}
/*
class TutorialRoute extends StatefulWidget {
  const TutorialRoute({super.key});

  @override
  State<TutorialRoute> createState() => _TutorialRouteState();
}

class _TutorialRouteState extends State<TutorialRoute> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tutorial'),
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
*/