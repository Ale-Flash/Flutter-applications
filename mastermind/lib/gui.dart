import 'package:flutter/material.dart';
import 'package:mastermind/logic.dart';
import 'home.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title = 'Master Mind'});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const MaterialColor theme = Colors.green;
  static final Color textColor =
      (theme.red * 0.3 + theme.green * 0.6 + theme.blue * 0.1) < 186
          ? Colors.white
          : Colors.black;
  late int colors, rows, availableColors, selectedIntColor, editableRow;
  Game game = Home.game;
  static const Color defaultColor = Color.fromARGB(255, 27, 27, 27);
  late List<int> guessed;
  late List<List<int>> numColorsButtons;
  late List<List<Color>> resultsOfTry;

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

    editableRow = rows;
    selectedIntColor = 0;
    guessed = List.filled(colors, 0, growable: false);

    numColorsButtons = List.generate(
        rows, (_) => List.filled(colors, -1, growable: false),
        growable: false);
    resultsOfTry = List.generate(rows, (_) => List.filled(colors, defaultColor),
        growable: false);

    game.start();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> sideButtons = [];
    const empty = SizedBox();
    const double padding = 1.5;

    // buttons for color selector
    for (int i = 0; i < availableColors; ++i) {
      sideButtons.add(Padding(
        padding: const EdgeInsets.all(padding),
        child: SizedBox(
            width: 50,
            height: 50,
            child: ElevatedButton(
              onPressed: () => setState(() {
                selectedIntColor = i;
              }),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(allColors[i]),
                shape: MaterialStateProperty.all(const CircleBorder()),
                padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
              ),
              child: selectedIntColor == i
                  ? (Icon(Icons.circle, color: betterColor(allColors[i])))
                  : empty,
            )),
      ));
    }

    // result row on top
    List<Widget> column = [];
    List<Widget> correctColors = [];
    for (int j = 0; j < colors; ++j) {
      correctColors.add(Padding(
          padding: const EdgeInsets.all(padding),
          child: SizedBox(
              width: game.colorNumber > 5 ? 45 : 50,
              height: game.colorNumber > 5 ? 45 : 50,
              child: Container(
                decoration: BoxDecoration(
                    color: game.isEnd()
                        ? allColors[game.showSequence()[j] - 1]
                        : defaultColor,
                    shape: BoxShape.circle),
              ))));
    }
    column.add(Padding(
        padding: const EdgeInsets.all(1),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: correctColors)));

    // selectable buttons for tries
    for (int i = 0; i < rows; ++i) {
      List<Widget> row = [];
      for (int j = 0; j < colors; ++j) {
        row.add(Padding(
            padding: const EdgeInsets.all(padding),
            child: SizedBox(
                width: game.colorNumber > 5 ? 45 : 50,
                height: game.colorNumber > 5 ? 45 : 50,
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    if (game.isEnd()) return;
                    if (i < editableRow) {
                      numColorsButtons[i][j] = selectedIntColor;
                    } else {
                      // if I press a previous color, that should be the selected color
                      selectedIntColor = numColorsButtons[i][j];
                    }
                  }),
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          numColorsButtons[i][j] == -1
                              ? defaultColor
                              : allColors[numColorsButtons[i][j]]),
                      shape: MaterialStateProperty.all(const CircleBorder())),
                  child: empty,
                ))));
      }

      // small buttons for the result
      List<Widget> smallButtons = List.generate(
          colors,
          (j) => Padding(
              padding: const EdgeInsets.all(1),
              child: SizedBox(
                  width: game.colorNumber > 5 ? 9 : 10,
                  height: game.colorNumber > 5 ? 9 : 10,
                  child: Container(
                    decoration: BoxDecoration(
                        color: resultsOfTry[i][j], shape: BoxShape.circle),
                  ))));
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
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (game.isEnd() || editableRow - 1 < 0) {
              setState(() {
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
            if (index != -1 && game.isValid(guessed)) {
              --editableRow;
              // add the colors of the small results buttons
              List<int> res = game.check(guessed);
              int pos = 0;
              for (int i = 0; i < res.length; ++i) {
                for (int j = 0; j < res[i]; ++j) {
                  resultsOfTry[editableRow][pos++] = showColor[i];
                }
              }
              if (game.isEnd()) {
                for (int i = 0; i < editableRow; ++i) {
                  for (int j = 0; j < colors; ++j) {
                    numColorsButtons[i][j] = -1;
                  }
                }
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
                });
              }
              setState(() {});
            }
          },
          backgroundColor: theme,
          child:
              Icon(game.isEnd() ? Icons.replay : Icons.check, color: textColor),
        ),
        body: Stack(children: [
          Align(
              alignment: const AlignmentDirectional(-0.987, .98),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: sideButtons)),
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
                  alignment: const AlignmentDirectional(-0.5, -0.5),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: column)),
            ),
          )
        ]));
  }
}
