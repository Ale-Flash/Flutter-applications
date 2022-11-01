import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'board.dart';
import 'sidebar.dart';
import 'logic.dart';
import 'home.dart';

class MyHomePage extends StatefulWidget {
  final Color textColor = betterColor(HomeApp.mainColor);
  static const Color defaultColor = Color.fromARGB(255, 27, 27, 27);
  static late List<int> guessed;
  static late List<List<int>> numColorsButtons;
  static late List<List<int>> resultsOfTry;
  static late int colors, rows, availableColors, editableRow;
  static const List<Color> allColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.pink,
  ];
  static const List<Color> showColor = [Colors.red, Colors.white, Colors.black];
  static int selectedIntColor = 0;
  MyHomePage({super.key, this.title = 'Master Mind'});
  final String title;

  final MyHomePageState myhomepagestate = MyHomePageState();
  static Color betterColor(Color c) {
    return (c.red * 0.3 + c.green * 0.6 + c.blue * 0.1) < 186
        ? Colors.white
        : Colors.black;
  }

  @override
  State<MyHomePage> createState() => myhomepagestate;
}

class MyHomePageState extends State<MyHomePage> {
  final SideBar sidebar = SideBar();
  void refreshSideBar() {
    sidebar.refresh();
  }

  final Game game = Home.game;
  late final Board board;
  bool alertVisible = false;
  MyHomePageState() {
    board = Board(sidebar: sidebar);
    initialize();
  }

  void initialize() {
    MyHomePage.rows = game.rows;
    MyHomePage.colors = game.colorNumber;
    MyHomePage.availableColors = game.colorsAvailable;

    MyHomePage.editableRow = MyHomePage.rows - game.nGuesses;
    MyHomePage.selectedIntColor = 0;
    MyHomePage.guessed = List.filled(MyHomePage.colors, 0, growable: false);

    MyHomePage.numColorsButtons = List.generate(
        MyHomePage.rows,
        (i) => List.generate(MyHomePage.colors,
            (j) => (game.guesses[MyHomePage.rows - i - 1][j] - 1),
            growable: false),
        growable: false);
    MyHomePage.resultsOfTry = List.generate(
        MyHomePage.rows, (_) => List.filled(MyHomePage.colors, -1),
        growable: false);
    for (int pos = 0; pos < MyHomePage.rows; ++pos) {
      int index = 0;
      for (int i = 0; i < game.results[pos].length; ++i) {
        for (int j = 0; j < game.results[pos][i]; ++j) {
          MyHomePage.resultsOfTry[MyHomePage.rows - pos - 1][index++] = i;
        }
      }
    }
  }

  bool wait = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            SizedBox(
                // REFRESH BUTTON ON TOP RIGHT
                width: 50,
                child: GestureDetector(
                    onTap: () => setState(() {
                          game.start();
                          initialize();
                          board.refresh();
                          sidebar.refresh();
                        }),
                    child: const Icon(Icons.replay, color: Colors.white)))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // BOTTOM RIGHT BUTTON FOR CHECK SEQUENCE
            if (wait) return;
            if (game.isEnd() || MyHomePage.editableRow - 1 < 0) {
              setState(() {
                game.start();
                initialize();
                board.refresh();
                sidebar.refresh();
              });
              return;
            }
            int index = 0;
            for (int j = 0; j < MyHomePage.colors; ++j) {
              index =
                  MyHomePage.numColorsButtons[MyHomePage.editableRow - 1][j];
              if (index == -1) break;
              MyHomePage.guessed[j] = index + 1;
            }
            if (index == -1 || !game.isValid(MyHomePage.guessed)) {
              // if already visible do nothing
              if (alertVisible) return;
              alertVisible = true;
              setState(() {});
              Future.delayed(const Duration(seconds: 2), () {
                alertVisible = false;
                try {
                  // if I exit the play screen it gives an error
                  setState(() {});
                } catch (error) {}
              });
              return;
            }

            // add the colors of the small results buttons
            List<int> res = game.check(MyHomePage.guessed);
            int pos = 0;
            for (int i = 0; i < res.length; ++i) {
              for (int j = 0; j < res[i]; ++j) {
                MyHomePage.resultsOfTry[MyHomePage.editableRow - 1][pos++] = i;
              }
            }
            if (game.isEnd()) {
              for (int i = 0; i < MyHomePage.editableRow - 1; ++i) {
                for (int j = 0; j < MyHomePage.colors; ++j) {
                  MyHomePage.numColorsButtons[i][j] = -1;
                }
              }
              wait = true;
              Future.delayed(const Duration(seconds: 1), () {
                CoolAlert.show(
                    context: context,
                    type: game.isWin()
                        ? CoolAlertType.success
                        : CoolAlertType.error,
                    title: game.isWin() ? 'You won!' : 'You lost :(',
                    text: game.isWin() ? 'congratulations :)' : 'keep trying',
                    confirmBtnColor: HomeApp.mainColor);

                wait = false;
              });
              ++MyHomePage.editableRow;
            }
            --MyHomePage.editableRow;
            board.refresh();
            setState(() {});
          },
          backgroundColor: HomeApp.mainColor,
          child: Icon(game.isEnd() ? Icons.replay : Icons.check,
              color: widget.textColor),
        ),
        body: Stack(children: [
          Align(
              alignment: const AlignmentDirectional(-.99, .98), child: sidebar),
          Align(alignment: const AlignmentDirectional(1, 1), child: board),
          Align(
            alignment: const AlignmentDirectional(0, -.98),
            child: Container(
              decoration: BoxDecoration(
                  color: alertVisible
                      ? const Color(0xE6FFFFFF)
                      : Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: SizedBox(
                width: 350,
                height: 50,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: alertVisible
                      ? const [
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.red, size: 24),
                          Text('Missing some buttons...',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black))
                        ]
                      : [],
                ),
              ),
            ),
          )
        ]));
  }
}
