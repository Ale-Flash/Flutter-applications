import 'package:flutter/material.dart';
import 'gui.dart';
import 'home.dart';
import 'logic.dart';

class SideBar extends StatefulWidget {
  SideBar({super.key});
  final Game game = Home.game;
  final _SideBarState _sideBarState = _SideBarState();
  @override
  State<SideBar> createState() => _sideBarState;
  void refresh() {
    _sideBarState.refresh();
  }
}

class _SideBarState extends State<SideBar> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: List.generate(
          widget.game.colorsAvailable,
          (index) => Container(
              padding: const EdgeInsets.all(3),
              width: 55,
              height: 55,
              child: ElevatedButton(
                onPressed: () => setState(() {
                  MyHomePage.selectedIntColor = index;
                }),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      MyHomePage.allColors[index]),
                  shape: MaterialStateProperty.all(const CircleBorder()),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                ),
                child: MyHomePage.selectedIntColor == index
                    ? (Icon(
                        Icons.radio_button_off_rounded,
                        color:
                            MyHomePage.betterColor(MyHomePage.allColors[index]),
                        size: 30,
                      ))
                    : const SizedBox(),
              )),
        ));
  }
}
