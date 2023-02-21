import 'package:journey/entity/trip.dart';
import 'package:floor/floor.dart';

@dao
abstract class TripDao {
  @Query('SELECT * FROM Trip')
  Future<List<Trip>> findAllTrips();

  @Query('SELECT t.* FROM Trip t LEFT JOIN TripStop ts ON t.id=ts.tripID LEFT JOIN Stop s ON ts.stopID=s.id GROUP BY t.id ORDER BY s.datetime DESC')
  Future<List<Trip>> findAllTripsOrdered();

  @Query('SELECT * FROM Trip WHERE id=:id')
  Stream<Trip?> findTripById(int id);

  @Query('SELECT * FROM Trip WHERE name=:name')
  Stream<Trip?> findTripByName(String name);

  @insert
  Future<void> insertTrip(Trip trip);

  @Query('DELETE FROM Trip')
  Future<void> deleteAllTrips();

  @Query('DELETE FROM Trip WHERE id=:id')
  Future<void> deleteAllTripsById(int id);
}
