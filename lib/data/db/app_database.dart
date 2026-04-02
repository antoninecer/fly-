import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Sessions extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get fromName => text().nullable()();
  TextColumn get toName => text().nullable()();
  RealColumn get fromLat => real().nullable()();
  RealColumn get fromLon => real().nullable()();
  RealColumn get toLat => real().nullable()();
  RealColumn get toLon => real().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get durationSec => integer().withDefault(const Constant(0))();
  RealColumn get distanceKm => real().withDefault(const Constant(0.0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  TextColumn get sourceType => text()(); // e.g., 'manual', 'api', 'tracker'
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class TrackPoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text().references(Sessions, #id)();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get lat => real()();
  RealColumn get lon => real()();
  RealColumn get altMeters => real()();
  RealColumn get speedKmh => real()();
  RealColumn get headingDeg => real()();
  TextColumn get phase => text().nullable()(); // e.g., 'climb', 'cruise', 'descent'
}

class PlaybackStates extends Table {
  TextColumn get sessionId => text().references(Sessions, #id)();
  IntColumn get currentTimeSec => integer()();
  RealColumn get speedMultiplier => real().withDefault(const Constant(1.0))();
  BoolColumn get isPlaying => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {sessionId};
}

class MapPackages extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get fileName => text()();
  IntColumn get minZoom => integer()();
  IntColumn get maxZoom => integer()();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  BoolColumn get isFallback => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Sessions, TrackPoints, PlaybackStates, MapPackages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'fly2_db');
  }
}
