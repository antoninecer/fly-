import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong2.dart';
import '../sources/mbtiles_tile_provider.dart';
import '../../data/services/poi_service.dart';

class LiveMap extends StatefulWidget {
  final List<String> mbtilesPaths;
  final LatLng initialCenter;
  final double initialZoom;
  final List<LatLng>? track;
  final LatLng? currentLocation;
  final double? heading;
  final List<Poi> pois;

  const LiveMap({
    super.key,
    required this.mbtilesPaths,
    this.initialCenter = const LatLng(50.087, 14.421),
    this.initialZoom = 5,
    this.track,
    this.currentLocation,
    this.heading,
    this.pois = const [],
  });

  @override
  State<LiveMap> createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  late final MbTilesTileProvider _tileProvider;

  @override
  void initState() {
    super.initState();
    _tileProvider = MbTilesTileProvider(paths: widget.mbtilesPaths);
  }

  @override
  void dispose() {
    _tileProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: widget.initialCenter,
        initialZoom: widget.initialZoom,
        maxZoom: 18, // Allowed zoom for vectors
        minZoom: 2,
      ),
      children: [
        TileLayer(
          tileProvider: _tileProvider,
          backgroundColor: Colors.black,
          maxNativeZoom: 7, // STOP fetching tiles at zoom 7, upscale thereafter!
        ),
        // Vector Path
        if (widget.track != null && widget.track!.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: widget.track!,
                color: Colors.blueAccent.withValues(alpha: 0.8),
                strokeWidth: 4,
              ),
            ],
          ),
        // POI Layer
        MarkerLayer(
          markers: widget.pois.map((poi) {
            return Marker(
              point: poi.location,
              width: 60,
              height: 60,
              child: Column(
                children: [
                  _getPoiIcon(poi.type),
                  Text(
                    poi.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        // Aircraft Layer
        if (widget.currentLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: widget.currentLocation!,
                width: 40,
                height: 40,
                child: Transform.rotate(
                  angle: (widget.heading ?? 0) * (3.14159 / 180),
                  child: const Icon(
                    Icons.flight,
                    color: Colors.white,
                    size: 32,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _getPoiIcon(PoiType type) {
    switch (type) {
      case PoiType.city:
        return const Icon(Icons.location_city, color: Colors.amber, size: 20);
      case PoiType.mountain:
        return const Icon(Icons.landscape, color: Colors.brown, size: 20);
      case PoiType.river:
        return const Icon(Icons.waves, color: Colors.blue, size: 20);
      case PoiType.airport:
        return const Icon(Icons.local_airport, color: Colors.green, size: 20);
    }
  }
}
