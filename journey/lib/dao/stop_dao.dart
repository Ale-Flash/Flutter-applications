import 'package:journey/entity/stop.dart';
import 'package:floor/floor.dart';


@dao
abstract class PersonDao {
  @Query('SELECT * FROM Stop')
  Future<List<Stop>> findAllStops();

  @Query('SELECT * FROM Stop WHERE id=:id')
  Stream<Stop?> findPersonById(int id);

  @insert
  Future<void> insertPerson(Stop stop);

  @Query('DELETE FROM Stop')
  Future<void> deleteAllPersons();
}

