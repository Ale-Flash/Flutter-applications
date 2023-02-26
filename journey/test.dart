void main() {
  String string = 'Francia';
  int value = string.hashCode;
  int r = 0, g = 0, b = 0;
  print(value);
  switch (value % 3) {
    case 0:
      g = value % 1000 % 256;
      b = value ~/ 10000 % 1000 % 256;
      break;
    case 1:
      r = value ~/ 10000 % 1000 % 256;
      b = value % 1000 % 256;
      break;
    case 2:
      r = value % 1000 % 256;
      g = value ~/ 10000 % 1000 % 256;
      break;
  }
}
