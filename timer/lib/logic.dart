import 'dart:async';

class MyTimer {
  late Stream<int> stream;
  late void Function(int) function;
  int time = 0;
  late StreamSubscription<int> ss;

  MyTimer(this.function);

  void create() {
    late StreamController<int> streamController;
    Timer? timer;
    int counter = time;

    void tick(_) {
      if (counter <= 0) {
        streamController.close();
        return;
      }
      streamController.add(--counter);
    }

    void resume() {
      timer = Timer.periodic(const Duration(seconds: 1), tick);
    }

    void pause() {
      if (timer == null) return;
      timer!.cancel();
      timer = null;
    }

    streamController = StreamController<int>(
      onListen: resume,
      onCancel: pause,
      onResume: resume,
      onPause: pause,
    );

    Stream<int> s = streamController.stream;
    ss = s.listen(function);
  }

  void setTime(int t) {
    time = t;
  }

  bool isPaused() {
    return ss.isPaused;
  }

  void reset() {
    ss.cancel();
    create();
    ss.pause();
    function(time);
  }

  void playPause() {
    if (ss.isPaused) {
      ss.resume();
    } else {
      ss.pause();
    }
  }
}
