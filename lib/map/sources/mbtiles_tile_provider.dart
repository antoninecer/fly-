import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sqlite3/sqlite3.dart';

class MbTilesTileProvider extends TileProvider {
  final Map<String, Database> _databases = {};

  static const Map<String, List<int>> _zoomRanges = {
    'world_base_z4_z5.mbtiles': [2, 5],
    'europe_detail_z6_z7.mbtiles': [6, 18],
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

  static final Uint8List _transparentTile = Uint8List.fromList(const <int>[
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
    0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
    0x89, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x44, 0x41,
    0x54, 0x78, 0x9C, 0x63, 0xF8, 0xCF, 0xC0, 0x00,
    0x00, 0x03, 0x01, 0x01, 0x00, 0x18, 0xDD, 0x8D,
    0xB1, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E,
    0x44, 0xAE, 0x42, 0x60, 0x82,
  ]);

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    try {
      final tile = _readTile(coordinates.z, coordinates.x, coordinates.y);
      if (tile != null && tile.isNotEmpty) {
        return MemoryImage(tile);
      }
    } catch (e) {
      debugPrint('MBTiles read error z=${coordinates.z} x=${coordinates.x} y=${coordinates.y}: $e');
    }

    return MemoryImage(_transparentTile);
  }

  Uint8List? _readTile(int z, int x, int ySlippy) {
    final yTms = (1 << z) - 1 - ySlippy;

    for (final entry in _databases.entries) {
      final fileName = entry.key;
      final db = entry.value;
      final range = _zoomRanges[fileName] ?? [0, 20];

      if (z < range[0] || z > range[1]) {
        continue;
      }

      final exact = _queryTile(db, z, x, yTms);
      if (exact != null) {
        return exact;
      }

      // fallback: zkus nižší zoom a nech flutter_map tile zvětšit
      if (z > range[0]) {
        for (int fallbackZ = z - 1; fallbackZ >= range[0]; fallbackZ--) {
          final scale = 1 << (z - fallbackZ);
          final fallbackX = x ~/ scale;
          final fallbackYSlippy = ySlippy ~/ scale;
          final fallbackYTms = (1 << fallbackZ) - 1 - fallbackYSlippy;

          final fallback = _queryTile(db, fallbackZ, fallbackX, fallbackYTms);
          if (fallback != null) {
            return fallback;
          }
        }
      }
    }

    return null;
  }

  Uint8List? _queryTile(Database db, int z, int x, int yTms) {
    final resultSet = db.select(
      'SELECT tile_data FROM tiles WHERE zoom_level = ? AND tile_column = ? AND tile_row = ? LIMIT 1',
      [z, x, yTms],
    );

    if (resultSet.isEmpty) return null;

    final tileData = resultSet.first['tile_data'];
    if (tileData is Uint8List && tileData.isNotEmpty) {
      return tileData;
    }

    return null;
  }
}