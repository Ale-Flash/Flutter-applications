import 'dart:async';
import 'package:http/http.dart';
import 'package:chatroom/structures.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class Client {
  late User _user;
  WebSocketChannel? _channel;
  Group? _group;
  late String _url;
  Client(User user, String url) {
    _channel = IOWebSocketChannel.connect(Uri.parse('ws://$url'));
    _url = url;
    _user = user;
    _channel!.sink.add(json.encode({
      "user": {"id": _user.id, "password": _user.password}
    }));
  }

  static Future<bool> checkServer(String url) async {
    Response r = await get(Uri.parse('http://$url/status'));
    return r.body == 'online';
  }

  void send(String text) {
    if (_group == null) {
      return;
    }
    _channel!.sink.add(json.encode({
      "txt": {'text': text}
    }));
  }

  Future<bool> existID(String id) async {
    Response r = await get(Uri.parse('http://$_url/id?id=$id'));
    return r.body == 'true';
  }

  Future<bool> existGroup(int id) async {
    Response r = await get(Uri.parse('http://$_url/group?idgroup=$id'));
    return r.body == 'true';
  }

  Future<Group?> getGroup(int id) async {
    Response r = await post(Uri.parse('http://$_url/getGroupID'),
        headers: _headers, body: json.encode(<String, int>{'id': id}));
    if (r.body == 'null') {
      return null;
    }
    Map map;
    try {
      map = json.decode(r.body);
    } catch (e) {
      return null;
    }
    if (map['group'] == null) return null;
    return Group.convert(json.decode(map['group']));
  }

  void requestChats() {
    _channel!.sink.add('{"chats":true}');
  }

  void getLastMessage(int group) {
    _channel!.sink.add('{"lasttxt":$group}');
  }

  static Future<bool> existIDUser(String id, String url) async {
    Response r = await get(Uri.parse('http://$url/id?id=$id'));
    return r.body == 'true';
  }

  static Future<User?> getUser(String id, String password, String url) async {
    Response r = await post(Uri.parse('http://$url/getUser'),
        headers: _headers,
        body: json.encode(<String, String>{'id': id, 'password': password}));
    if (r.body == 'null') {
      return null;
    }
    List<String> values = r.body.split('\n');
    return User(values[0], values[1], values[2], password);
  }

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static Future<bool> createUser(User user, String url) async {
    Response r = await post(Uri.parse('http://$url/user'),
        headers: _headers,
        body: json.encode(<String, String>{
          'id': user.id,
          'name': user.name,
          'surname': user.surname,
          'password': user.password
        }));
    return r.body == 'true';
  }

  Future<bool> joinGroup(int group) async {
    Response r = await post(Uri.parse('http://$_url/join'),
        headers: _headers,
        body: json.encode(<String, dynamic>{'user': _user.id, 'group': group}));
    return r.body == 'true';
  }

  Future<bool> createGroup(Group group) async {
    Response r = await post(Uri.parse('http://$_url/group'),
        headers: _headers,
        body:
            json.encode(<String, dynamic>{'id': group.id, 'name': group.name}));
    await joinGroup(group.id);
    return r.body == 'true';
  }

  Future<List<Group>> getGroups(String name) async {
    Response r = await post(Uri.parse('http://$_url/getGroups'),
        headers: _headers, body: json.encode({'name': name}));
    Map map;
    try {
      map = json.decode(r.body);
    } catch (e) {
      return [];
    }
    if (map['groups'] == null || map['groups'] is! List) {
      return const [Group(-1, '')];
    }
    List<Group> res = [];
    for (String s in map['groups']) {
      res.add(Group.convert(json.decode(s)));
    }
    return res;
  }

  void requestMessages([int start = 0]) {
    _channel!.sink.add('{"messages": {"start":$start}}');
  }

  void selectGroup(Group g) {
    _group = g;
    _channel!.sink.add('{"group":${g.id}}');
  }

  void receive2(StreamController onMessage, StreamController onChats,
      StreamController onMessages) {
    _channel!.stream.listen((text) {
      Map map;
      try {
        map = json.decode(text);
      } catch (e) {
        print(e);
        return;
      }
      if (map['txt'] != null) {
        // new message
        if (_group != null && map['txt']['group'] != _group!.id) return;
        onMessage.add(Message.convert(map['txt']));
      } else if (map['chats'] != null) {
        List<Group> res = [];
        for (int i = 0; i < map['chats'].length; ++i) {
          res.add(Group.convert(json.decode(map['chats'][i])));
        }
        onChats.add(res);
      } else if (map['msg'] != null) {
        List<Message> res = [];
        for (int i = 0; i < map['msg'].length; ++i) {
          res.add(Message.convert(json.decode(map['msg'][i])));
        }
        onMessages.add(res);
      } else if (map['info'] != null) {
        if (map['info'] == 'need user') {
          _channel!.sink.add(json.encode({
            "user": {"id": _user.id, "password": _user.password}
          }));
        } else if (map['info'] == 'need group') {
          _channel!.sink.add('{"group":${_group!.id}}');
        }
      }
    });
  }

  void receive(Function(Message) onMessage, Function(List<Group>) onChats,
      Function(List<Message>) onMessages) {
    _channel!.stream.listen((text) {
      Map map;
      try {
        map = json.decode(text);
      } catch (e) {
        print(e);
        return;
      }
      if (map['txt'] != null) {
        // new message
        if (_group != null && map['txt']['group'] != _group!.id) return;
        onMessage(Message.convert(map['txt']));
      } else if (map['chats'] != null) {
        var res = map['chats'].map((e) => json.decode(e));
        onChats(res);
      } else if (map['msg'] != null) {
        // Dart merda
        // List<Message> res = map['msg']
        //     .map((String e) => Message.convert(json.decode(e)))
        //     .toList();
        List<Message> res = [];
        for (int i = 0; i < map['msg'].length; ++i) {
          res.add(Message.convert(json.decode(map['msg'][i])));
        }
        onMessages(res);
      } else if (map['info'] != null) {
        if (map['info'] == 'need user') {
          _channel!.sink.add(json.encode({
            "user": {"id": _user.id, "password": _user.password}
          }));
        } else if (map['info'] == 'need group') {
          _channel!.sink.add('{"group":${_group!.id}}');
        }
      }
    });
  }
}
