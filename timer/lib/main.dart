import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'logic.dart';
import 'widgets/time_selector.dart';
import 'widgets/timer.dart';

// TODO https://pub.dev/packages/flutter_local_notifications
// TODO con pausa, riprendi, elimina
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const List<Map<String, Color>> thememe = [
    {
      'primary': Color(0xFF6200EE),
      'background': Color(0xFF121212),
      'secondary': Color(0xFF1E1E1E),
      'content': Color(0x89000000),
      'selected': Color(0xFFD3D3D3),
      'disabled': Color(0xFF424242)
    },
    {
      'primary': Color(0xFF005FEE),
      'background': Color(0xFFFFFFFF),
      'text': Color(0xFF131313),
      'secondary': Color(0xFF666666),
      'content': Color(0xE80F0F0F),
      'selected': Color(0xFF131313),
      'disabled': Color(0xFF666666)
    },
  ];
  static int currentTheme = 0;
  // static int hours = 0, minutes = 5, seconds = 0;
  static int hours = 0, minutes = 0, seconds = 3;
  static int initialTime = 0, currentTime = 0;
  static late MyTimer timer;

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: thememe[currentTheme]['primary'],
      )),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Stream blinkEvent =
      Stream.periodic(const Duration(milliseconds: 500), (tick) => tick);
  late StreamSubscription blink;
  _MyHomePageState() {
    MyApp.timer = MyTimer(update);
  }
  void update(int time) => setState(() {
        if (time == 0) snooze();
        MyApp.currentTime = time;
        MyApp.hours = time ~/ 3600;
        time %= 3600;
        MyApp.minutes = time ~/ 60;
        time %= 60;
        MyApp.seconds = time;
        print(MyApp.currentTime);
      });

  bool showTimeSelector = true;

  void updateTime() {
    MyApp.initialTime = MyApp.hours * 3600 + MyApp.minutes * 60 + MyApp.seconds;
    MyApp.currentTime = MyApp.initialTime;
    MyApp.timer.setTime(MyApp.initialTime);
  }

  bool isEnded = false;
  void snooze() {
    isEnded = true;
    FlutterRingtonePlayer.playNotification();
    // FlutterRingtonePlayer.play(
    //   android: AndroidSounds.notification,
    //   ios: IosSounds.glass,
    //   looping: true, // Android only - API >= 28
    //   volume: 0.1, // Android only - API >= 28
    //   asAlarm: false, // Android only - all APIs
    // );
    // FlutterRingtonePlayer.playAlarm().then(print);
    blink = blinkEvent.listen((tick) {
      if (tick % 3 == 0) {
        MyApp.currentTime = MyApp.initialTime;
        setState(() {});
      } else if (tick % 3 == 2) {
        MyApp.currentTime = 0;
        setState(() {});
      }
    });
  }

  void stopSnooze() {
    isEnded = false;
    FlutterRingtonePlayer.stop().then(print);
    blink.pause();
  }

  late Clock clock;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        backgroundColor: MyApp.thememe[MyApp.currentTheme]['background'],
        body: Stack(
          children: showTimeSelector
              ? [
                  const Align(
                      alignment: Alignment(0, -0.2),
                      // CHOOSE TIME
                      child: TimeSelector()),
                  Align(
                      alignment: const Alignment(0, 0.7),
                      child: SizedBox(
                          width: 70,
                          height: 70,
                          child: ElevatedButton(
                              // START TIMER BUTTON
                              onPressed: () => setState(() {
                                    updateTime();
                                    MyApp.timer.create();
                                    showTimeSelector = false;
                                  }),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          MyApp.thememe[MyApp.currentTheme]
                                              ['primary']!),
                                  // this make the icon align to the center
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(0)),
                                  shape: MaterialStateProperty.all(
                                      const CircleBorder())),
                              child: const Icon(Icons.play_arrow_rounded,
                                  size: 50))))
                ]
              : [
                  // ignore: prefer_const_constructors
                  clock = Clock(),
                  Align(
                      alignment: const Alignment(0, 0.7),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: ElevatedButton(
                          // PLAY BUTTON
                          onPressed: () => setState(() {
                            if (isEnded) {
                              stopSnooze();
                            } else {
                              MyApp.timer.playPause();
                            }
                          }),
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  MyApp.thememe[MyApp.currentTheme]
                                      ['primary']!),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(0)),
                              shape: MaterialStateProperty.all(
                                  const CircleBorder())),
                          child: Icon(
                              isEnded
                                  ? Icons.volume_off_outlined
                                  : MyApp.timer.isPaused()
                                      ? Icons.play_arrow_rounded
                                      : Icons.pause_rounded,
                              size: 50),
                        ),
                      )),
                  Align(
                      alignment: const Alignment(-0.44, 0.675),
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child: ElevatedButton(
                              // RESTART BUTTON
                              onPressed: () => setState(() {
                                    MyApp.timer.reset();
                                  }),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          MyApp.thememe[MyApp.currentTheme]
                                              ['secondary']!),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(0)),
                                  shape: MaterialStateProperty.all(
                                      const CircleBorder())),
                              child:
                                  const Icon(Icons.replay_rounded, size: 30)))),
                  Align(
                      alignment: const Alignment(0.8, 0.9),
                      child: SizedBox(
                          width: 60,
                          height: 60,
                          child: ElevatedButton(
                              // EDIT BUTTON
                              onPressed: () => setState(() {
                                    MyApp.timer.reset();
                                    MyApp.hours = MyApp.initialTime ~/ 3600;
                                    MyApp.initialTime %= 3600;
                                    MyApp.minutes = MyApp.initialTime ~/ 60;
                                    MyApp.initialTime %= 60;
                                    MyApp.seconds = MyApp.initialTime;
                                    showTimeSelector = true;
                                  }),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          MyApp.thememe[MyApp.currentTheme]
                                              ['primary']!),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(0)),
                                  shape: MaterialStateProperty.all(
                                      const CircleBorder())),
                              child:
                                  const Icon(Icons.edit_rounded, size: 25)))),
                ],
        ));
  }
}
