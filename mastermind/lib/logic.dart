import 'dart:math';

class Game {
  int colorsAvailable = 8;
  int colorNumber = 4;
  int rows = 10;
  bool win = false;
  bool end = false;
  List<int> correctSequence = [];
  int nGuesses = 0;
  List<List<int>> guesses = [];
  List<int> guess = [];
  int index = 0;
  bool allowRepetition = false;
  Game(
      {this.colorNumber = 4,
      this.rows = 10,
      this.colorsAvailable = 8,
      this.allowRepetition = false});
  int completed = 0;

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
    index = 0;
    completed = 0;
    guess = List.filled(colorNumber, 0);
  }

  void setColor(int c, int i) {
    if (guess[i] == 0) ++completed;
    guess[i] = c;
  }

  bool isCompleted() {
    return completed == colorNumber;
  }

  bool isValid(List<int> guess) {
    for (int num in guess) {
      if (num == 0 || num > colorsAvailable) return false;
    }
    return true;
  }

  List<int> check(List<int> guess) {
    if (!isValid(guess)) {
      return List.empty();
    }

    if (end || nGuesses >= rows) {
      end = true;
      return List.empty();
    }

    guesses[nGuesses++] = guess;
    int correct = 0;
    int correctPlace = 0;
    Set<int> checked = correctSequence.toSet();
    for (int i = 0; i < guess.length; ++i) {
      if (guess[i] == correctSequence[i]) {
        ++correctPlace;
        checked.remove(guess[i]);
      }
    }
    for (int c in guess) {
      if (checked.contains(c)) {
        ++correct;
        checked.remove(c);
      }
    }
    if (correctPlace == colorNumber) {
      win = true;
      end = true;
    }
    if (nGuesses >= rows) {
      end = true;
    }
    return [correctPlace, correct, colorNumber - correctPlace - correct];
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
