import 'package:latlong2/latlong.dart';
import '../models/poi.dart';

class UnderflightContext {
  final Poi poi;
  final double distanceKm;
  final DateTime timestamp;

  UnderflightContext({
    required this.poi,
    required this.distanceKm,
    required this.timestamp,
  });
}

class ContextEngine {
  final List<Poi> pois;
  final double detectionRadiusKm;
  final double hysteresisKm;

  Poi? _activePoi;
  final Distance _distanceCalc = const Distance();

  ContextEngine({
    required this.pois,
    this.detectionRadiusKm = 30.0,
    this.hysteresisKm = 5.0,
  });

  UnderflightContext? update(LatLng currentPos) {
    if (pois.isEmpty) return null;

    if (_activePoi != null) {
      final d = _distanceCalc.as(LengthUnit.Kilometer, currentPos, _activePoi!.location);
      if (d < (detectionRadiusKm + hysteresisKm)) {
        return UnderflightContext(
          poi: _activePoi!,
          distanceKm: d,
          timestamp: DateTime.now(),
        );
      } else {
        _activePoi = null; 
      }
    }

    Poi? closest;
    double minD = double.infinity;

    for (final poi in pois) {
      final d = _distanceCalc.as(LengthUnit.Kilometer, currentPos, poi.location);
      if (d < detectionRadiusKm && d < minD) {
        minD = d;
        closest = poi;
      }
    }

    if (closest != null) {
      _activePoi = closest;
      return UnderflightContext(
        poi: closest,
        distanceKm: minD,
        timestamp: DateTime.now(),
      );
    }

    return null;
  }
}
