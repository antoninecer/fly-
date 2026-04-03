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
      final localPath = await AssetService.getLocalPath('poi_database.json');
      final poiFile = File(localPath);
      
      if (await poiFile.exists()) {
        final content = await poiFile.readAsString();
        final List<dynamic> data = jsonDecode(content);
        _pois = data.map((item) => Poi.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error loading POIs: $e');
    }
  }

  // Optimized search for nearby POIs
  List<Poi> getNearby(LatLng position, double radiusKm) {
    const Distance distance = Distance();
    return _pois.where((poi) {
      final d = distance.as(LengthUnit.Kilometer, position, poi.location);
      return d <= radiusKm;
    }).toList();
  }
}
