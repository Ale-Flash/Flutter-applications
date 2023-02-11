import 'package:journey/entity/stop.dart';

class Trip {
  List<Stop> stops = [];
  final String name;
  Trip(this.name);
  void addStop(Stop stop) {
    stops.add(stop);
  }
}
