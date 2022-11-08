import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'coloredcontainer.dart';
import 'gui.dart';
import 'home.dart';
import 'logic.dart';
import 'trybutton.dart';

class Board extends StatefulWidget {
  Board({super.key, required this.sidebar});
  final BoardState boardstate = BoardState();
  void refresh() {
    boardstate.refresh();
  }

  final SideBar sidebar;
  @override
  State<Board> createState() => boardstate;
}

class BoardState extends State<Board> {
  final Game game = Home.game;
  final double padding = 1.5;
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              // RESULT ROW (FIRST ROW)
                              padding: const EdgeInsets.all(1),
                              child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ...List.generate(
                                        // colored containers containing the computer code
                                        game.colorNumber,
                                        (j) => ColoredContainer(
                                            size:
                                                game.colorNumber > 5 ? 44 : 51,
                                            padding: padding,
                                            color: game.isEnd()
                                                ? MyHomePage.allColors[
                                                    game.showSequence()[j] - 1]
                                                : MyHomePage.defaultColor)),
                                    Container(
                                      // empty space
                                      padding: EdgeInsets.all(padding),
                                      width: game.colorNumber >= 5 ? 33 : 25,
                                    )
                                  ])),
                          ...List.generate(
                              game.rows,
                              (i) => Container(
                                  padding: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                      color: (i + 1 == MyHomePage.editableRow)
                                          ? Colors.grey
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5555))),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ...List.generate(
                                            // selectable buttons for tries
                                            game.colorNumber,
                                            (j) => TryButton(
                                                function: () {
                                                  if (game.isEnd()) return;
                                                  if (i <
                                                      MyHomePage.editableRow) {
                                                    setState(() {
                                                      MyHomePage.numColorsButtons[
                                                              i][j] =
                                                          MyHomePage
                                                              .selectedIntColor;
                                                    });
                                                  } else {
                                                    // if I press a previous color, that should be the selected color
                                                    MyHomePage
                                                            .selectedIntColor =
                                                        MyHomePage
                                                                .numColorsButtons[
                                                            i][j];
                                                    widget.sidebar.refresh();
                                                  }
                                                },
                                                size: game.colorNumber > 5
                                                    ? 44
                                                    : 51,
                                                padding: padding,
                                                color: MyHomePage
                                                                .numColorsButtons[
                                                            i][j] ==
                                                        -1
                                                    ? MyHomePage.defaultColor
                                                    : MyHomePage
                                                        .allColors[MyHomePage
                                                            .numColorsButtons[i]
                                                        [j]])),
                                        Column(children: <Widget>[
                                          // small buttons for the result
                                          Row(
                                              children: List.generate(
                                                  game.colorNumber ~/ 2,
                                                  (j) => ColoredContainer(
                                                      size: game.colorNumber > 5
                                                          ? 11
                                                          : 12,
                                                      padding: 1,
                                                      color: MyHomePage.resultsOfTry[
                                                                  i][j] ==
                                                              -1
                                                          ? MyHomePage
                                                              .defaultColor
                                                          : MyHomePage
                                                              .showColor[MyHomePage
                                                                  .resultsOfTry[
                                                              i][j]]))),
                                          Row(
                                              children: List.generate(
                                                  game.colorNumber -
                                                      game.colorNumber ~/ 2,
                                                  (j) => ColoredContainer(
                                                      size: game.colorNumber > 5
                                                          ? 11
                                                          : 12,
                                                      padding: 1,
                                                      color: MyHomePage.resultsOfTry[i][j +
                                                                  game.colorNumber ~/
                                                                      2] ==
                                                              -1
                                                          ? MyHomePage
                                                              .defaultColor
                                                          : MyHomePage.showColor[
                                                              MyHomePage.resultsOfTry[i]
                                                                  [j + game.colorNumber ~/ 2]]))),
                                        ])
                                      ])))
                        ])))));
  }
}
