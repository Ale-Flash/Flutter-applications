import 'package:floor/floor.dart';

import 'model.dart';

@dao
abstract class TodoDao {
  @Query('SELECT * FROM Todo')
  Future<List<Todo>> getTodos();

  @Query('SELECT * FROM Todo WHERE id = :id')
  Future<Todo?> findTodoById(int id);

  @insert
  Future<void> insertTodo(Todo item);

  @insert
  Future<void> insertTodos(List<Todo> items);

  @update
  Future<void> updateTodo(Todo item);

  @update
  Future<void> updateTodos(List<Todo> items);

  @delete
  Future<void> deleteTodo(Todo items);

  @delete
  Future<void> deleteTodos(List<Todo> itemss);
}

