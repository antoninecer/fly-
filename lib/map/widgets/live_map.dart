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

  bool _showBorders = true;
  bool _showRivers = true;
  bool _showPois = true;

  int _layerMode = 0;

  @override
  void initState() {
    super.initState();
    _tileProvider = MbTilesTileProvider(paths: widget.mbtilesPaths);
    _mapController = MapController();
    _currentZoom = widget.initialZoom;
    _applyZoomPreset(_currentZoom);
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

  void _applyZoomPreset(double zoom) {
    if (zoom < 5) {
      _showBorders = false;
      _showRivers = false;
      _showPois = false;
    } else if (zoom < 6) {
      _showBorders = true;
      _showRivers = true;
      _showPois = false;
    } else {
      _showBorders = true;
      _showRivers = true;
      _showPois = true;
    }
  }

  void _cycleLayers() {
    setState(() {
      _layerMode = (_layerMode + 1) % 5;

      switch (_layerMode) {
        case 0:
          _applyZoomPreset(_currentZoom);
          break;
        case 1:
          _showBorders = true;
          _showRivers = true;
          _showPois = true;
          break;
        case 2:
          _showBorders = true;
          _showRivers = true;
          _showPois = false;
          break;
        case 3:
          _showBorders = true;
          _showRivers = false;
          _showPois = false;
          break;
        case 4:
          _showBorders = false;
          _showRivers = false;
          _showPois = false;
          break;
      }
    });
  }

  String _layerLabel() {
    switch (_layerMode) {
      case 0:
        return 'AUTO';
      case 1:
        return 'ALL';
      case 2:
        return 'MAP+R';
      case 3:
        return 'MAP';
      case 4:
        return 'OFF';
      default:
        return 'AUTO';
    }
  }

  void _zoomIn() {
    final nextZoom = (_currentZoom + 1).clamp(4.0, 9.0);
    _mapController.move(_mapController.camera.center, nextZoom);
    setState(() {
      _currentZoom = nextZoom;
      if (_layerMode == 0) {
        _applyZoomPreset(_currentZoom);
      }
    });
  }

  void _zoomOut() {
    final nextZoom = (_currentZoom - 1).clamp(4.0, 9.0);
    _mapController.move(_mapController.camera.center, nextZoom);
    setState(() {
      _currentZoom = nextZoom;
      if (_layerMode == 0) {
        _applyZoomPreset(_currentZoom);
      }
    });
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
            minZoom: 4,
            maxZoom: 9,
            onPositionChanged: (camera, hasGesture) {
              if (!mounted) return;
              setState(() {
                _currentZoom = camera.zoom;
                if (_layerMode == 0) {
                  _applyZoomPreset(_currentZoom);
                }
              });
            },
          ),
          children: [
            TileLayer(
              tileProvider: _tileProvider,
              maxNativeZoom: 7,
            ),
            if (_showBorders && _currentZoom >= 5)
              PolylineLayer(
                polylines: widget.borders,
              ),
            if (_showRivers && _currentZoom >= 5)
              PolylineLayer(
                polylines: widget.rivers,
              ),
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
                            shadows: [
                              Shadow(blurRadius: 4, color: Colors.black),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
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
                        shadows: [
                          Shadow(blurRadius: 10, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        Positioned(
          top: 138,
          right: 12,
          child: Column(
            children: [
              FloatingActionButton.small(
                heroTag: 'layers_cycle',
                onPressed: _cycleLayers,
                backgroundColor: Colors.black87,
                child: const Icon(Icons.layers, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _layerLabel(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    IconButton(
                      onPressed: _zoomIn,
                      icon: const Icon(Icons.add, color: Colors.white),
                      visualDensity: VisualDensity.compact,
                    ),
                    Container(
                      width: 32,
                      height: 1,
                      color: Colors.white24,
                    ),
                    IconButton(
                      onPressed: _zoomOut,
                      icon: const Icon(Icons.remove, color: Colors.white),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Z ${_currentZoom.toStringAsFixed(1)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getPoiIcon(PoiType type) {
    switch (type) {
      case PoiType.city:
        return const Icon(
          Icons.location_city,
          color: Colors.amber,
          size: 20,
        );
      case PoiType.mountain:
        return const Icon(
          Icons.landscape,
          color: Colors.brown,
          size: 20,
        );
      case PoiType.river:
        return const Icon(
          Icons.waves,
          color: Colors.blue,
          size: 20,
        );
      case PoiType.airport:
        return const Icon(
          Icons.local_airport,
          color: Colors.green,
          size: 20,
        );
    }
  }
}