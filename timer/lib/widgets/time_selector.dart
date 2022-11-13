import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import '../main.dart';

class TimeSelector extends StatefulWidget {
  const TimeSelector({super.key});

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                    width: 3)),
          ),
          textStyle: TextStyle(
              color: MyApp.thememe[MyApp.currentTheme]['secondary'],
              fontSize: 50),
          selectedTextStyle: TextStyle(
              color: MyApp.thememe[MyApp.currentTheme]['selected'],
              fontSize: 50),
          onChanged: (value) => setState(() {
                if (value == 0 && MyApp.minutes == 0 && MyApp.seconds == 0) {
                  MyApp.seconds = 1;
                }
                MyApp.hours = value;
              })),
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
                    width: 3)),
          ),
          textStyle: TextStyle(
              color: MyApp.thememe[MyApp.currentTheme]['secondary'],
              fontSize: 50),
          selectedTextStyle: TextStyle(
              color: MyApp.thememe[MyApp.currentTheme]['selected'],
              fontSize: 50),
          onChanged: (value) => setState(() {
                if (MyApp.hours == 0 && value == 0 && MyApp.seconds == 0) {
                  MyApp.seconds = 1;
                }
                MyApp.minutes = value;
              })),
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
                    width: 3)),
          ),
          textStyle: TextStyle(
              color: MyApp.thememe[MyApp.currentTheme]['secondary'],
              fontSize: 50),
          selectedTextStyle: TextStyle(
              color: MyApp.thememe[MyApp.currentTheme]['selected'],
              fontSize: 50),
          onChanged: (value) => setState(() {
                if (MyApp.hours == 0 && MyApp.minutes == 0 && value == 0) {
                  MyApp.seconds = 1;
                } else {
                  MyApp.seconds = value;
                }
              })),
    ]);
  }
}
