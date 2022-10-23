import 'package:flutter/material.dart';


class Tutorial extends StatelessWidget {
  const Tutorial({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutorial')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 17), /*defining default style is optional */
              children: <TextSpan>[
                TextSpan(
                    text: 'MasterMind', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: ' is a game where you have to guess a sequence of colors. Every time you insert a sequence, three colors can results:\n',
                ),
                TextSpan(
                    text: 'red',
                    style: TextStyle(backgroundColor: Colors.red)),
                TextSpan(
                    text: ': number of correct colors\n',
                ),
                TextSpan(
                    text: 'white',
                    style: TextStyle(backgroundColor: Colors.white)),
                TextSpan(
                    text: ': number of correct colors in incorrect place\n',
                ),
                TextSpan(
                    text: 'black',
                    style: TextStyle(backgroundColor: Colors.black, color: Colors.white)),
                TextSpan(
                    text: ': number of incorrect colors\n',
                ),
                TextSpan(
                    text: '\nWatch out you have only a limited amount of guesses!\n',
                ),
              ],
            )
          ),
        )
      ),
    );
  }

// MasterMind is a game where you have to
// guess a sequence of colors.
// Every time you insert a sequence, three
// colors can results:
// red: number of correct colors
// white: number of correct colors in incorrect place
// black: number of incorrect colors

        // Text('''
        // ''', style: TextStyle(fontSize: 17)
}