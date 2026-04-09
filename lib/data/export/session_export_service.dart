import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:path_provider/path_provider.dart';

import '../db/app_database.dart';
import 'kml_exporter.dart';

class SessionExportService {
  final AppDatabase db;

  SessionExportService(this.db);

  Future<File> exportSessionAsKml(String sessionId) async {
    final session = await (db.select(db.sessions)
          ..where((t) => t.id.equals(sessionId)))
        .getSingleOrNull();

    if (session == null) {
      throw Exception('Session "$sessionId" not found.');
    }

    final points = await (db.select(db.trackPoints)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.timestamp)]))
        .get();

    if (points.isEmpty) {
      throw Exception('Session "${session.title}" has no track points.');
    }

    final kml = KmlExporter.buildSessionKml(
      session: session,
      points: points,
    );

    final dir = await getTemporaryDirectory();
    final safeFileName = _safeFileName(session.title);
    final file = File('${dir.path}/$safeFileName.kml');

    await file.writeAsString(kml, flush: true);
    return file;
  }

  String _safeFileName(String value) {
    final cleaned = value
        .trim()
        .replaceAll(RegExp(r'[^\w\s\-]+', unicode: true), '')
        .replaceAll(RegExp(r'\s+'), '_');

    if (cleaned.isEmpty) {
      return 'fly2_export';
    }
    return cleaned;
  }
}