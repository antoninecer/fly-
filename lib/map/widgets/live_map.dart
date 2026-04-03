import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../sources/mbtiles_tile_provider.dart';
import '../../data/models/poi.dart';

class LiveMap extends StatefulWidget {
  final List<String> mbtilesPaths;
  final LatLng initialCenter;
  final double initialZoom;
  final List<LatLng>? track;
  final LatLng? currentLocation;
  final double? heading;
  final List<Poi> pois;
  final List<Polyline> borders;
  final List<Polyline> rivers;
  final bool autoCenter;

  const LiveMap({
    super.key,
    required this.mbtilesPaths,
    this.initialCenter = const LatLng(50.087, 14.421),
    this.initialZoom = 5,
    this.track,
    this.currentLocation,
    this.heading,
    this.pois = const [],
    this.borders = const [],
    this.rivers = const [],
    this.autoCenter = true,
  });

  @override
  State<LiveMap> createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  late final MbTilesTileProvider _tileProvider;
  late final MapController _mapController;
  double _currentZoom = 5;

  // Layer Visibility Toggles
  bool _showBorders = true;
  bool _showRivers = true;
  bool _showPois = true;

  @override
  void initState() {
    super.initState();
    _tileProvider = MbTilesTileProvider(paths: widget.mbtilesPaths);
    _mapController = MapController();
    _currentZoom = widget.initialZoom;
  }

  @override
  void didUpdateWidget(LiveMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoCenter && 
        widget.currentLocation != null && 
        widget.currentLocation != oldWidget.currentLocation) {
      _mapController.move(widget.currentLocation!, _currentZoom);
    }
  }

  @override
  void dispose() {
    _tileProvider.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: widget.initialCenter,
            initialZoom: widget.initialZoom,
            maxZoom: 18,
            minZoom: 2,
            onPositionChanged: (camera, hasGesture) {
              if (mounted) {
                setState(() {
                  _currentZoom = camera.zoom;
                });
              }
            },
          ),
          children: [
            // 1. Base MBTiles Layer (Smart switching inside provider)
            TileLayer(
              tileProvider: _tileProvider,
              maxNativeZoom: 7,
            ),

            // 2. Borders: Zoom 5+
            if (_showBorders && _currentZoom >= 5)
              PolylineLayer(
                polylines: widget.borders,
              ),

            // 3. Rivers: Zoom 6+
            if (_showRivers && _currentZoom >= 6)
              PolylineLayer(
                polylines: widget.rivers,
              ),

            // 4. Track Path
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

            // 5. POIs: Zoom 6+ (Cities, Airports)
            if (_showPois && _currentZoom >= 6)
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

            // 6. Aircraft
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
        ),

        // Layer Toggle UI
        Positioned(
          top: 80,
          right: 12,
          child: Column(
            children: [
              _layerButton(Icons.map, _showBorders, () => setState(() => _showBorders = !_showBorders)),
              const SizedBox(height: 8),
              _layerButton(Icons.waves, _showRivers, () => setState(() => _showRivers = !_showRivers)),
              const SizedBox(height: 8),
              _layerButton(Icons.location_city, _showPois, () => setState(() => _showPois = !_showPois)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _layerButton(IconData icon, bool active, VoidCallback onTap) {
    return FloatingActionButton.small(
      onPressed: onTap,
      backgroundColor: active ? Colors.blueAccent : Colors.black87,
      child: Icon(icon, color: active ? Colors.white : Colors.white54),
    );
  }

  Widget _getPoiIcon(PoiType type) {
    switch (type) {
      case PoiType.city: return const Icon(Icons.location_city, color: Colors.amber, size: 20);
      case PoiType.mountain: return const Icon(Icons.landscape, color: Colors.brown, size: 20);
      case PoiType.river: return const Icon(Icons.waves, color: Colors.blue, size: 20);
      case PoiType.airport: return const Icon(Icons.local_airport, color: Colors.green, size: 20);
    }
  }
}
