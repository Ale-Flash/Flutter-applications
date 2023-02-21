import 'package:floor/floor.dart';

@entity
class Todo {
  @primaryKey
  final int? id;
  final String name;
  bool checked;

  Todo({required this.id, required this.name, this.checked = false});
}
