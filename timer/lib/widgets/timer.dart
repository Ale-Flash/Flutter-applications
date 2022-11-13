import 'package:flutter/material.dart';
import '../main.dart';

class Clock extends StatefulWidget {
  const Clock({super.key});
  // final _ClockState cs = _ClockState();
  @override
  State<Clock> createState() => _ClockState();
  // void refresh() {
  //   cs.refresh();
  // }
}

class _ClockState extends State<Clock> {
  // void refresh() {
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
          alignment: const Alignment(0, -.269),
          // TIME TICKING
          child: SizedBox(
            child: RichText(
                text: TextSpan(
                    text: '',
                    style: TextStyle(
                        color: MyApp.thememe[MyApp.currentTheme]['selected'],
                        fontSize: MyApp.hours > 0 ? MyApp.hours >= 10 ? 60 : 65 : 70),
                    children: [
                  TextSpan(text: MyApp.hours > 0 ? '${MyApp.hours}:' : ''),
                  TextSpan(
                      text: (MyApp.minutes < 10
                          ? '0${MyApp.minutes}:'
                          : '${MyApp.minutes}:')),
                  TextSpan(
                      text: (MyApp.seconds < 10
                          ? '0${MyApp.seconds}'
                          : '${MyApp.seconds}'),
                      style: TextStyle(
                          color: MyApp.thememe[MyApp.currentTheme]['primary'])),
                ])),
          )),
      Align(
        alignment: const Alignment(0, -0.4),
        // TIME TICKING
        child: SizedBox(
            width: 270,
            height: 270,
            child: CircularProgressIndicator(
              color: MyApp.thememe[MyApp.currentTheme]
                  [MyApp.timer.isPaused() ? 'disabled' : 'primary'],
              backgroundColor: MyApp.thememe[MyApp.currentTheme]['content'],
              value: MyApp.initialTime == 0
                  ? 1
                  : (MyApp.currentTime / MyApp.initialTime),
              strokeWidth: 7,
            )),
      )
    ]);
  }
}
