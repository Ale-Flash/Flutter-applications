import 'package:flutter/material.dart';
import 'package:mastermind/logic.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   static const MaterialColor theme = Colors.green;
//   static final Color textColor =
//       (theme.red * 0.3 + theme.green * 0.6 + theme.blue * 0.1) < 186
//           ? Colors.white
//           : Colors.black;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(primarySwatch: theme),
//       home: const MyHomePage(title: 'Master Mind')
//     );
//   }
// }

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
  late int colors, rows, selectedIntColor, editableRow;
  late Game game;
  static const Color defaultColor = Colors.black;
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
  static const List<Color> showColor = [
    Colors.green,
    Colors.yellow,
    Colors.red
  ];

  _MyHomePageState() {
    initialize();
  }

  Color betterColor(Color c) {
    return (c.red * 0.3 + c.green * 0.6 + c.blue * 0.1) < 186
        ? Colors.white
        : Colors.black;
  }

  void initialize() {
    rows = 10;
    colors = 4;

    editableRow = rows;
    selectedIntColor = 0;
    guessed = List.filled(colors, 0, growable: false);
    game = Game(
        colorNumber: colors,
        rows: rows,
        colorsAvailable: allColors.length,
        allowRepetition: false);

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
    // TODO SCEGLIERE ICONA Icons.circle
    // const iconW = Icon(Icons.circle, color: Colors.white);
    // const iconB = Icon(Icons.circle, color: Colors.black);

    // buttons for color selector
    for (int i = 0; i < allColors.length; ++i) {
      sideButtons.add(Padding(
        padding: const EdgeInsets.all(1),
        child: SizedBox(
            width: 50,
            height: 50,
            child: ElevatedButton(
              onPressed: () => setState(() {
                selectedIntColor = i;
              }),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(allColors[i]),
                  shape: MaterialStateProperty.all(const CircleBorder()),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0))),
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
          padding: const EdgeInsets.all(1),
          child: SizedBox(
              width: 50,
              height: 50,
              child: Container(
                  decoration: BoxDecoration(
                    color: game.isEnd() ? allColors[game.showSequence()[j] - 1]
                            : defaultColor,
                    shape: BoxShape.circle
                  ),
              )
          )
        )
      );
    }
    column.add(Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: correctColors));

    // selectable buttons for tries
    for (int i = 0; i < rows; ++i) {
      List<Widget> row = [];
      for (int j = 0; j < colors; ++j) {
        row.add(Padding(
            padding: const EdgeInsets.all(1),
            child: SizedBox(
                width: 50,
                height: 50,
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
            child: 
              SizedBox(
                width: 10,
                height: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: resultsOfTry[i][j],
                    shape: BoxShape.circle
                  ),
              )
            ) 
          )
      );

      row.add(Column(
          children: [
            Row(children: smallButtons.sublist(0, colors ~/ 2)),
            Row(children: smallButtons.sublist(colors ~/ 2))
          ]
        )
      );

      column.add(Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: row));
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
              List<int> res = game.check(guessed);
              int pos = 0;
              for (int i = 0; i < res.length; ++i) {
                for (int j = 0; j < res[i]; ++j) {
                  resultsOfTry[editableRow][pos++] = showColor[i];
                }
              }
              setState(() {});
            }
          },
          backgroundColor: theme,
          child: Icon(Icons.check, color: textColor),
        ),
        body: Stack(children: [
          Align(
              alignment: const AlignmentDirectional(-1, 1),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: sideButtons)),
          Align(
              alignment: const AlignmentDirectional(0.25, -0.75),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: column))
        ]));
  }
}
