import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gui.dart';
import 'settings.dart';
import 'tutorial.dart';
import 'logic.dart';

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});
  static const MaterialColor mainColor = Colors.green;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: mainColor),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => Home(),
          '/tutorial': (BuildContext context) => Tutorial(),
          '/play': (BuildContext context) => MyHomePage(),
          '/settings': (BuildContext context) => const SettingsPage()
        },
        debugShowCheckedModeBanner: false);
  }
}

class Home extends StatelessWidget {
  static Game game = Game();

  SizedBox button(double size, ButtonStyle style, Icon icon, String route,
      BuildContext context) {
    return SizedBox(
        width: size,
        height: size,
        child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, route),
            style: style,
            child: icon));
  }

  Home({super.key}) {
    // restore the previous settings and previous game
    SharedPreferences.getInstance().then((prefs) {
      Home.game.setRows(prefs.getInt('rows') ?? -1);
      Home.game.setCols(prefs.getInt('cols') ?? -1);
      Home.game.setColors(prefs.getInt('colors') ?? -1);
      Home.game.setRepetition(prefs.getBool('duplicate') ?? false);
      Home.game.start();
      List<String> saved = prefs.getStringList('game') ?? [];
      String seq = prefs.getString('sequence') ?? '';
      if (seq == '') return;
      for (int i = 0; i < seq.length; ++i) {
        Home.game.correctSequence[i] = int.parse(seq[i]);
      }
      for (int i = 0; i < saved.length; ++i) {
        List<int> guess = [];
        for (int j = 0; j < saved[i].length; ++j) {
          guess.add(int.parse(saved[i][j]));
        }
        Home.game.check(guess);
      }
    });
  }

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
          button(50, style, const Icon(Icons.question_mark_rounded),
              '/tutorial', context),
          Padding(
              padding: const EdgeInsets.all(5),
              child: button(
                  75,
                  style,
                  const Icon(Icons.play_arrow_rounded, size: 75),
                  '/play',
                  context)),
          button(50, style, const Icon(Icons.settings), '/settings', context)
        ],
      )),
    );
  }
}
