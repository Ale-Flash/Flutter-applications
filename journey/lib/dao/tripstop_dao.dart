import 'package:journey/entity/tripstops.dart';
import 'package:journey/entity/stop.dart';
import 'package:floor/floor.dart';

@dao
abstract class TripStopDao {
  @Query('SELECT * FROM TripStop')
  Future<List<TripStop>> findAllTripStops();

  @Query('SELECT * FROM TripStop WHERE tripID=:id')
  Future<List<Stop>> findStopsByTripId(int id);

  @insert
  Future<void> insertTripStop(TripStop tripstop);

  @Query('DELETE FROM TripStop')
  Future<void> deleteAllTripStops();
}
