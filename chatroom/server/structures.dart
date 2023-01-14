class User {
  final String id, name, surname, password;
  const User(this.id, this.name, this.surname, this.password);
  static bool inLimits(User user) {
    return user.id.length <= 16 &&
        user.name.length <= 32 &&
        user.surname.length <= 32 &&
        user.password.length <= 128;
  }
}

class Message {
  final String user;
  final int group;
  final String time;
  final String text;
  const Message(this.user, this.group, this.time, this.text);
  static Message convert(Map<String, dynamic> map) {
    return Message(map['user'], map['group'], map['time'], map['text']);
  }

  static bool inLimits(Message message) {
    return message.user.length <= 16 && message.text.length <= 128;
  }

  @override
  String toString() {
    return '{"user":"$user","group":$group,"time":"$time","text":"$text"}';
  }
}

class Group {
  final int id;
  final String name;
  const Group(this.id, this.name);
  @override
  String toString() {
    return '{"id":$id,"name":"$name"}';
  }

  static Group convert(Map<String, dynamic> map) {
    return Group(map['id'], map['name']);
  }
}

class Partecipant {
  final String user;
  final int group;
  const Partecipant(this.user, this.group);
  @override
  String toString() {
    return '{"user":"$user","group":$group}';
  }
}