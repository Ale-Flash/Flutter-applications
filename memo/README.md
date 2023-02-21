# memo

## Provider

andiamo ad aggiungere la classe `ChangeNotifierProvider` nella home della `MyApp`

```dart
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
```

andiamo quindi a creare la classe del tracker:

```dart
class TodosTracker extends ChangeNotifier {
  List<Todo> todos = [];

  void update() {
    notifyListeners();
  }
}
```

quando viene chiamata la funzione `update` verranno notificati tutti i listeners, in poche parole la pagina viene aggiornata, al posto del precedente `setState` ora viene utilizzata questa funzione.

andiamo a creare il nostro provider

```dart
late TodosTracker todosTracker;
```

in cui viene definito nel `build`, quando viene passato il parametro `BuildContext` **context**, quindi:

```dart
...
@override
Widget build(BuildContext context) {
  todosTracker = Provider.of(context);
  return Scaffold(...);
}
...
```

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