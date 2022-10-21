import 'package:flutter/material.dart';
import 'package:mastermind/gui.dart';
import 'package:mastermind/tutorial.dart';

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});
  static const MaterialColor mainColor = Colors.green;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: mainColor),
      initialRoute: '/',
      routes: <String, WidgetBuilder> {
        '/': (BuildContext context) => const Home(),
        "/tutorial": (BuildContext context) => const Page3(),
        "/play": (BuildContext context) => const MyHomePage(),
        "/settings": (BuildContext context) => const Page3()
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    ButtonStyle style = ButtonStyle(
        shape: MaterialStateProperty.all(const CircleBorder()),
        padding: MaterialStateProperty.all(const EdgeInsets.all(0)));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Mind'),
      ),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: 50,
              height: 50,
              child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, "/tutorial"),
                  style: style,
                  child: const Icon(Icons.question_mark_rounded)
              )
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                width: 75,
                height: 75,
                child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, "/play"),
                    style: style,
                    child: const Icon(Icons.play_arrow_rounded, size: 75)
                )
              ),
            ),
            SizedBox(
              width: 50,
              height: 50,
              child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, "/settings"),
                  style: style,
                  child: const Icon(Icons.settings)
              )
            )
          ],
        )
      ),
    );
  }
}
