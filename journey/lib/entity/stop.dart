import 'package:floor/floor.dart';

@entity
class Stop {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final String name, info;
  final double lat, lang;
  final DateTime datetime;
  Stop(this.id, this.name, this.info, this.lat, this.lang, this.datetime);
}
