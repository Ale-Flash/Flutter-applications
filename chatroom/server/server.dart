// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls
import 'dart:convert';
import 'dart:io';
import './database.dart';
import 'package:chatroom/structures.dart';

class Server {
  late DataBase _db;
  Future<bool> _connectToDatabase() async {
    print('Connecting database');
    try {
      _db = await DataBase.connect();
    } catch (e) {
      print('DataBase not connected');
      return false;
    }
    return true;
  }

  Future<bool> _sendMessage(Message msg) {
    return _db.addMessage(msg);
  }

  Future<void> connect(int port) async {
    print('connecting server');
    if (!await _connectToDatabase()) return;
    HttpServer server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    // HttpServer server = await HttpServer.bind('192.168.1.55', port);
    print("HttpServer listening...");
    // server.serverHeader = "an echo server";
    server.listen((HttpRequest request) {
      // Checks whether the request is a valid WebSocket upgrade request
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        print("requested upgrade request");
        WebSocketTransformer.upgrade(request).then(_handleWebSocket);
      } else {
        print("${request.method}: ${request.uri.path}");
        serveRequest(request);
      }
    });
  }

  Map<int, List<WebSocket>> rooms = {};
  void _handleWebSocket(WebSocket socket) {
    print('Client connected!');
    User? u;
    Group? g;
    socket.add('{"info":"give me the user"}');
    socket.listen((data) async {
      String msg = data.toString();
      Map map;
      try {
        map = json.decode(msg);
      } catch (e) {
        return;
      }
      if (u == null) {
        // if user is not auth
        if (map['user'] == null ||
            map['user']['id'] == null ||
            map['user']['password'] == null ||
            map['user']['id'] is! String ||
            map['user']['password'] is! String) {
          socket.add('{"info":"give me the user"}');
          return;
        }
        u = await _db.getUser(map['user']['id'], map['user']['password']);

        if (u == null) {
          socket.add('{"info":"give me the user"}');
          return;
        }
      }
      if (map['chats'] != null) {
        // get all the groups of user
        List<String> res = [];
        var r = await _db.getGroups(u!.id);
        for (Group g in r) {
          res.add(g.toString());
        }
        socket.add('{"chats": ${json.encode(res)}}');
      } else if (map['messages'] != null) {
        // get first 20 messages of group
        if (g == null) {
          socket.add('{"info": "need group"}');
          return;
        }
        var obj = map['messages'];
        if (obj['start'] == null || obj['start'] is! int) return;
        List<String> res = [];
        var r = await _db.getMessages(g!.id, obj['start']);
        for (Message m in r) {
          res.add(m.toString());
        }
        socket.add(json.encode({"msg": res}));
      } else if (map['group'] != null) {
        // select group
        var obj = map['group'];
        if (obj == null || obj is! int) return;
        if (!await _db.containsUser(u!.id, obj)) return;
        if (g != null && rooms[g!.id]!.isNotEmpty) {
          rooms[g!.id]!.remove(socket);
        }
        g = await _db.getGroup(obj);
        if (g == null) return;
        if (rooms[g!.id] == null) {
          rooms[g!.id] = [];
        }
        rooms[g!.id]!.add(socket);
      } else if (map['txt'] != null) {
        if (g == null) {
          socket.add('{"info": "need group"}');
          return;
        }
        var obj = map['txt'];
        if (obj['text'] == null || obj['text'] is! String) return;
        Message m = Message(u!.id, g!.id,
            DateTime.now().toString().substring(0, 19), obj['text']);
        _sendMessage(m);
        // notify all users FIXME
        rooms[g!.id]!.forEach((WebSocket s) {
          // if (s == socket) return;
          s.add('{"txt":${m.toString()}}');
        });
      } else if (map['lasttxt'] != null) {
        var obj = map['lasttxt'];
        if (obj is! int) return;
        Message m = await _db.getLastMessage(obj);
        socket.add(json.encode({
          "msg": [m.toString()]
        }));
      }
    }, onDone: () {
      if (g != null && rooms[g!.id]!.isNotEmpty) {
        rooms[g!.id]!.remove(socket);
      }
      print('Client disconnected');
    });
  }

  // (curl http://localhost:8008/user -Method POST -Body '{"id":"mario","name":"Mario","surname":"Luigi","password":"uhn"}').Content
  Future<void> _addUser(HttpRequest request) async {
    String body = await utf8.decoder.bind(request).join();
    Map<String, dynamic> data;
    try {
      data = json.decode(body);
    } catch (e) {
      request.response.write('error parsing the request');
      request.response.close();
      return;
    }
    if (data['id'] == null ||
        data['name'] == null ||
        data['surname'] == null ||
        data['password'] == null ||
        data['id'] is! String ||
        data['name'] is! String ||
        data['surname'] is! String ||
        data['password'] is! String) {
      request.response.write('missing parameters');
      request.response.close();
      return;
    }
    User user =
        User(data['id'], data['name'], data['surname'], data['password']);
    bool result = await _db.addUser(user);
    request.response.write(result ? 'true' : 'id might be already taken');
    request.response.close();
  }

  // (curl http://localhost:8008/group -Method POST -Body '{"id":165,"name":"Gruppone"}').Content
  Future<void> _addGroup(HttpRequest request) async {
    String body = await utf8.decoder.bind(request).join();
    Map<String, dynamic> data;
    try {
      data = json.decode(body);
    } catch (e) {
      request.response.write('error parsing the request');
      request.response.close();
      return;
    }
    if (data['id'] == null ||
        data['name'] == null ||
        data['id'] is! int ||
        data['name'] is! String) {
      request.response.write('missing parameters');
      request.response.close();
      return;
    }
    Group group = Group(data['id'], data['name']);
    bool result = await _db.addGroup(group);
    request.response.write(result ? 'true' : 'id might be already taken');
    request.response.close();
  }

  // (curl "http://localhost:8008/id?id=mario").Content
  Future<void> _checkID(HttpRequest request) async {
    String? id = request.uri.queryParameters['id'];
    if (id == null) {
      request.response.write('missing parameter');
      request.response.close();
      return;
    }
    bool result = await _db.existID(id);
    request.response.write(result.toString());
    request.response.close();
  }

  Future<void> _checkGroup(HttpRequest request) async {
    String? id = request.uri.queryParameters['id'];
    if (id == null || int.tryParse(id) == null) {
      request.response.write('missing parameter');
      request.response.close();
      return;
    }
    bool result = await _db.existGroup(int.parse(id));
    request.response.write(result.toString());
    request.response.close();
  }

  // (curl http://localhost:8008/join -Method POST -Body '{"user":"mario","group":123}').Content
  Future<void> _joinGroup(HttpRequest request) async {
    String body = await utf8.decoder.bind(request).join();
    Map<String, dynamic> data;
    try {
      data = json.decode(body);
    } catch (e) {
      request.response.write('error parsing the request');
      request.response.close();
      return;
    }
    if (data['user'] == null ||
        data['group'] == null ||
        data['user'] is! String ||
        data['group'] is! int) {
      request.response.write('missing parameters');
      request.response.close();
      return;
    }
    bool result = await _db.addUserToGroup(data['user'], data['group']);
    request.response.write(result ? 'true' : 'id might be already taken');
    request.response.close();
    return;
  }

  Future<void> _getGroups(HttpRequest request) async {
    String body = await utf8.decoder.bind(request).join();
    Map<String, dynamic> data;
    try {
      data = json.decode(body);
    } catch (e) {
      request.response.write('null');
      request.response.close();
      return;
    }
    if (data['name'] == null || data['name'] is! String) {
      request.response.write('null');
      request.response.close();
      return;
    }
    List<Group> groups = await _db.getAvailableGroups(data['name']);
    if (groups.isEmpty) {
      request.response.write('null');
      request.response.close();
      return;
    }
    List<String> result = groups.map((e) => e.toString()).toList();
    request.response.write(json.encode({"groups": result}));
    request.response.close();
    return;
  }

  Future<void> _getGroupByID(HttpRequest request) async {
    String body = await utf8.decoder.bind(request).join();
    Map<String, dynamic> data;
    try {
      data = json.decode(body);
    } catch (e) {
      request.response.write('null');
      request.response.close();
      return;
    }
    if (data['id'] == null || data['id'] is! int) {
      request.response.write('null');
      request.response.close();
      return;
    }
    Group? group = await _db.getGroup(data['id']);
    if (group == null) {
      request.response.write('null');
      request.response.close();
      return;
    }
    request.response.write(json.encode({"group": group.toString()}));
    request.response.close();
    return;
  }

  Future<void> _getUser(HttpRequest request) async {
    String body = await utf8.decoder.bind(request).join();
    Map<String, dynamic> data;
    try {
      data = json.decode(body);
    } catch (e) {
      request.response.write('null');
      request.response.close();
      return;
    }
    if (data['id'] == null ||
        data['password'] == null ||
        data['id'] is! String ||
        data['password'] is! String) {
      request.response.write('null');
      request.response.close();
      return;
    }
    User? result = await _db.getUser(data['id'], data['password']);
    request.response.write(result == null
        ? 'null'
        : '${result.id}\n${result.name}\n${result.surname}');
    request.response.close();
    return;
  }

  Future<void> _getStatus(HttpRequest request) async {
    request.response.write('online');
    request.response.close();
  }

  Future<void> serveRequest(HttpRequest request) async {
    if (request.method == 'POST') {
      switch (request.uri.path) {
        case '/user':
          return _addUser(request);
        case '/group':
          return _addGroup(request);
        case '/join':
          return _joinGroup(request);
        case '/getUser':
          return _getUser(request);
        case '/getGroups':
          return _getGroups(request);
        case '/getGroupID':
          return _getGroupByID(request);
      }
    } else if (request.method == 'GET') {
      switch (request.uri.path) {
        case '/id':
          return _checkID(request);
        case '/idgroup':
          return _checkGroup(request);
        case '/status':
          return _getStatus(request);
      }
    }
    request.response.statusCode = HttpStatus.forbidden;
    request.response.close();
  }
}

/*
populate:
for ($i=0; $i -le 10; $i++) {
  $user="user$i"
  $name="Name$i"
  $surname="Surname$i"
  $password=-join ((65..90) + (97..122) | Get-Random -Count 8 | % {[char]$_})
  (curl http://localhost:8008/user -Method POST -Body "{`"id`":`"$user`",`"name`":`"$name`",`"surname`":`"$surname`",`"password`":`"$password`"}").Content
}
*/

void main() async {
  Server server = Server();
  await server.connect(8008);
}
