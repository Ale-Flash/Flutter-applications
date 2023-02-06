class Todo {
  Todo({required this.name, required this.checked});
  final String name;
  bool checked;
  Todo toggle() {
    checked = !checked;
    return this;
  }
}
