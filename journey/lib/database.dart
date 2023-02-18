import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:journey/dao/stop_dao.dart';
import 'package:journey/dao/trip_dao.dart';
import 'package:journey/dao/tripstop_dao.dart';
import 'package:journey/entity/stop.dart';
import 'package:journey/entity/trip.dart';
import 'package:journey/entity/tripstops.dart';
import 'package:journey/converter.dart';

part 'database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Trip, Stop, TripStop])
abstract class AppDatabase extends FloorDatabase {
  TripDao get tripdao;
  StopDao get stopdao;
  TripStopDao get tripstopdao;
}
