// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'dart:convert';
import 'package:chatroom/client.dart';
import 'package:chatroom/structures.dart';

Stream<String> readLine() =>
    stdin.transform(utf8.decoder).transform(const LineSplitter());

Future<bool> signin(String id, String password) async {
  if (!await Client.existIDUser(id, url)) {
    print('id never used');
    return false;
  }
  User? u = await Client.getUser(id, password, url);
  if (u == null) {
    return false;
  }
  c = Client(u, url);
  return true;
}

Future<bool> signup(
    String id, String name, String surname, String password) async {
  if (await Client.existIDUser(id, url)) {
    print('id already taken');
    return false;
  }
  User u = User(id, name, surname, password);
  if (!await Client.createUser(u, url)) {
    return false;
  }
  c = Client(u, url);
  return true;
}

Future<bool> createGroup(int id, String name) async {
  return await c!.createGroup(Group(id, name));
}

String getLine() {
  String? line = stdin.readLineSync(encoding: utf8);

  if (line == null) return '';
  return line.trim();
}

void sendMessages() {
  readLine().listen(((line) {
    if (line == '/exit') {
      exit(0);
    } else if (c != null) {
      if (line.isEmpty) return;
      c!.send(line);
    }
  }));
}

void menu() {
  String line;
  int? value;
  do {
    print('press:\n\t0 to quit\n\t1 to list all the chats\n\t2 select a group');
    line = getLine();
    value = int.tryParse(line);
    if (value == null) continue;
    switch (value) {
      case 0:
        exit(0);
      case 1:
        c!.requestChats();
        break;
    }
  } while (true);
}

late String url;
Client? c;

void main() async {
  // do {
  //   print('enter url server:');
  //   url = getLine();
  // } while (url.isEmpty);

  url = "localhost:8008";

  // login user
  String line;
  do {
    print('press 1 to login, 2 to signup');
    line = getLine();
  } while (line != '1' && line != '2');
  if (line == '1') {
    String id, password;
    do {
      print('insert id:');
      id = getLine();
      print('insert password:');
      password = getLine();
      if (id.isEmpty || password.isEmpty) continue;
    } while (!await signin(id, password));
  } else {
    String id, name, surname, password;
    do {
      print('insert id:');
      id = getLine();
      print('insert name:');
      name = getLine();
      print('insert surname:');
      surname = getLine();
      print('insert password:');
      password = getLine();
      if (id.isEmpty || name.isEmpty || surname.isEmpty || password.isEmpty) {
        continue;
      }
    } while (!await signup(id, name, surname, password));
  }
  await Future.delayed(const Duration(seconds: 1));
  // join/create group
  late Group g;
  do {
    print('press 1 to join group, 2 to create group');
    line = getLine();
  } while (line != '1' && line != '2');
  if (line == '1') {
    String id;
    do {
      print('insert id of group:');
      id = getLine();
    } while (int.tryParse(id) == null || !await c!.joinGroup(int.parse(id)));
    g = Group(int.parse(id), '');
    c!.selectGroup(g);
  } else {
    String id, name;
    do {
      print('insert id of group:');
      id = getLine();
      print('insert name of group:');
      name = getLine();
    } while (int.tryParse(id) == null ||
        name.isEmpty ||
        !await createGroup(int.parse(id), name));
    g = Group(int.parse(id), name);
    c!.selectGroup(g);
  }
  print('start typing');
  c!.receive(
      (msg) => print('${msg.user}\t${msg.time}\n${msg.text}'),
      (groups) => groups.forEach((g) => print('${g.id} - ${g.name}')),
      (messages) => messages
          .forEach((msg) => print('${msg.user}\t${msg.time}\n${msg.text}')));

  sendMessages();
}
