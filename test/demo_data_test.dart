import 'package:drift/native.dart';
import 'package:fly2/data/db/app_database.dart';
import 'package:fly2/data/services/demo_data_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late DemoDataService demoService;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    demoService = DemoDataService(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Should generate Prague to Naples demo flight with 241 points', () async {
    await demoService.seedPragueToNaples();
    
    final sessions = await db.select(db.sessions).get();
    expect(sessions.length, 1);
    expect(sessions.first.id, 'demo-prague-naples');
    expect(sessions.first.sourceType, 'demo');

    final points = await db.select(db.trackPoints).get();
    expect(points.length, 241); // 0..240
    
    // Check first and last point
    expect(points.first.lat, 50.1008);
    expect(points.last.lat, 40.8844);
    
    // Check cruise altitude
    final midPoint = points[120];
    expect(midPoint.altMeters, greaterThan(9900));
    expect(midPoint.phase, 'cruise');
  });
}
