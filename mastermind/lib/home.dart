import 'package:flutter/material.dart';
import 'package:mastermind/gui.dart';
import 'package:mastermind/settings.dart';
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
        '/'        : (BuildContext context) => const Home(),
        '/tutorial': (BuildContext context) => const Tutorial(),
        '/play'    : (BuildContext context) => const MyHomePage(),
        '/settings': (BuildContext context) => const SettingsPage()
      },
    );
  }
}

class Home extends StatelessWidget {
  SizedBox button(double size, ButtonStyle style, Icon icon, String route, BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, route),
          style: style,
          child: icon
      )
    );
  }
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
            button(50, style, const Icon(Icons.question_mark_rounded), '/tutorial', context),
            Padding(padding: const EdgeInsets.all(5.0),
              child: button(75, style, const Icon(Icons.play_arrow_rounded, size: 75), '/play', context)
            ),
            button(50, style, const Icon(Icons.settings), '/settings', context)
          ],
        )
      ),
    );
  }
}