import '../../data/models/map_package.dart';

class MapRegistry {
  static const packages = <MapPackage>[
    MapPackage(
      id: 'world_base',
      name: 'World Base',
      fileName: 'world_base_z4_z5.mbtiles',
      minZoom: 4,
      maxZoom: 5,
      priority: 1,
      isFallback: true,
    ),
    MapPackage(
      id: 'europe_detail',
      name: 'Europe Detail',
      fileName: 'europe_detail_z6_z7.mbtiles',
      minZoom: 6,
      maxZoom: 7,
      priority: 10,
      isFallback: false,
    ),
    MapPackage(
      id: 'europe_legacy',
      name: 'Europe Legacy',
      fileName: 'europe_med_satellite_legacy.mbtiles',
      minZoom: 4,
      maxZoom: 6,
      priority: 0,
      isFallback: false,
    ),
  ];
}
