import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'asset_service.dart';

class VectorDataService {
  List<Polyline> _borders = [];
  List<Polyline> _rivers = [];
  bool _bordersLoaded = false;
  bool _riversLoaded = false;

  List<Polyline> get borders => _borders;
  List<Polyline> get rivers => _rivers;
  bool get isLoaded => _bordersLoaded && _riversLoaded;

  Future<void> loadAll() async {
    await Future.wait([
      loadBorders(),
      loadRivers(),
    ]);
  }

  Future<void> loadBorders() async {
    if (_bordersLoaded) return;
    try {
      final localPath = await AssetService.getLocalPath('borders.json');
      final file = File(localPath);
      if (!await file.exists()) return;

      final content = await file.readAsString();
      final data = jsonDecode(content);
      
      final List<Polyline> newBorders = [];
      final features = data['features'] as List;

      for (final feature in features) {
        final geometry = feature['geometry'];
        final type = geometry['type'];
        final coordinates = geometry['coordinates'];

        if (type == 'Polygon') {
          _addPolygon(newBorders, coordinates, Colors.white.withValues(alpha: 0.4), 1.0);
        } else if (type == 'MultiPolygon') {
          for (final polygonCoords in coordinates) {
            _addPolygon(newBorders, polygonCoords, Colors.white.withValues(alpha: 0.4), 1.0);
          }
        }
      }

      _borders = newBorders;
      _bordersLoaded = true;
    } catch (e) {
      print('Error loading borders: $e');
    }
  }

  Future<void> loadRivers() async {
    if (_riversLoaded) return;
    try {
      final localPath = await AssetService.getLocalPath('europe_rivers.json');
      final file = File(localPath);
      if (!await file.exists()) return;

      final content = await file.readAsString();
      final data = jsonDecode(content);
      
      final List<Polyline> newRivers = [];
      final features = data['features'] as List;

      for (final feature in features) {
        final geometry = feature['geometry'];
        final type = geometry['type'];
        final coordinates = geometry['coordinates'];

        if (type == 'LineString') {
          _addLineString(newRivers, coordinates, Colors.blueAccent.withValues(alpha: 0.6), 1.2);
        } else if (type == 'MultiLineString') {
          for (final lineCoords in coordinates) {
            _addLineString(newRivers, lineCoords, Colors.blueAccent.withValues(alpha: 0.6), 1.2);
          }
        }
      }

      _rivers = newRivers;
      _riversLoaded = true;
    } catch (e) {
      print('Error loading rivers: $e');
    }
  }

  void _addPolygon(List<Polyline> list, List<dynamic> polygonCoords, Color color, double width) {
    final List<dynamic> outerRing = polygonCoords[0];
    final List<LatLng> points = outerRing.map((coord) {
      return LatLng(
        (coord[1] as num).toDouble(),
        (coord[0] as num).toDouble(),
      );
    }).toList();

    list.add(Polyline(
      points: points,
      color: color,
      strokeWidth: width,
    ));
  }

  void _addLineString(List<Polyline> list, List<dynamic> coordinates, Color color, double width) {
    final List<LatLng> points = coordinates.map((coord) {
      return LatLng(
        (coord[1] as num).toDouble(),
        (coord[0] as num).toDouble(),
      );
    }).toList();

    list.add(Polyline(
      points: points,
      color: color,
      strokeWidth: width,
    ));
  }
}
