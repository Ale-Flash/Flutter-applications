# memo

## Provider Riverpod

andiamo a creare il nostro provider

```dart
final todoListProvider = StateNotifierProvider<TodoListController, List<Todo>>((ref) => TodoListController());
```

definendo prima il controller:

```dart
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
```

con le sue tre funzioni:
- `addTodo`: per aggiungere un todo, viene utilizzata l'espansione dell'array con i 3 puntini (`...state`)
- `removeTodo`: per rimuovere un todo, viene fatto un `for` e semplicemente ometto il valore che è uguale a quello dato come parametro alla funzione
- `toggle`: per segnare come letto/da leggere, viene utilizzata la nuova funzione aggiunta nella classe del `Todo`

## model

La classe 
```dart
class Todo {
  Todo({required this.name, required this.checked});
  final String name;
  bool checked;
  Todo toggle() {
    checked = !checked;
    return this;
  }
}
```
definisce il *model* per gli *item*.

è stata aggiunta la funzione `toggle` per utilizzarla nella classe `TodoListController`

```dart
class TodoListController extends StateNotifier<List<Todo>> {
  ...
  void toggle(Todo todo) {
    state = [
      for (Todo t in state)
        if (t == todo) t.toggle() else t
    ];
  }
}
```

## main

la lista di todos rimane la stessa

```dart
List<Todo> todos = [];
```

in cui però viene inizializzata nel build:

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
    ...
    body: Consumer(
      builder: (context, watch, child) {
        todos = ref.watch(todoListProvider);
        return ListView.builder(...);
      },
    ),
    ...
  );
}
```