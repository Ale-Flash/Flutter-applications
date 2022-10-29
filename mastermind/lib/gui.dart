import 'package:flutter/material.dart';
import 'package:mastermind/logic.dart';
import 'home.dart';

class MyHomePage extends StatefulWidget {
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

  const MyHomePage({super.key, this.title = 'Master Mind'});
  final String title;

  static Color betterColor(Color c) {
    return (c.red * 0.3 + c.green * 0.6 + c.blue * 0.1) < 186
        ? Colors.white
        : Colors.black;
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const MaterialColor theme = Colors.green;
  static final Color textColor =
      (theme.red * 0.3 + theme.green * 0.6 + theme.blue * 0.1) < 186
          ? Colors.white
          : Colors.black;
  late int colors, rows, availableColors, editableRow;
  Game game = Home.game;
  static const Color defaultColor = Color.fromARGB(255, 27, 27, 27);
  late List<int> guessed;
  late List<List<int>> numColorsButtons;
  late List<List<int>> resultsOfTry;
  bool alertVisible = false;
  _MyHomePageState() {
    initialize();
  }

  Color betterColor(Color c) {
    return (c.red * 0.3 + c.green * 0.6 + c.blue * 0.1) < 186
        ? Colors.white
        : Colors.black;
  }

  void initialize() {
    rows = game.rows;
    colors = game.colorNumber;
    availableColors = game.colorsAvailable;

    editableRow = rows - game.nGuesses;
    MyHomePage.selectedIntColor = 0;
    guessed = List.filled(colors, 0, growable: false);

    numColorsButtons = List.generate(
        rows,
        (i) => List.generate(colors, (j) => (game.guesses[rows - i - 1][j] - 1),
            growable: false),
        growable: false);
    resultsOfTry =
        List.generate(rows, (_) => List.filled(colors, -1), growable: false);
    for (int pos = 0; pos < rows; ++pos) {
      int index = 0;
      for (int i = 0; i < game.results[pos].length; ++i) {
        for (int j = 0; j < game.results[pos][i]; ++j) {
          resultsOfTry[rows - pos - 1][index++] = i;
        }
      }
    }
  }

  bool wait = false;
  double padding = 1.5;
  @override
  Widget build(BuildContext context) {
    const empty = SizedBox();

    // result row on top
    List<Widget> column = [];
    List<Widget> correctColors = [];
    for (int j = 0; j < colors; ++j) {
      correctColors.add(Container(
          padding: EdgeInsets.all(padding),
          width: game.colorNumber > 5 ? 44 : 51,
          height: game.colorNumber > 5 ? 44 : 51,
          child: Container(
            decoration: BoxDecoration(
                color: game.isEnd()
                    ? MyHomePage.allColors[game.showSequence()[j] - 1]
                    : defaultColor,
                shape: BoxShape.circle),
          )));
    }
    correctColors.add(Container(
      padding: EdgeInsets.all(padding),
      width: game.colorNumber >= 5 ? 33 : 25,
    ));
    column.add(Container(
        padding: const EdgeInsets.all(1),
        // width: MediaQuery.of(context).size.width * 0.76,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: correctColors)));

    // selectable buttons for tries
    for (int i = 0; i < rows; ++i) {
      List<Widget> row = [];
      for (int j = 0; j < colors; ++j) {
        row.add(Container(
            padding: EdgeInsets.all(padding),
            width: game.colorNumber > 5 ? 44 : 51,
            height: game.colorNumber > 5 ? 44 : 51,
            child: ElevatedButton(
              onPressed: () => setState(() {
                if (game.isEnd()) return;
                if (i < editableRow) {
                  numColorsButtons[i][j] = MyHomePage.selectedIntColor;
                } else {
                  // if I press a previous color, that should be the selected color
                  MyHomePage.selectedIntColor = numColorsButtons[i][j];
                }
              }),
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      numColorsButtons[i][j] == -1
                          ? defaultColor
                          : MyHomePage.allColors[numColorsButtons[i][j]]),
                  shape: MaterialStateProperty.all(const CircleBorder())),
              child: empty,
            )));
      }

      // small buttons for the result
      List<Widget> smallButtons = List.generate(
          colors,
          (j) => Container(
              padding: const EdgeInsets.all(1),
              width: game.colorNumber > 5 ? 11 : 12,
              height: game.colorNumber > 5 ? 11 : 12,
              child: Container(
                decoration: BoxDecoration(
                    color: resultsOfTry[i][j] == -1
                        ? defaultColor
                        : MyHomePage.showColor[resultsOfTry[i][j]],
                    shape: BoxShape.circle),
              )));
      // row.add(const SizedBox(width: 1));
      row.add(Column(children: <Widget>[
        Row(children: smallButtons.sublist(0, colors ~/ 2)),
        Row(children: smallButtons.sublist(colors ~/ 2))
      ]));

      column.add(Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
              color: (i + 1 == editableRow) ? Colors.grey : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(5555))),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row)));
    }

    // TODO PAGINA INIZIALE CON IMPOSTAZIONI
    // TODO SUONI, NUMERO RIGHE, COLONNE, CONSENTI DUPLICATI
    // LINGUA?
    // TODO add correct row, add win and lose screen

    // TODO add highscore and/or timer

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            SizedBox(
                width: 50,
                child: GestureDetector(
                    onTap: () => setState(() {
                          game.start();
                          initialize();
                        }),
                    // style: ButtonStyle(
                    //     backgroundColor: const MaterialStatePropertyAll<Color>(Colors.green),
                    //     shape: MaterialStateProperty.all(const CircleBorder())),
                    child: const Icon(Icons.replay, color: Colors.white)))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (wait) return;
            if (game.isEnd() || editableRow - 1 < 0) {
              setState(() {
                game.start();
                initialize();
              });
              return;
            }
            int index = 0;
            for (int j = 0; j < colors; ++j) {
              index = numColorsButtons[editableRow - 1][j];
              if (index == -1) break;
              guessed[j] = index + 1;
            }
            if (index == -1 || !game.isValid(guessed)) {
              alertVisible = true;
              setState(() {});
              Future.delayed(const Duration(seconds: 2), () {
                alertVisible = false;
                setState(() {});
              });
              return;
            }

            // add the colors of the small results buttons
            List<int> res = game.check(guessed);
            int pos = 0;
            for (int i = 0; i < res.length; ++i) {
              for (int j = 0; j < res[i]; ++j) {
                resultsOfTry[editableRow - 1][pos++] = i;
              }
            }
            if (game.isEnd()) {
              for (int i = 0; i < editableRow - 1; ++i) {
                for (int j = 0; j < colors; ++j) {
                  numColorsButtons[i][j] = -1;
                }
              }
              wait = true;
              Future.delayed(const Duration(seconds: 1), () {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title:
                              Text(game.isWin() ? 'You won!' : 'You lost :('),
                          content: Text(game.isWin()
                              ? 'congratulations :)'
                              : 'keep trying'),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ));
                wait = false;
              });
              ++editableRow;
            }
            --editableRow;
            setState(() {});
          },
          backgroundColor: theme,
          child:
              Icon(game.isEnd() ? Icons.replay : Icons.check, color: textColor),
        ),
        body: Stack(children: [
          Align(
              alignment: const AlignmentDirectional(-.99, .98),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: List.generate(
                    // TODO mettere qui al posto dell'icona il bordo esterno
                    game.colorsAvailable,
                    (index) => Container(
                        padding: const EdgeInsets.all(3),
                        width: 55,
                        height: 55,
                        // decoration: BoxDecoration(
                        //   borderRadius: const BorderRadius.all(Radius.circular(5555)),
                        //   border: Border.all(color: MyHomePage.selectedIntColor == index ? Colors.black : Colors.transparent, width: 3)
                        //   ),
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            MyHomePage.selectedIntColor = index;
                          }),
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                MyHomePage.allColors[index]),
                            shape:
                                MaterialStateProperty.all(const CircleBorder()),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(0)),
                          ),
                          child: MyHomePage.selectedIntColor == index
                              ? (Icon(
                                  Icons.radio_button_off_rounded,
                                  color: MyHomePage.betterColor(
                                      MyHomePage.allColors[index]),
                                  size: 30,
                                ))
                              : const SizedBox(),
                        )),
                  ))),
          Align(
            alignment: const AlignmentDirectional(1, 1),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 1,
                decoration: const BoxDecoration(
                  color: Color(0xFF5F5F5F),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(35)),
                ),
                child: Align(
                    alignment: const AlignmentDirectional(1, -.7),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Align(
                            alignment: const AlignmentDirectional(0, 0.05),
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: column))))),
          ),
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
          ),
          // TODO sistemare mettere timer
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
