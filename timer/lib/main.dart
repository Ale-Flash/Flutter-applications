import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:slidable_button/slidable_button.dart';
import 'logic.dart';
import 'noti.dart';
import 'settings.dart';
import 'widgets/time_selector.dart';
import 'widgets/timer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const List<Map<String, Color>> thememe = [
    {
      'primary': Color(0xFF6200EE),
      'background': Color(0xFF121212),
      'secondary': Color(0xFF424242),
      'text': Color(0xFFC5C5C5),
      'content': Color(0x89000000),
      'selected': Color(0xFFD3D3D3),
      'disabled': Color(0xFF424242)
    },
    {
      'primary': Color(0xFF005FEE),
      'background': Color(0xFFFFFFFF),
      'secondary': Color(0xFF666666),
      'text': Color(0xFF131313),
      'content': Color(0xE80F0F0F),
      'selected': Color(0xFF131313),
      'disabled': Color(0xFF666666)
    },
  ];
  static int currentTheme = 0;
  static int hours = 0, minutes = 5, seconds = 0;
  static int initialTime = 0, currentTime = 0;
  static late MyTimer timer;
  static bool jump = true;
  static int format = 0;
  const MyApp({super.key});
  static final MyHomePage _hp = MyHomePage(title: 'Timer');
  static void refresh() {
    _hp.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer',
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => _hp,
        '/settings': (BuildContext context) => Settings(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});
  final String title;
  void refresh() {
    mhps.refresh();
  }

  final _MyHomePageState mhps = _MyHomePageState();
  @override
  State<MyHomePage> createState() => mhps;
}

final FlutterLocalNotificationsPlugin flnp = FlutterLocalNotificationsPlugin();

class _MyHomePageState extends State<MyHomePage> {
  void refresh() {
    setState(() {});
  }

  Stream blinkEvent =
      Stream.periodic(const Duration(milliseconds: 333), (tick) => tick);
  late StreamSubscription blink;
  _MyHomePageState() {
    Noti.initialize(flnp);
    MyApp.timer = MyTimer(update);
    blink = blinkEvent.listen((tick) {
      if (tick % 3 == 0) {
        MyApp.currentTime = MyApp.initialTime;
        setState(() {});
      } else if (tick % 3 == 2) {
        MyApp.currentTime = 0;
        setState(() {});
      }
    });
    blink.pause();
  }
  void update(int time) => setState(() {
        if (time != MyApp.initialTime) {
          MyApp.jump = false;
        }
        if (time == 0) snooze();
        MyApp.currentTime = time;
        MyApp.hours = time ~/ 3600;
        time %= 3600;
        MyApp.minutes = time ~/ 60;
        time %= 60;
        MyApp.seconds = time;
      });

  bool showTimeSelector = true;

  void updateTime() {
    MyApp.initialTime = MyApp.hours * 3600 + MyApp.minutes * 60 + MyApp.seconds;
    MyApp.currentTime = MyApp.initialTime;
    MyApp.timer.setTime(MyApp.initialTime);
  }

  bool isEnded = false;
  void snooze() {
    Noti.showBigTextNotification(
        title: 'Timer', body: 'Your timer has ended', fln: flnp);
    Future.delayed(const Duration(seconds: 1), () {
      MyApp.jump = true;
      blink.resume();
    });
    isEnded = true;
    setState(() {});
    FlutterRingtonePlayer.playAlarm();
  }

  void stopSnooze() {
    isEnded = false;
    FlutterRingtonePlayer.stop();
    blink.pause();
    MyApp.timer.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyApp.thememe[MyApp.currentTheme]['primary'],
          title: Text(widget.title),
          actions: [
            // REFRESH BUTTON ON TOP RIGHT
            GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/settings'),
                child: const SizedBox(
                    width: 60,
                    height: 60,
                    child: Icon(Icons.settings, color: Colors.white)))
          ],
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
                  MyApp.format == 0 ? Clock() : DigitalClock(),
                  Align(
                      alignment: const Alignment(0, 0.7),
                      child: SizedBox(
                        width: 70,
                        height: isEnded ? 150 : 70,
                        child: (isEnded
                            ? VerticalSlidableButton(
                                initialPosition: SlidableButtonPosition.end,
                                buttonHeight: 70,
                                width: 70,
                                height: 150,
                                onChanged: (state) => setState(() {
                                  if (state == SlidableButtonPosition.start) {
                                    stopSnooze();
                                  }
                                }),
                                color: MyApp.thememe[MyApp.currentTheme]
                                    ['content'],
                                buttonColor: MyApp.thememe[MyApp.currentTheme]
                                    ['primary'],
                                label: Icon(Icons.volume_off_outlined,
                                    size: 50,
                                    color: MyApp.thememe[MyApp.currentTheme]
                                        ['text']),
                              )
                            : ElevatedButton(
                                // PLAY BUTTON
                                onPressed: () => setState(() {
                                  if (isEnded) {
                                    stopSnooze();
                                  } else {
                                    MyApp.timer.playPause();
                                  }
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
                                child: Icon(
                                    isEnded
                                        ? Icons.volume_off_outlined
                                        : MyApp.timer.isPaused()
                                            ? Icons.play_arrow_rounded
                                            : Icons.pause_rounded,
                                    size: 50),
                              )),
                      )),
                  Align(
                      alignment: const Alignment(-0.44, 0.675),
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child: ElevatedButton(
                              // RESTART BUTTON
                              onPressed: () => setState(() {
                                    if (isEnded) stopSnooze();
                                    MyApp.timer.reset();
                                    MyApp.jump = true;
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
                                    if (isEnded) stopSnooze();
                                    MyApp.timer.reset();
                                    MyApp.jump = true;
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
