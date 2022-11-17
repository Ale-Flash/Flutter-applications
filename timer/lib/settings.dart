// ignore_for_file: prefer_const_constructors

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'main.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
        child: Scaffold(
            appBar: AppBar(title: const Text('Settings')),
            backgroundColor: MyApp.thememe[MyApp.currentTheme]['background'],
            body:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                margin: EdgeInsets.all(15),
                child: Text('Clock format:',
                    style: TextStyle(
                        fontSize: 20,
                        color: MyApp.thememe[MyApp.currentTheme]['text'])),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => setState(() {
                          MyApp.format = 0;
                          MyApp.refresh();
                        }),
                    highlightColor: Color.fromARGB(6, 150, 150, 150),
                    splashColor: Color.fromARGB(15, 150, 150, 150),
                    child: Container(
                      width: 180,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: MyApp.thememe[MyApp.currentTheme][
                                  MyApp.format == 0 ? 'primary' : 'secondary']!,
                              width: 3)),
                      padding: EdgeInsets.all(20),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          SizedBox(
                            child: RichText(
                                text: TextSpan(
                                    text: '',
                                    style: TextStyle(
                                        color: MyApp.thememe[MyApp.currentTheme]
                                            ['selected'],
                                        fontSize: 20),
                                    children: [
                                  TextSpan(text: '5:'),
                                  TextSpan(
                                      text: '00',
                                      style: TextStyle(
                                          color:
                                              MyApp.thememe[MyApp.currentTheme]
                                                  ['primary'])),
                                ])),
                          ),
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                              value: 0.875,
                              strokeWidth: 4,
                              color: MyApp.thememe[MyApp.currentTheme]
                                  ['primary'],
                              backgroundColor: MyApp.thememe[MyApp.currentTheme]
                                  ['secondary'],
                            ),
                          )
                        ],
                      ),
                    )),
                InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => setState(() {
                          MyApp.format = 1;
                          MyApp.refresh();
                        }),
                    highlightColor: Color.fromARGB(6, 150, 150, 150),
                    splashColor: Color.fromARGB(15, 150, 150, 150),
                    child: Container(
                        width: 180,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: MyApp.thememe[MyApp.currentTheme][
                                    MyApp.format == 1
                                        ? 'primary'
                                        : 'secondary']!,
                                width: 3)),
                        padding: EdgeInsets.all(20),
                        child: Row(children: [
                          NumberPicker(
                              minValue: 0,
                              maxValue: 24 - 1,
                              value: 0,
                              infiniteLoop: true,
                              itemHeight: 30,
                              itemWidth: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: MyApp.thememe[MyApp.currentTheme]
                                            ['primary']!,
                                        width: 1),
                                    bottom: BorderSide(
                                        color: MyApp.thememe[MyApp.currentTheme]
                                            ['primary']!,
                                        width: 1)),
                              ),
                              textStyle: TextStyle(
                                  color: MyApp.thememe[MyApp.currentTheme]
                                      ['secondary'],
                                  fontSize: 20),
                              selectedTextStyle: TextStyle(
                                  color: MyApp.thememe[MyApp.currentTheme]
                                      ['selected'],
                                  fontSize: 20),
                              onChanged: (a) {}),
                          Text(':',
                              style: TextStyle(
                                  color: MyApp.thememe[MyApp.currentTheme]
                                      ['selected'],
                                  fontSize: 20)),
                          NumberPicker(
                              minValue: 0,
                              maxValue: 60 - 1,
                              value: 5,
                              zeroPad: true,
                              infiniteLoop: true,
                              itemHeight: 30,
                              itemWidth: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: MyApp.thememe[MyApp.currentTheme]
                                            ['primary']!,
                                        width: 1),
                                    bottom: BorderSide(
                                        color: MyApp.thememe[MyApp.currentTheme]
                                            ['primary']!,
                                        width: 1)),
                              ),
                              textStyle: TextStyle(
                                  color: MyApp.thememe[MyApp.currentTheme]
                                      ['secondary'],
                                  fontSize: 20),
                              selectedTextStyle: TextStyle(
                                  color: MyApp.thememe[MyApp.currentTheme]
                                      ['selected'],
                                  fontSize: 20),
                              onChanged: (a) {}),
                          Text(':',
                              style: TextStyle(
                                  color: MyApp.thememe[MyApp.currentTheme]
                                      ['selected'],
                                  fontSize: 20)),
                          NumberPicker(
                              minValue: 0,
                              maxValue: 60 - 1,
                              value: 0,
                              zeroPad: true,
                              infiniteLoop: true,
                              itemHeight: 30,
                              itemWidth: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: MyApp.thememe[MyApp.currentTheme]
                                            ['primary']!,
                                        width: 1),
                                    bottom: BorderSide(
                                        color: MyApp.thememe[MyApp.currentTheme]
                                            ['primary']!,
                                        width: 1)),
                              ),
                              textStyle: TextStyle(
                                  color: MyApp.thememe[MyApp.currentTheme]
                                      ['secondary'],
                                  fontSize: 20),
                              selectedTextStyle: TextStyle(
                                  color: MyApp.thememe[MyApp.currentTheme]
                                      ['selected'],
                                  fontSize: 20),
                              onChanged: (a) {}),
                        ])))
              ]),
              Container(
                margin: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                child: ThemeSwitcher(
                    builder: (context) => InkWell(
                          borderRadius: BorderRadius.circular(4),
                          highlightColor: Color.fromARGB(6, 150, 150, 150),
                          splashColor: Color.fromARGB(15, 150, 150, 150),
                          onTap: () => setState(() {
                            // MyApp.currentTheme = (MyApp.currentTheme + 1) % 2;
                            // MyApp.refresh();

                            
                            ThemeSwitcher.of(context).changeTheme(
                                theme: ThemeData(
                                    colorScheme:
                                        ColorScheme.fromSwatch().copyWith(
                                  primary: MyApp.thememe[MyApp.currentTheme]
                                      ['primary'],
                                )),
                                isReversed: MyApp.currentTheme == 1);
                                MyApp.currentTheme = (MyApp.currentTheme + 1) % 2;
                          }),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('  Dark mode',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: MyApp.thememe[MyApp.currentTheme]
                                            ['text'])),
                                Switch(
                                    activeColor: MyApp
                                        .thememe[MyApp.currentTheme]['primary'],
                                    activeTrackColor: MyApp
                                        .thememe[MyApp.currentTheme]['primary'],
                                    inactiveThumbColor:
                                        MyApp.thememe[MyApp.currentTheme]
                                            ['disabled'],
                                    inactiveTrackColor:
                                        MyApp.thememe[MyApp.currentTheme]
                                            ['disabled'],
                                    splashRadius: 17,
                                    value: MyApp.currentTheme == 0,
                                    onChanged: (value) => setState(() {
                                          return;
                                          MyApp.currentTheme = value ? 0 : 1;
                                          ThemeSwitcher.of(context).changeTheme(
                                              theme: ThemeData(
                                                  colorScheme:
                                                      ColorScheme.fromSwatch()
                                                          .copyWith(
                                                primary: MyApp.thememe[MyApp
                                                    .currentTheme]['primary'],
                                              )),
                                              isReversed:
                                                  MyApp.currentTheme == 0);
                                          MyApp.refresh();
                                        })),
                              ]),
                        )),
              ),
            ])));
  }
}
