import 'package:flutter/material.dart';
import 'model.dart';

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
    required this.onTodoDelete,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final void Function() onTodoChanged;
  final void Function() onTodoDelete;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black45,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChanged();
      },
      onLongPress: onTodoDelete,
      leading: CircleAvatar(child: Text(todo.name[0])),
      title: Text(todo.name, style: _getTextStyle(todo.checked)),
    );
  }
}
