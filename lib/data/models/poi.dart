import 'package:latlong2/latlong.dart';

enum PoiType { city, mountain, river, airport }

class Poi {
  final String id;
  final String name;
  final LatLng location;
  final PoiType type;
  final String? info;
  final double? altitude; // for mountains
  final String? population; // for cities
  final String? extra; // length for rivers, iata for airports

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
    final typeStr = json['type'] as String?;
    PoiType type = PoiType.city;
    if (typeStr == 'mountain') type = PoiType.mountain;
    if (typeStr == 'river') type = PoiType.river;
    if (json.containsKey('ident')) type = PoiType.airport;

    return Poi(
      id: json['ident'] ?? json['name'],
      name: json['name'],
      location: LatLng(
        (json['lat'] as num).toDouble(),
        (json['lon'] as num).toDouble(),
      ),
      type: type,
      info: json['info'],
      altitude: (json['alt'] as num?)?.toDouble(),
      population: json['pop'],
      extra: json['len'] ?? json['iata'],
    );
  }
}
