import 'package:latlong2/latlong.dart';

enum PoiType { city, mountain, river, airport }

class Poi {
  final String id;
  final String name;
  final LatLng location;
  final PoiType type;
  final String? info;
  final double? altitude;
  final int? population;
  final String? extra;

  Poi({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    this.info,
    this.altitude,
    this.population,
    this.extra,
  });

  factory Poi.fromJson(Map<String, dynamic> json) {
    final typeStr = (json['type'] as String?)?.toLowerCase();

    PoiType type = PoiType.city;

    if (json.containsKey('ident') || json.containsKey('iata')) {
      type = PoiType.airport;
    } else if (typeStr == 'mountain' || json.containsKey('ele') || json.containsKey('alt')) {
      type = PoiType.mountain;
    } else if (typeStr == 'river') {
      type = PoiType.river;
    } else {
      type = PoiType.city;
    }

    return Poi(
      id: (json['id'] ?? json['ident'] ?? json['iata'] ?? json['name']).toString(),
      name: (json['name'] ?? '').toString(),
      location: LatLng(
        _toDouble(json['lat']) ?? 0,
        _toDouble(json['lon']) ?? 0,
      ),
      type: type,
      info: json['info']?.toString(),
      altitude: _toDouble(json['alt'] ?? json['ele']),
      population: _toInt(json['pop'] ?? json['population']),
      extra: (json['len'] ?? json['iata'] ?? json['place'])?.toString(),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();

    final cleaned = value
        .toString()
        .replaceAll(',', '.')
        .replaceAll(RegExp(r'[^0-9.\-]'), '');

    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();

    final cleaned = value.toString().replaceAll(RegExp(r'[^0-9\-]'), '');
    if (cleaned.isEmpty) return null;
    return int.tryParse(cleaned);
  }
}