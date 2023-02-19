// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TripDao? _tripdaoInstance;

  StopDao? _stopdaoInstance;

  TripStopDao? _tripstopdaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Trip` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `lastUpdate` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Stop` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `info` TEXT NOT NULL, `lat` REAL NOT NULL, `lang` REAL NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TripStop` (`tripID` INTEGER NOT NULL, `stopID` INTEGER NOT NULL, PRIMARY KEY (`tripID`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TripDao get tripdao {
    return _tripdaoInstance ??= _$TripDao(database, changeListener);
  }

  @override
  StopDao get stopdao {
    return _stopdaoInstance ??= _$StopDao(database, changeListener);
  }

  @override
  TripStopDao get tripstopdao {
    return _tripstopdaoInstance ??= _$TripStopDao(database, changeListener);
  }
}

class _$TripDao extends TripDao {
  _$TripDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _tripInsertionAdapter = InsertionAdapter(
            database,
            'Trip',
            (Trip item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'lastUpdate': _dateTimeConverter.encode(item.lastUpdate)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Trip> _tripInsertionAdapter;

  @override
  Future<List<Trip>> findAllTrips() async {
    return _queryAdapter.queryList('SELECT * FROM Trip',
        mapper: (Map<String, Object?> row) =>
            Trip(row['id'] as int?, row['name'] as String));
  }

  @override
  Stream<Trip?> findTripById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Trip WHERE id=?1',
        mapper: (Map<String, Object?> row) =>
            Trip(row['id'] as int?, row['name'] as String),
        arguments: [id],
        queryableName: 'Trip',
        isView: false);
  }

  @override
  Stream<Trip?> findTripByName(String name) {
    return _queryAdapter.queryStream('SELECT * FROM Trip WHERE name=?1',
        mapper: (Map<String, Object?> row) =>
            Trip(row['id'] as int?, row['name'] as String),
        arguments: [name],
        queryableName: 'Trip',
        isView: false);
  }

  @override
  Future<void> deleteAllTrips() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Trip');
  }

  @override
  Future<void> insertTrip(Trip trip) async {
    await _tripInsertionAdapter.insert(trip, OnConflictStrategy.abort);
  }
}

class _$StopDao extends StopDao {
  _$StopDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _stopInsertionAdapter = InsertionAdapter(
            database,
            'Stop',
            (Stop item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'info': item.info,
                  'lat': item.lat,
                  'lang': item.lang
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Stop> _stopInsertionAdapter;

  @override
  Future<List<Stop>> findAllStops() async {
    return _queryAdapter.queryList('SELECT * FROM Stop',
        mapper: (Map<String, Object?> row) => Stop(
            row['id'] as int?,
            row['name'] as String,
            row['info'] as String,
            row['lat'] as double,
            row['lang'] as double));
  }

  @override
  Stream<Stop?> findStopById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Stop WHERE id=?1',
        mapper: (Map<String, Object?> row) => Stop(
            row['id'] as int?,
            row['name'] as String,
            row['info'] as String,
            row['lat'] as double,
            row['lang'] as double),
        arguments: [id],
        queryableName: 'Stop',
        isView: false);
  }

  @override
  Stream<Stop?> findStopByName(String name) {
    return _queryAdapter.queryStream('SELECT * FROM Stop WHERE name=?1',
        mapper: (Map<String, Object?> row) => Stop(
            row['id'] as int?,
            row['name'] as String,
            row['info'] as String,
            row['lat'] as double,
            row['lang'] as double),
        arguments: [name],
        queryableName: 'Stop',
        isView: false);
  }

  @override
  Future<void> deleteAllStops() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Stop');
  }

  @override
  Future<void> insertStop(Stop stop) async {
    await _stopInsertionAdapter.insert(stop, OnConflictStrategy.abort);
  }
}

class _$TripStopDao extends TripStopDao {
  _$TripStopDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _tripStopInsertionAdapter = InsertionAdapter(
            database,
            'TripStop',
            (TripStop item) => <String, Object?>{
                  'tripID': item.tripID,
                  'stopID': item.stopID
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TripStop> _tripStopInsertionAdapter;

  @override
  Future<List<TripStop>> findAllTripStops() async {
    return _queryAdapter.queryList('SELECT * FROM TripStop',
        mapper: (Map<String, Object?> row) =>
            TripStop(row['tripID'] as int, row['stopID'] as int));
  }

  @override
  Future<List<Stop>> findStopsByTripId(int id) async {
    return _queryAdapter.queryList('SELECT * FROM TripStop WHERE tripID=?1',
        mapper: (Map<String, Object?> row) => Stop(
            row['id'] as int?,
            row['name'] as String,
            row['info'] as String,
            row['lat'] as double,
            row['lang'] as double),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllTripStops() async {
    await _queryAdapter.queryNoReturn('DELETE FROM TripStop');
  }

  @override
  Future<void> insertTripStop(TripStop tripstop) async {
    await _tripStopInsertionAdapter.insert(tripstop, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
