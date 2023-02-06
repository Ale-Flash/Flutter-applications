import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model.dart';
import 'widgets.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'am032 todo list',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: TodoListPage(),
    );
  }
}

final todoListProvider = StateNotifierProvider<TodoListController, List<Todo>>(
    (ref) => TodoListController());

class TodoListController extends StateNotifier<List<Todo>> {
  TodoListController() : super([]);

  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  void removeTodo(Todo todo) {
    state = [
      for (final t in state)
        if (t != todo) t
    ];
  }

  void toggle(Todo todo) {
    state = [
      for (Todo t in state)
        if (t == todo) t.toggle() else t
    ];
  }
}

class TodoListPage extends ConsumerWidget {
  TodoListPage({Key? key}) : super(key: key);

  final TextEditingController _textFieldController = TextEditingController();

  List<Todo> todos = [];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          todos = ref.watch(todoListProvider);
          return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return TodoItem(
                  todo: todos[index],
                  onTodoChanged: () {
                    ref.read(todoListProvider.notifier).toggle(todos[index]);
                  },
                  onTodoDelete: () {
                    ref
                        .read(todoListProvider.notifier)
                        .removeTodo(todos[index]);
                  },
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text('add todo item'),
                    content: TextField(
                      controller: _textFieldController,
                      decoration:
                          const InputDecoration(hintText: 'type here ...'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Add'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          ref.read(todoListProvider.notifier).addTodo(Todo(
                              name: _textFieldController.text, checked: false));
                        },
                      ),
                    ],
                  ));
          _textFieldController.clear();
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
