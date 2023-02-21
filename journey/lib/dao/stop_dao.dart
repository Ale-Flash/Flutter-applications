import 'package:journey/entity/stop.dart';
import 'package:floor/floor.dart';

@dao
abstract class StopDao {
  @Query('SELECT * FROM Stop')
  Future<List<Stop>> findAllStops();

  @Query('SELECT * FROM Stop WHERE id=:id')
  Future<Stop?> findStopById(int id);

  @Query('SELECT * FROM Stop WHERE name=:name')
  Stream<Stop?> findStopByName(String name);

  @insert
  Future<int> insertStop(Stop stop);

  @Query('DELETE FROM Stop')
  Future<void> deleteAllStops();
}
