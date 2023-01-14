// ignore_for_file: no_logic_in_create_state, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'package:chatroom/chatpage.dart';
import 'package:chatroom/client.dart';
import 'package:chatroom/creategrouppage.dart';
import 'package:chatroom/structures.dart';
import 'package:chatroom/searchpage.dart';
import 'package:flutter/material.dart';

const List<String> months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

Color nameToColor(String name) {
  List<int> c = [0, 0, 0];
  for (int i = 0; i < name.length; ++i) {
    c[i % 3] += name.codeUnitAt(i);
  }
  c = c.map((e) => e % 256).toList();
  return Color.fromARGB(255, c[0], c[1], c[2]);
}

Color betterColor(Color c) {
  return (c.red * 0.3 + c.green * 0.6 + c.blue * 0.1) < 186
      ? Colors.white
      : Colors.black;
}

String formatDate(String date) {
  if (date.isEmpty || date.length != 19) return "";
  return ("${date.substring(8, 10)}/${date.substring(5, 7)}/${date.substring(2, 4)}\n  ${date.substring(11, 13)}:${date.substring(14, 16)}");
}

const TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 17);
const TextStyle textStyleBold =
    TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold);
bool asked = false;
late Client chat;

bool doneIt = false;

Group group = const Group(1, '');
List<Group> groups = [];

Map<int, int> idToIndex = {};

List<Message> lastMessages = [];
StreamController onMessage = StreamController(),
    onChats = StreamController(),
    onMessages = StreamController();

Stream ontxt = onMessage.stream.asBroadcastStream(),
    onchts = onChats.stream.asBroadcastStream(),
    ontxts = onMessages.stream.asBroadcastStream();
late String url;
late User user;

bool hasTextOverflow(String text, TextStyle style,
    {double minWidth = 0,
    double maxWidth = double.infinity,
    int maxLines = 2}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: minWidth, maxWidth: maxWidth);
  return textPainter.didExceedMaxLines;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    chat.receive2(onMessage, onChats, onMessages);
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ontxts.listen((data) {
      if (data.length == 1) {
        Message m = data[0];
        if (idToIndex[m.group] == null) return;
        lastMessages[idToIndex[m.group]!] = m;
        if (ModalRoute.of(context) != null &&
            ModalRoute.of(context)!.isCurrent) {
          setState(() {});
        }
      }
    });
    onchts.listen((data) {
      if (groups == data) return;
      groups = data;
      for (int i = 0; i < groups.length; ++i) {
        idToIndex[groups[i].id] = i;
      }
      lastMessages = List.filled(groups.length, const Message('', -1, '', ''));
      groups.forEach((g) => chat.getLastMessage(g.id));
      setState(() {});
    });
    if (!asked) {
      Future.delayed(const Duration(seconds: 1), () {
        chat.requestChats();
      });
      asked = true;
    }
    return Scaffold(
      appBar: AppBar(
          title: const Text('Chat'),
          leading: GestureDetector(
            onTap: () {
              setState(() {});
              // MENU OPENS
            },
            child: const SizedBox(
              width: 50,
              height: 50,
              child: Icon(Icons.menu_rounded),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));
                // SEARCH OPENS
              },
              child: const SizedBox(
                width: 55,
                height: 50,
                child: Icon(Icons.search_rounded),
              ),
            ),
          ]),
      body: ListView.builder(
          // ALL THE GROUPS
          itemCount: groups.length,
          itemBuilder: (_, index) => Container(
              height: 73,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: GestureDetector(
                  onTap: () async {
                    group = groups[index];
                    chat.selectGroup(group);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage()),
                    );
                  },
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(232, 230, 230, 230),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Profile image
                          Container(
                            width: MediaQuery.of(context).size.width * 0.11,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black87),
                                shape: BoxShape.circle,
                                color: nameToColor(groups[index].name)),
                            padding: const EdgeInsets.all(0),
                            child: Center(
                                child: Text(groups[index].name[0],
                                    style: TextStyle(
                                        color: betterColor(
                                            nameToColor(groups[index].name)),
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold))),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name
                                  Text(groups[index].name,
                                      style: textStyleBold),
                                  // Last message

                                  Text(lastMessages[index].text,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: textStyle)
                                ],
                              )),

                          // Last message time
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Center(
                              child: Text(
                                  lastMessages[index].time.isEmpty
                                      ? ''
                                      : formatDate(lastMessages[index].time),
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 52, 52, 52),
                                      fontSize: 15)),
                            ),
                          )
                        ],
                      ))))),
      floatingActionButton: Container(
        alignment: const Alignment(1.05, 1),
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateGroupPage()));
            },
            style: ElevatedButton.styleFrom(shape: const CircleBorder()),
            child: const SizedBox(
                width: 50, height: 50, child: Icon(Icons.add_rounded))),
      ),
    );
  }
}
