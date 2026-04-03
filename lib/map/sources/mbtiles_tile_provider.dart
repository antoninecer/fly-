import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sqlite3/sqlite3.dart';
import 'dart:io';

class MbTilesTileProvider extends TileProvider {
  final Map<String, Database> _databases = {};
  
  // Define zoom ranges for each package
  static const Map<String, List<int>> _zoomRanges = {
    'world_base_z4_z5.mbtiles': [2, 5],
    'europe_detail_z6_z7.mbtiles': [6, 18], // Upscale beyond 7
  };

  MbTilesTileProvider({required List<String> paths}) {
    for (final path in paths) {
      if (File(path).existsSync()) {
        final name = path.split('/').last;
        _databases[name] = sqlite3.open(path, mode: OpenMode.readOnly);
      }
    }
  }

  void dispose() {
    for (final db in _databases.values) {
      db.dispose();
    }
  }

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    final z = coordinates.z;
    final x = coordinates.x;
    final y = (1 << z) - 1 - coordinates.y;

    // Iterate through databases based on zoom priority
    for (final entry in _databases.entries) {
      final fileName = entry.key;
      final db = entry.value;
      final range = _zoomRanges[fileName] ?? [0, 20];

      if (z >= range[0] && z <= range[1]) {
        // Try to find tile in this DB
        final resultSet = db.select(
          'SELECT tile_data FROM tiles WHERE zoom_level = ? AND tile_column = ? AND tile_row = ?',
          [z, x, y],
        );

        if (resultSet.isNotEmpty) {
          final blob = resultSet.first['tile_data'] as Uint8List;
          return MemoryImage(blob);
        }
      }
    }

    // Fallback image if no tile found anywhere
    return const AssetImage('assets/icons/map_placeholder.png');
  }
}
