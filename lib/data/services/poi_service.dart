import 'dart:convert';
import 'dart:io';

import 'package:latlong2/latlong.dart';

import '../models/poi.dart';
import 'asset_service.dart';

class PoiService {
  List<Poi> _pois = [];

  List<Poi> get allPois => _pois;

  Future<void> loadBasePois() async {
    try {
      final List<Poi> loaded = [];

      loaded.addAll(await _loadPoisFromFile(
        'eu_cities_major.json',
        defaultType: PoiType.city,
      ));

      loaded.addAll(await _loadPoisFromFile(
        'eu_cities_medium.json',
        defaultType: PoiType.city,
      ));

      loaded.addAll(await _loadPoisFromFile(
        'eu_peaks_major.json',
        defaultType: PoiType.mountain,
      ));
      
      _pois = _deduplicatePois(loaded);
    } catch (e) {
      print('Error loading POIs: $e');
      _pois = [];
    }
  }

  Future<List<Poi>> _loadPoisFromFile(
    String fileName, {
    required PoiType? defaultType,
    int? airportLimit,
  }) async {
    try {
      final localPath = await AssetService.getLocalPath(fileName);
      final file = File(localPath);

      if (!await file.exists()) {
        return [];
      }

      final content = await file.readAsString();
      final decoded = jsonDecode(content);

      if (decoded is! List) {
        return [];
      }

      Iterable<dynamic> items = decoded;

      if (airportLimit != null) {
        items = items.take(airportLimit);
      }

      return items
          .whereType<Map>()
          .map((item) => _poiFromSource(
                Map<String, dynamic>.from(item),
                defaultType: defaultType,
              ))
          .whereType<Poi>()
          .toList();
    } catch (e) {
      print('Error loading $fileName: $e');
      return [];
    }
  }

  Poi? _poiFromSource(
    Map<String, dynamic> json, {
    required PoiType? defaultType,
  }) {
    final lat = json['lat'];
    final lon = json['lon'];
    final name = json['name'];

    if (lat == null || lon == null || name == null) {
      return null;
    }

    final map = Map<String, dynamic>.from(json);

    if (defaultType != null && !map.containsKey('type')) {
      switch (defaultType) {
        case PoiType.city:
          map['type'] = 'city';
          break;
        case PoiType.mountain:
          map['type'] = 'mountain';
          break;
        case PoiType.river:
          map['type'] = 'river';
          break;
        case PoiType.airport:
          map['type'] = 'airport';
          break;
      }
    }

    if (defaultType == PoiType.city && !map.containsKey('pop')) {
      map['pop'] = map['population'];
    }

    if (defaultType == PoiType.mountain && !map.containsKey('alt')) {
      map['alt'] = map['ele'];
    }

    return Poi.fromJson(map);
  }

  List<Poi> _deduplicatePois(List<Poi> input) {
    final Map<String, Poi> unique = {};

    for (final poi in input) {
      final key =
          '${poi.type.name}|${poi.name}|${poi.location.latitude.toStringAsFixed(5)}|${poi.location.longitude.toStringAsFixed(5)}';

      final existing = unique[key];
      if (existing == null) {
        unique[key] = poi;
        continue;
      }

      if (_scorePoi(poi) > _scorePoi(existing)) {
        unique[key] = poi;
      }
    }

    return unique.values.toList();
  }

  int _scorePoi(Poi poi) {
    int score = 0;
    if ((poi.population ?? 0) > 0) score += 10;
    if ((poi.altitude ?? 0) > 0) score += 10;
    if ((poi.extra ?? '').isNotEmpty) score += 5;
    if ((poi.info ?? '').isNotEmpty) score += 2;
    return score;
  }

  List<Poi> getNearby(LatLng position, double radiusKm) {
    const Distance distance = Distance();

    return _pois.where((poi) {
      final d = distance.as(LengthUnit.Kilometer, position, poi.location);
      return d <= radiusKm;
    }).toList();
  }
}