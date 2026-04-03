import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class AssetService {
  /// Ensures all required data files are copied from assets to the local file system
  /// so they can be opened by sqlite3 or other file-based tools.
  Future<List<String>> initializeAssets() async {
    final List<String> mbtilesFiles = [
      'world_base_z4_z5.mbtiles',
      'europe_detail_z6_z7.mbtiles',
    ];

    final List<String> jsonFiles = [
      'airports.json',
      'cities.json',
      'poi_database.json',
      'borders.json',
      'europe_rivers.json',
    ];

    final docDir = await getApplicationDocumentsDirectory();
    final List<String> localMbtilesPaths = [];

    // Copy MBTiles
    for (final fileName in mbtilesFiles) {
      final localPath = join(docDir.path, fileName);
      final file = File(localPath);

      if (!await file.exists()) {
        final data = await rootBundle.load('data/maps/source/$fileName');
        final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await file.writeAsBytes(bytes, flush: true);
      }
      localMbtilesPaths.add(localPath);
    }

    // Copy JSONs (so services can still use File API)
    for (final fileName in jsonFiles) {
      final localPath = join(docDir.path, fileName);
      final file = File(localPath);

      if (!await file.exists()) {
        final data = await rootBundle.load('data/source/$fileName');
        final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await file.writeAsBytes(bytes, flush: true);
      }
    }

    return localMbtilesPaths;
  }

  /// Helper to get the local path of a file in the app documents directory
  static Future<String> getLocalPath(String fileName) async {
    final docDir = await getApplicationDocumentsDirectory();
    return join(docDir.path, fileName);
  }
}
