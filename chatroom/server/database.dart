import 'package:mysql1/mysql1.dart';
import 'package:intl/intl.dart';
import 'package:chatroom/structures.dart';

class DataBase {
  late final MySqlConnection _connection;
  DataBase(MySqlConnection connection) {
    _connection = connection;
  }
  static Future<DataBase> connect() async {
    MySqlConnection connection =
        await MySqlConnection.connect(ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: 'toor',
      db: 'chatroom',
    ));
    return DataBase(connection);
  }

  Future<bool> existID(String id) async {
    Results res =
        await _connection.query('SELECT id FROM users WHERE id=?', [id]);
    return res.isNotEmpty;
  }

  Future<User?> getUser(String id, String password) async {
    Results res = await _connection.query(
        'SELECT name, surname FROM users WHERE id=? AND password=?',
        [id, password]);
    if (res.length == 1) {
      return User(id, res.first[0], res.first[1], password);
    }
    return null;
  }

  Future<List<String>> getMembers(int group) async {
    Results res = await _connection
        .query('SELECT user FROM partecipants WHERE guild=?', [group]);
    List<String> users = [];
    for (var user in res) {
      users.add(user[0]);
    }
    return users;
  }

  Future<List<Group>> getGroups(String user) async {
    Results res = await _connection.query(
        'SELECT id, name FROM partecipants INNER JOIN groups on guild=id WHERE user=?',
        [user]);
    List<Group> groups = [];
    for (var group in res) {
      groups.add(Group(group[0], group[1]));
    }
    return groups;
  }

  Future<bool> addUser(User user) async {
    if (!User.inLimits(user)) return false;
    if (await existID(user.id)) return false;
    await _connection.query(
        'INSERT INTO users(id, name, surname, password) VALUE (?, ?, ?, ?)',
        [user.id, user.name, user.surname, user.password]);
    return true;
  }

  Future<Group?> getGroup(int group) async {
    Results res =
        await _connection.query('SELECT * FROM groups WHERE id=?', [group]);
    if (res.length != 1) return null;
    return Group(res.first[0], res.first[1]);
  }

  Future<bool> addGroup(Group group) async {
    if (await existGroup(group.id)) return false;
    await _connection.query(
        'INSERT INTO groups(id, name) VALUE (?, ?)', [group.id, group.name]);
    return true;
  }

  Future<bool> containsUser(String user, int group) async {
    Results res = await _connection.query(
        'SELECT user FROM partecipants WHERE user=? AND guild=?',
        [user, group]);
    return res.isNotEmpty;
  }

  Future<bool> existGroup(int group) async {
    Results res =
        await _connection.query('SELECT id FROM groups WHERE id=?', [group]);
    return res.isNotEmpty;
  }

  Future<List<Group>> getAvailableGroups(String name) async {
    Results res = await _connection
        .query('SELECT * FROM groups WHERE name LIKE "%$name%" LIMIT 20');
    List<Group> groups = [];
    for (var g in res) {
      groups.add(Group(g[0], g[1]));
    }
    return groups;
  }

  Future<bool> addUserToGroup(String user, int group) async {
    if (!await existID(user)) return false;
    if (!await existGroup(group)) return false;
    if (await containsUser(user, group)) return true;
    await _connection.query(
        'INSERT INTO partecipants(user, guild) VALUE (?, ?)', [user, group]);
    return true;
  }

  Future<bool> addMessage(Message message) async {
    // check if user is in the group
    if (!await containsUser(message.user, message.group)) return false;
    await _connection.query(
        'INSERT INTO messages(user, guild, timedate, txt) VALUE (?, ?, ?, ?)',
        [message.user, message.group, message.time, message.text]);
    return true;
  }

  Future<List<Message>> getMessages(int group, [int from = 0]) async {
    Results res = await _connection.query(
        'SELECT * FROM messages WHERE guild=? ORDER BY timedate DESC LIMIT ?,?',
        [group, from, from + 20]);
    List<Message> messages = List.filled(
        res.length, const Message('', -1, '1111-11-11 11:11:11', ''));
    int index = 0;
    for (var msg in res) {
      messages[index++] = Message(msg[0], msg[1],
          DateFormat('yyyy-MM-dd kk:mm:ss').format(msg[2]), msg[3]);
    }
    return messages;
  }

  Future<Message> getLastMessage(int group) async {
    Results res = await _connection.query(
        'SELECT * FROM messages WHERE guild=? ORDER BY timedate DESC LIMIT 1',
        [group]);
    if (res.isEmpty) return const Message('', -1, '1111-11-11 11:11:11', '');
    return Message(res.first[0], res.first[1],
        DateFormat('yyyy-MM-dd kk:mm:ss').format(res.first[2]), res.first[3]);
  }
}
