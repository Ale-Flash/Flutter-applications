import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dao.dart';
import 'database.dart';
import 'model.dart';
import 'widgets.dart';

void main() {
  runApp(const MyApp());
}

late final TodoDao _dao;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'am023 todo list floor',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: ChangeNotifierProvider<TodosTracker>(
        create: (context) => TodosTracker(),
        child: const MyHomePage(title: 'am023 todo list floor'),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TodosTracker todosTracker;

  final TextEditingController _textFieldController = TextEditingController();

  @override
  initState() {
    super.initState();
    _getDao();
  }

  Future<void> _getDao() async {
    AppDatabase database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _dao = database.todoDao;
    _updateTodos();
  }

  _updateTodos() {
    _dao.getTodos().then((todos) {
      todosTracker.todos.clear();
      todosTracker.todos.addAll(todos);
      todosTracker.update();
    });
  }

  void _handleTodoChange(Todo todo) {
    todo.checked = !todo.checked;
    todosTracker.todos.remove(todo);
    if (!todo.checked) {
      todosTracker.todos.add(todo);
    } else {
      todosTracker.todos.insert(0, todo);
    }
    todosTracker.update();
    _dao.updateTodo(todo);
  }

  void _handleTodoDelete(Todo todo) {
    todosTracker.todos.remove(todo);
    todosTracker.update();
    _dao.deleteTodo(todo);
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('add todo item'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'type here ...'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void _addTodoItem(String name) {
    Todo todo = Todo(id: null, name: name, checked: false);
    todosTracker.todos.insert(0, todo);
    todosTracker.update();
    _dao.insertTodo(todo);
    _textFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    todosTracker = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: todosTracker.todos.length,
            itemBuilder: (context, index) {
              return TodoItem(
                todo: todosTracker.todos.reversed.toList()[index],
                onTodoChanged: _handleTodoChange,
                onTodoDelete: _handleTodoDelete,
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(),
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
}

class TodosTracker extends ChangeNotifier {
  List<Todo> todos = [];

  void update() {
    notifyListeners();
  }
}
