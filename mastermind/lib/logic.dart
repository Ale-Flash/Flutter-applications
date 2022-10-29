import 'dart:math';

class Game {
  late int rows, colorNumber, colorsAvailable, nGuesses;
  late bool win, end, allowRepetition;
  late List<int> correctSequence;
  late List<List<int>> guesses;
  late List<List<int>> results;
  Game(
      {this.colorNumber = 4,
      this.rows = 10,
      this.colorsAvailable = 6,
      this.allowRepetition = false}) {
    start();
  }

  void start() {
    // randomize the sequence
    if (!allowRepetition) {
      correctSequence =
          List.generate(colorsAvailable, (i) => i + 1, growable: false);
      correctSequence.shuffle();
      correctSequence = correctSequence.sublist(0, colorNumber);
    } else {
      correctSequence = List.generate(
          colorNumber, (_) => Random().nextInt(colorsAvailable) + 1,
          growable: false);
    }

    // reset variables
    nGuesses = 0;
    win = false;
    end = false;
    guesses = List.generate(
        rows, (_) => List.filled(colorNumber, 0, growable: false));
    results = List.generate(
        rows, (_) => List.filled(colorNumber, -1, growable: false));
  }

  bool isValid(List<int> guess) {
    for (int num in guess) {
      if (num == 0 || num > colorsAvailable) return false;
    }
    return true;
  }

  int getRows() {
    return rows;
  }

  int getCol() {
    return colorNumber;
  }

  int getAvailableColors() {
    return colorsAvailable;
  }

  bool canAddRows(int n) {
    return (rows + n >= 6 && rows + n <= 10);
  }

  bool canAddCol(int n) {
    return (colorNumber + n >= 4 &&
        colorNumber + n <= 6 &&
        colorNumber + n <= colorsAvailable);
  }

  bool canAddColors(int n) {
    return (colorsAvailable + n >= 4 &&
        colorsAvailable + n <= 8 &&
        colorNumber <= colorsAvailable + n);
  }

  void addRowsNum(int n) {
    if (canAddRows(n)) {
      rows += n;
      start();
    }
  }

  void addColNum(int n) {
    if (canAddCol(n)) {
      colorNumber += n;
      start();
    }
  }

  void addAvailColNum(int n) {
    if (canAddColors(n)) {
      colorsAvailable += n;
      start();
    }
  }

  List<int> check(List<int> guess) {
    if (!isValid(guess)) {
      return List.empty();
    }

    if (end || nGuesses >= rows) {
      end = true;
      return List.empty();
    }

    guesses[nGuesses] = [...guess];
    int correct = 0;
    int correctPlace = 0;
    List<int> corrSeq = [...correctSequence];

    for (int i = 0; i < guess.length; ++i) {
      if (guess[i] == corrSeq[i]) {
        guess[i] = 0;
        corrSeq[i] = 0;
        ++correctPlace;
      }
    }

    for (int i = 0; i < guess.length; ++i) {
      if (guess[i] == 0) continue;
      for (int j = 0; j < corrSeq.length; ++j) {
        if (guess[i] == corrSeq[j]) {
          corrSeq[j] = 0;
          ++correct;
        }
      }
    }

    if (correctPlace == colorNumber) {
      win = true;
      end = true;
    }
    if (nGuesses + 1 >= rows) {
      end = true;
    }
    results[nGuesses] = <int>[
      correctPlace,
      correct,
      colorNumber - correctPlace - correct
    ];
    return results[nGuesses++];
  }

  List<int> showSequence() {
    return correctSequence;
  }

  bool isWin() {
    return win;
  }

  bool isEnd() {
    return end;
  }
}
