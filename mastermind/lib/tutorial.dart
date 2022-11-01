import 'package:flutter/material.dart';
import 'logic.dart';
import 'gui.dart';

class Tutorial extends StatelessWidget {
  Tutorial({super.key});
  final style = const TextStyle(color: Colors.black, fontSize: 17);
  final Game g = Game();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutorial')),
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(30),
              child: ListView(children: [
                Text(
                    '''The computer picks a sequence of colors. Like this one:''',
                    style: style),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        4,
                        (index) => Container(
                            margin: const EdgeInsets.fromLTRB(3, 8, 3, 10),
                            padding: const EdgeInsets.all(1.5),
                            width: 51,
                            height: 51,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          MyHomePage.allColors[
                                              g.correctSequence[index] - 1]),
                                  shape: MaterialStateProperty.all(
                                      const CircleBorder())),
                              child: const SizedBox(),
                            )))),
                Text(
                    '''The number of colors is the code length.
The default code length is 4 but it can be changed on the settings menu.
The objective of the game is to guess the exact positions of the colors in the computer's sequence.
By default, a color can be used only once in a code sequence.
If you start a new game with the 'Allow color repetition' checked, then any color can be used any number of times in the code sequence.
After filling a line with your guesses and clicking on the bottom button, the computer responses with the result of your guess.
For each color in your guess that is in the correct color and correct position in the code sequence, the computer display a small red color on the right side of the current guess.''',
                    style: style),
                Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(1),
                    width: 12,
                    height: 12,
                    child: Container(
                        decoration: BoxDecoration(
                            color: MyHomePage.showColor[0],
                            border: Border.all(color: Colors.black),
                            shape: BoxShape.circle))),
                Text(
                    '''For each color in your guess that is in the correct color but is NOT in the correct position in the code sequence, the computer display a small white color on the right side of the current guess.''',
                    style: style),
                Container(
                    margin: const EdgeInsets.only(bottom: 15, top: 10),
                    padding: const EdgeInsets.all(1),
                    width: 12,
                    height: 12,
                    child: Container(
                        decoration: BoxDecoration(
                            color: MyHomePage.showColor[1],
                            border: Border.all(color: Colors.black),
                            shape: BoxShape.circle))),
                Text(
                    '''You win the game when you manage to guess all the colors in the code sequence and when they all in the right position.
You lose the game if you use all attempts without guessing the computer code sequence.
Good Luck!''',
                    style: style)
              ]))),
    );
  }
}
