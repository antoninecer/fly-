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
  final String? country;

  Poi({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    this.info,
    this.altitude,
    this.population,
    this.extra,
    this.country,
  });

  factory Poi.fromJson(Map<String, dynamic> json) {
    final typeStr = (json['type'] as String?)?.toLowerCase();

    PoiType type = PoiType.city;

    if (json.containsKey('ident') || json.containsKey('iata')) {
      type = PoiType.airport;
    } else if (typeStr == 'mountain' ||
        json.containsKey('ele') ||
        json.containsKey('alt')) {
      type = PoiType.mountain;
    } else if (typeStr == 'river') {
      type = PoiType.river;
    } else {
      type = PoiType.city;
    }

    return Poi(
      id: (json['id'] ?? json['ident'] ?? json['iata'] ?? json['name'])
          .toString(),
      name: (json['name'] ?? '').toString(),
      location: LatLng(
        _toCoordinate(json['lat']) ?? 0,
        _toCoordinate(json['lon']) ?? 0,
      ),
      type: type,
      info: json['info']?.toString(),
      altitude: _toAltitude(json['alt'] ?? json['ele']),
      population: _toInt(json['pop'] ?? json['population']),
      extra: (json['len'] ?? json['iata'] ?? json['place'])?.toString(),
      country: (json['country'] ??
              json['country_name'] ??
              json['admin'] ??
              json['iso2'] ??
              json['iso3'])
          ?.toString(),
    );
  }

  static double? _toCoordinate(dynamic value) {
    return _toDouble(
      value,
      maxReasonableValue: 180,
      minReasonableValue: -180,
    );
  }

  static double? _toAltitude(dynamic value) {
    return _toDouble(
      value,
      maxReasonableValue: 9000,
      minReasonableValue: -500,
      preferThousandsSeparatorForSingleDot: true,
    );
  }

  static double? _toDouble(
    dynamic value, {
    double? maxReasonableValue,
    double? minReasonableValue,
    bool preferThousandsSeparatorForSingleDot = false,
  }) {
    if (value == null) return null;
    if (value is num) {
      final v = value.toDouble();
      if (!_isReasonable(v, minReasonableValue, maxReasonableValue)) {
        return null;
      }
      return v;
    }

    var s = value.toString().trim();
    if (s.isEmpty) return null;

    s = s.replaceAll(RegExp(r'\s+'), '');
    s = s.replaceAll(RegExp(r'[^\d,.\-]'), '');

    if (s.isEmpty || s == '-' || s == '.' || s == ',') return null;

    final dotCount = '.'.allMatches(s).length;
    final commaCount = ','.allMatches(s).length;

    if (dotCount > 0 && commaCount > 0) {
      final lastDot = s.lastIndexOf('.');
      final lastComma = s.lastIndexOf(',');

      if (lastDot > lastComma) {
        s = s.replaceAll(',', '');
      } else {
        s = s.replaceAll('.', '');
        s = s.replaceAll(',', '.');
      }
    } else if (dotCount > 1) {
      s = s.replaceAll('.', '');
    } else if (commaCount > 1) {
      s = s.replaceAll(',', '');
    } else if (preferThousandsSeparatorForSingleDot && dotCount == 1) {
      final idx = s.indexOf('.');
      final digitsAfter = s.length - idx - 1;

      if (digitsAfter == 3) {
        s = s.replaceAll('.', '');
      }
    } else if (commaCount == 1) {
      final idx = s.indexOf(',');
      final digitsAfter = s.length - idx - 1;

      if (preferThousandsSeparatorForSingleDot && digitsAfter == 3) {
        s = s.replaceAll(',', '');
      } else {
        s = s.replaceAll(',', '.');
      }
    }

    final parsed = double.tryParse(s);
    if (parsed == null) return null;

    if (!_isReasonable(parsed, minReasonableValue, maxReasonableValue)) {
      return null;
    }

    return parsed;
  }

  static bool _isReasonable(
    double value,
    double? minReasonableValue,
    double? maxReasonableValue,
  ) {
    if (minReasonableValue != null && value < minReasonableValue) {
      return false;
    }
    if (maxReasonableValue != null && value > maxReasonableValue) {
      return false;
    }
    return true;
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