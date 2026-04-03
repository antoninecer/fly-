import 'dart:math';
import 'package:drift/drift.dart';
import '../db/app_database.dart';

class DemoDataService {
  final AppDatabase db;

  DemoDataService(this.db);

  Future<void> seedPragueToNaples() async {
    const sessionId = 'demo-prague-naples';
    
    // Check if already exists
    final existing = await (db.select(db.sessions)..where((t) => t.id.equals(sessionId))).getSingleOrNull();
    if (existing != null) return;

    final startTime = DateTime.now().subtract(const Duration(hours: 5));
    
    // 1. Insert Session
    await db.into(db.sessions).insert(
      SessionsCompanion.insert(
        id: sessionId,
        type: 'flight',
        title: 'Demo: Prague → Naples',
        fromName: const Value('Prague (PRG)'),
        toName: const Value('Naples (NAP)'),
        fromLat: const Value(50.1008),
        fromLon: const Value(14.2567),
        toLat: const Value(40.8844),
        toLon: const Value(14.2908),
        startedAt: startTime,
        endedAt: Value(startTime.add(const Duration(hours: 2))),
        durationSec: const Value(7200),
        distanceKm: const Value(1030.0),
        sourceType: 'demo',
        notes: const Value('Pre-generated demo flight for replay testing.'),
      ),
    );

    // 2. Generate TrackPoints (every 30 seconds for 2 hours = 240 points)
    final points = <TrackPointsCompanion>[];
    
    const startLat = 50.1008;
    const startLon = 14.2567;
    const endLat = 40.8844;
    const endLon = 14.2908;
    
    for (int i = 0; i <= 240; i++) {
      final t = i / 240.0; // progression 0.0 to 1.0
      
      // Linear interpolation for Lat/Lon
      final lat = startLat + (endLat - startLat) * t;
      final lon = startLon + (endLon - startLon) * t;
      
      // Altitude curve: parabolic (climb to 10000m, then stay, then descend)
      double alt = 0;
      if (t < 0.2) { // Climb
        alt = (t / 0.2) * 10000;
      } else if (t > 0.8) { // Descent
        alt = ((1.0 - t) / 0.2) * 10000;
      } else { // Cruise
        alt = 10000 + (sin(t * 50) * 50); // slight jitter in cruise
      }

      // Speed: 0 to 850 km/h then back to 0
      double speed = 850.0;
      if (t < 0.1) speed = (t / 0.1) * 850;
      if (t > 0.9) speed = ((1.0 - t) / 0.1) * 850;

      points.add(TrackPointsCompanion.insert(
        sessionId: sessionId,
        timestamp: startTime.add(Duration(seconds: i * 30)),
        lat: lat,
        lon: lon,
        altMeters: alt,
        speedKmh: speed,
        headingDeg: 195.0, // roughly South-South-West
        phase: Value(t < 0.2 ? 'climb' : (t > 0.8 ? 'descent' : 'cruise')),
      ));
    }

    // Bulk insert points
    await db.batch((batch) {
      batch.insertAll(db.trackPoints, points);
    });
  }
}
