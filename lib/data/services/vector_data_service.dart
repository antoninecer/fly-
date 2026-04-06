import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'asset_service.dart';

class VectorDataService {
  List<Polyline> _borders = [];
  List<Polyline> _rivers = [];
  List<Polygon> _lakes = [];

  bool _bordersLoaded = false;
  bool _riversLoaded = false;
  bool _lakesLoaded = false;

  List<Polyline> get borders => _borders;
  List<Polyline> get rivers => _rivers;
  List<Polygon> get lakes => _lakes;

  bool get isLoaded => _bordersLoaded && _riversLoaded && _lakesLoaded;

  Future<void> loadAll() async {
    await Future.wait([
      loadBorders(),
      loadRivers(),
      loadLakes(),
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
      final features = data['features'] as List<dynamic>;

      for (final feature in features) {
        final geometry = feature['geometry'];
        final type = geometry['type'];
        final coordinates = geometry['coordinates'];

        if (type == 'Polygon') {
          _addPolygonOutline(
            newBorders,
            coordinates,
            Colors.white.withValues(alpha: 0.45),
            1.1,
          );
        } else if (type == 'MultiPolygon') {
          for (final polygonCoords in coordinates) {
            _addPolygonOutline(
              newBorders,
              polygonCoords,
              Colors.white.withValues(alpha: 0.45),
              1.1,
            );
          }
        }
      }

      _borders = newBorders;
      _bordersLoaded = true;
    } catch (e) {
      debugPrint('Error loading borders: $e');
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
      final features = data['features'] as List<dynamic>;

      for (final feature in features) {
        final geometry = feature['geometry'];
        final type = geometry['type'];
        final coordinates = geometry['coordinates'];

        if (type == 'LineString') {
          _addLineString(
            newRivers,
            coordinates,
            Colors.lightBlueAccent.withValues(alpha: 0.85),
            1.8,
          );
        } else if (type == 'MultiLineString') {
          for (final lineCoords in coordinates) {
            _addLineString(
              newRivers,
              lineCoords,
              Colors.lightBlueAccent.withValues(alpha: 0.85),
              1.8,
            );
          }
        }
      }

      _rivers = newRivers;
      _riversLoaded = true;
    } catch (e) {
      debugPrint('Error loading rivers: $e');
    }
  }

  Future<void> loadLakes() async {
    if (_lakesLoaded) return;

    try {
      final localPath = await AssetService.getLocalPath('europe_lakes.json');
      final file = File(localPath);
      if (!await file.exists()) return;

      final content = await file.readAsString();
      final data = jsonDecode(content);

      final List<Polygon> newLakes = [];
      final features = data['features'] as List<dynamic>;

      for (final feature in features) {
        final geometry = feature['geometry'];
        final type = geometry['type'];
        final coordinates = geometry['coordinates'];

        if (type == 'Polygon') {
          _addFilledPolygon(
            newLakes,
            coordinates,
            Colors.blue.withValues(alpha: 0.28),
            Colors.lightBlueAccent.withValues(alpha: 0.8),
            0.8,
          );
        } else if (type == 'MultiPolygon') {
          for (final polygonCoords in coordinates) {
            _addFilledPolygon(
              newLakes,
              polygonCoords,
              Colors.blue.withValues(alpha: 0.28),
              Colors.lightBlueAccent.withValues(alpha: 0.8),
              0.8,
            );
          }
        }
      }

      _lakes = newLakes;
      _lakesLoaded = true;
    } catch (e) {
      debugPrint('Error loading lakes: $e');
    }
  }

  void _addPolygonOutline(
    List<Polyline> list,
    List<dynamic> polygonCoords,
    Color color,
    double width,
  ) {
    if (polygonCoords.isEmpty) return;

    final outerRing = polygonCoords[0] as List<dynamic>;
    final points = outerRing.map((coord) {
      return LatLng(
        (coord[1] as num).toDouble(),
        (coord[0] as num).toDouble(),
      );
    }).toList();

    if (points.length < 2) return;

    list.add(
      Polyline(
        points: points,
        color: color,
        strokeWidth: width,
      ),
    );
  }

  void _addFilledPolygon(
    List<Polygon> list,
    List<dynamic> polygonCoords,
    Color fillColor,
    Color borderColor,
    double borderWidth,
  ) {
    if (polygonCoords.isEmpty) return;

    final outerRing = polygonCoords[0] as List<dynamic>;
    final points = outerRing.map((coord) {
      return LatLng(
        (coord[1] as num).toDouble(),
        (coord[0] as num).toDouble(),
      );
    }).toList();

    if (points.length < 3) return;

    list.add(
      Polygon(
        points: points,
        color: fillColor,
        borderColor: borderColor,
        borderStrokeWidth: borderWidth,
      ),
    );
  }

  void _addLineString(
    List<Polyline> list,
    List<dynamic> coordinates,
    Color color,
    double width,
  ) {
    final points = coordinates.map((coord) {
      return LatLng(
        (coord[1] as num).toDouble(),
        (coord[0] as num).toDouble(),
      );
    }).toList();

    if (points.length < 2) return;

    list.add(
      Polyline(
        points: points,
        color: color,
        strokeWidth: width,
      ),
    );
  }
}