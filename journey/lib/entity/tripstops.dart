import 'package:floor/floor.dart';

@Entity(primaryKeys: ['tripID', 'stopID'])
class TripStop {
  final int tripID;
  final int stopID;
  TripStop(this.tripID, this.stopID);
}
