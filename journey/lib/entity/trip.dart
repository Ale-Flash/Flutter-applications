import 'package:floor/floor.dart';

@entity
class Trip {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final String name;
  Trip(this.id, this.name);
}
