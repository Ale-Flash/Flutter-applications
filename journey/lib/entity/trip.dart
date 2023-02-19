import 'package:floor/floor.dart';

@entity
class Trip {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final String name;
  Trip(this.id, this.name);
  DateTime lastUpdate = DateTime.fromMillisecondsSinceEpoch(0);
  void updateLastTime() {
    lastUpdate = DateTime.now();
  }
}
