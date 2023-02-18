import 'package:floor/floor.dart';

@entity
class Stop {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final String name, info;
  final double lat, lang;
  Stop(this.name, this.info, this.lat, this.lang);
}
