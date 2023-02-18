import 'package:floor/floor.dart';
import 'package:journey/entity/stop.dart';
import 'package:journey/entity/trip.dart';

@entity
class TripStop {
  // @ForeignKey(childColumns: ['trip', 'stop'], parentColumns: ['name'], entity: Trip)
  @primaryKey
  final int tripID;
  // @ForeignKey(childColumns: ['trip', 'stop'], parentColumns: ['name'], entity: Stop)
  @primaryKey
  final int stopID;
  TripStop(this.tripID, this.stopID);
}