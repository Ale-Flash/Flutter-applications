import 'package:journey/entity/trip.dart';
import 'package:floor/floor.dart';

@dao
abstract class TripDao {
  @Query('SELECT * FROM Trip')
  Future<List<Trip>> findAllTrips();

  @Query('SELECT * FROM Trip WHERE id=:id')
  Stream<Trip?> findTripById(int id);

  @Query('SELECT * FROM Trip WHERE name=:name')
  Stream<Trip?> findTripByName(String name);

  @insert
  Future<void> insertTrip(Trip trip);

  @Query('DELETE FROM Trip')
  Future<void> deleteAllTrips();
}
