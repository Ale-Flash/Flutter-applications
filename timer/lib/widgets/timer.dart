import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import '../main.dart';

class Clock extends StatefulWidget {
  const Clock({super.key});
  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
          alignment: const Alignment(0, -.28),
          // TIME TICKING
          child: SizedBox(
            child: RichText(
                text: TextSpan(
                    text: '',
                    style: TextStyle(
                        color: MyApp.thememe[MyApp.currentTheme]['selected'],
                        fontSize: MyApp.hours > 0
                            ? MyApp.hours >= 10
                                ? 60
                                : 65
                            : 70),
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
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(
                  begin: 0.0,
                  end: MyApp.initialTime == 0
                      ? 1
                      : (MyApp.currentTime / MyApp.initialTime)),
              duration: const Duration(seconds: 1),
              builder: (context, value, _) => CircularProgressIndicator(
                color: MyApp.thememe[MyApp.currentTheme]
                    [MyApp.timer.isPaused() ? 'disabled' : 'primary'],
                backgroundColor: MyApp.thememe[MyApp.currentTheme]['content'],
                value: ((MyApp.jump)
                    ? (MyApp.initialTime == 0
                        ? 1
                        : (MyApp.currentTime / MyApp.initialTime))
                    : value),
                strokeWidth: 7,
              ),
            )),
      )
    ]);
  }
}

class DigitalClock extends StatefulWidget {
  const DigitalClock({super.key});

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: const Alignment(0, -.5),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          NumberPicker(
              minValue: 0,
              maxValue: 24 - 1,
              value: MyApp.hours,
              infiniteLoop: true,
              itemHeight: 100,
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: MyApp.thememe[MyApp.currentTheme]['primary']!,
                        width: 2),
                    bottom: BorderSide(
                        color: MyApp.thememe[MyApp.currentTheme]['primary']!,
                        width: 2)),
              ),
              textStyle: TextStyle(
                  color: MyApp.thememe[MyApp.currentTheme]['secondary'],
                  fontSize: 50),
              selectedTextStyle: TextStyle(
                  color: MyApp.thememe[MyApp.currentTheme]['selected'],
                  fontSize: 50),
              onChanged: (value) {}),
          Text(':',
              style: TextStyle(
                  color: MyApp.thememe[MyApp.currentTheme]['selected'],
                  fontSize: 50)),
          NumberPicker(
              minValue: 0,
              maxValue: 60 - 1,
              value: MyApp.minutes,
              zeroPad: true,
              infiniteLoop: true,
              itemHeight: 100,
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: MyApp.thememe[MyApp.currentTheme]['primary']!,
                        width: 2),
                    bottom: BorderSide(
                        color: MyApp.thememe[MyApp.currentTheme]['primary']!,
                        width: 2)),
              ),
              textStyle: TextStyle(
                  color: MyApp.thememe[MyApp.currentTheme]['secondary'],
                  fontSize: 50),
              selectedTextStyle: TextStyle(
                  color: MyApp.thememe[MyApp.currentTheme]['selected'],
                  fontSize: 50),
              onChanged: (value) {}),
          Text(':',
              style: TextStyle(
                  color: MyApp.thememe[MyApp.currentTheme]['selected'],
                  fontSize: 50)),
          NumberPicker(
              minValue: 0,
              maxValue: 60 - 1,
              value: MyApp.seconds,
              zeroPad: true,
              infiniteLoop: true,
              itemHeight: 100,
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: MyApp.thememe[MyApp.currentTheme]['primary']!,
                        width: 2),
                    bottom: BorderSide(
                        color: MyApp.thememe[MyApp.currentTheme]['primary']!,
                        width: 2)),
              ),
              textStyle: TextStyle(
                  color: MyApp.thememe[MyApp.currentTheme]['secondary'],
                  fontSize: 50),
              selectedTextStyle: TextStyle(
                  color: MyApp.thememe[MyApp.currentTheme]['selected'],
                  fontSize: 50),
              onChanged: (value) {}),
        ]));
  }
}
