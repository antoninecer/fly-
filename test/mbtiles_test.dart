import 'package:sqlite3/sqlite3.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

void main() {
  test('Should be able to open MBTiles file with sqlite3', () {
    final path = 'data/maps/source/world_base_z4_z5.mbtiles';
    final file = File(path);
    
    expect(file.existsSync(), isTrue);
    
    final db = sqlite3.open(path, mode: OpenMode.readOnly);
    final resultSet = db.select('SELECT count(*) as count FROM tiles');
    
    expect(resultSet.first['count'], greaterThan(0));
    db.dispose();
  });
}
