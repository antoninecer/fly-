import 'package:latlong2/latlong.dart';
import 'package:fly2/data/models/poi.dart';
import 'package:fly2/data/services/context_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ContextEngine should trigger on Prague when approaching', () {
    final prague = Poi(
      id: 'prg',
      name: 'Praha',
      location: const LatLng(50.07, 14.43),
      type: PoiType.city,
    );

    final engine = ContextEngine(pois: [prague]);

    // 1. Far away (100km North)
    var ctx = engine.update(const LatLng(51.0, 14.43));
    expect(ctx, isNull);

    // 2. Approaching (25km North)
    ctx = engine.update(const LatLng(50.3, 14.43));
    expect(ctx, isNotNull);
    expect(ctx!.poi.name, 'Praha');
    expect(ctx.distanceKm, lessThan(30.0));

    // 3. Staying inside (10km South)
    ctx = engine.update(const LatLng(49.98, 14.43));
    expect(ctx, isNotNull);
    expect(ctx!.poi.name, 'Praha');

    // 4. Leaving but still in hysteresis (32km South)
    ctx = engine.update(const LatLng(49.78, 14.43));
    expect(ctx, isNotNull); // Still active due to hysteresis (30 + 5)

    // 5. Fully left (40km South)
    ctx = engine.update(const LatLng(49.7, 14.43));
    expect(ctx, isNull);
  });
}
