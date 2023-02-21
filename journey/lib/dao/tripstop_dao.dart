import 'package:journey/entity/tripstops.dart';
import 'package:journey/entity/stop.dart';
import 'package:floor/floor.dart';

@dao
abstract class TripStopDao {
  @Query('SELECT * FROM TripStop')
  Future<List<TripStop>> findAllTripStops();

  @Query(
      'SELECT s.* FROM TripStop ts INNER JOIN Stop s ON ts.stopID=s.id WHERE tripID=:id ORDER BY s.datetime')
  Future<List<Stop>> findStopsByTripId(int id);

  @Query(
      'SELECT s.datetime FROM TripStop ts INNER JOIN Stop s ON ts.stopID=s.id WHERE ts.tripID=:id AND s.datetime=(SELECT MAX(s.datetime) FROM TripStop ts INNER JOIN Stop s ON ts.stopID=s.id WHERE ts.tripID=:id)')
  Future<int?> getLastUpdate(int id);

  @insert
  Future<void> insertTripStop(TripStop tripstop);

  @Query('DELETE FROM TripStop')
  Future<void> deleteAllTripStops();

  @Query('DELETE FROM TripStop WHERE tripID=:id')
  Future<void> deleteAllTripStopsById(int id);

  @Query('DELETE FROM TripStop WHERE tripID=:tripID AND stopID=:stopID')
  Future<void> deleteStopById(int tripID, int stopID);
}
