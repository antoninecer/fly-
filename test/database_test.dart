import 'package:drift/native.dart';
import 'package:fly2/data/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('Should insert and retrieve a session', () async {
    final sessionId = 'test-session-1';
    
    await db.into(db.sessions).insert(
      SessionsCompanion.insert(
        id: sessionId,
        type: 'flight',
        title: 'Prague to Naples',
        startedAt: DateTime.now(),
        sourceType: 'manual',
      ),
    );

    final session = await (db.select(db.sessions)..where((t) => t.id.equals(sessionId))).getSingle();
    
    expect(session.id, sessionId);
    expect(session.title, 'Prague to Naples');
    expect(session.isActive, false); // default value check
  });

  test('Should insert track points for a session', () async {
    final sessionId = 'test-session-2';
    
    await db.into(db.sessions).insert(
      SessionsCompanion.insert(
        id: sessionId,
        type: 'tracker',
        title: 'Blackbox Recording',
        startedAt: DateTime.now(),
        sourceType: 'tracker',
      ),
    );

    await db.into(db.trackPoints).insert(
      TrackPointsCompanion.insert(
        sessionId: sessionId,
        timestamp: DateTime.now(),
        lat: 50.087,
        lon: 14.421,
        altMeters: 250.0,
        speedKmh: 0.0,
        headingDeg: 0.0,
      ),
    );

    final points = await (db.select(db.trackPoints)..where((t) => t.sessionId.equals(sessionId))).get();
    
    expect(points.length, 1);
    expect(points.first.lat, 50.087);
  });
}
