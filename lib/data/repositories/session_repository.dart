import 'package:drift/drift.dart';
import '../db/app_database.dart';

class SessionRepository {
  final AppDatabase db;

  SessionRepository(this.db);

  Stream<List<Session>> watchAllSessions() {
    return (db.select(db.sessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .watch();
  }

  Future<List<Session>> getAllSessions() {
    return (db.select(db.sessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
  }

  Future<void> deleteSession(String sessionId) async {
    await db.transaction(() async {
      // 1. Delete all points first
      await (db.delete(db.trackPoints)..where((t) => t.sessionId.equals(sessionId))).go();
      // 2. Delete playback state
      await (db.delete(db.playbackStates)..where((t) => t.sessionId.equals(sessionId))).go();
      // 3. Delete session itself
      await (db.delete(db.sessions)..where((t) => t.id.equals(sessionId))).go();
    });
  }

  Future<Session?> getSession(String sessionId) {
    return (db.select(db.sessions)..where((t) => t.id.equals(sessionId))).getSingleOrNull();
  }
}
