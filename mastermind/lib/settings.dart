import 'package:flutter/material.dart';
import 'logic.dart';

late Game game = Game(colorNumber: 4);
late Color theme = Colors.green;
late Color disabledColor = Colors.grey;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => SettingsApp();
}

class SettingsApp extends State<SettingsPage> {
  final TextStyle font = const TextStyle(fontSize: 17);
  Row changeSettingsLine(boolFunction, function, text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              if (boolFunction(-1)) {
                function(-1);
                setState(() {});
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    (boolFunction(-1)) ? theme : disabledColor),
                shape: MaterialStateProperty.all(const CircleBorder())),
            child: const Icon(Icons.remove)),
        Padding(padding: const EdgeInsets.all(5), child: Text('${text()}', style: font)),
        ElevatedButton(
            onPressed: () {
              if (boolFunction(1)) {
                function(1);
                setState(() {});
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    (boolFunction(1)) ? theme : disabledColor),
                shape: MaterialStateProperty.all(const CircleBorder())),
            child: const Icon(Icons.add)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const SizedBox space = SizedBox(height: 10);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Change number of rows', style: font),
              changeSettingsLine(game.canAddRows, game.addRowsNum, game.getRows),
              space,
              Text('Change number of column', style: font),
              changeSettingsLine(game.canAddCol, game.addColNum, game.getCol),
              space,
              Text('Change number of pickable colors', style: font),
              changeSettingsLine(game.canAddColors, game.addAvailColNum, game.getAvailableColors),
              space,
            ]
        )
      )
    );
  }
}
