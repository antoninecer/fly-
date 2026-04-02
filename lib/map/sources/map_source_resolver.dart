import '../../data/models/map_package.dart';
import 'map_registry.dart';

class MapSourceResolver {
  static MapPackage? forZoom(int zoom) {
    final candidates = MapRegistry.packages
        .where((p) => zoom >= p.minZoom && zoom <= p.maxZoom)
        .toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));

    if (candidates.isEmpty) return null;
    return candidates.first;
  }
}
