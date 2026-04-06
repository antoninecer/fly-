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
  final List<Polygon> lakes;

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
    this.lakes = const [],
    this.autoCenter = true,
  });

  @override
  State<LiveMap> createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  late final MbTilesTileProvider _tileProvider;
  late final MapController _mapController;

  double _currentZoom = 5;

  bool _mapReady = false;
  LatLng? _pendingCenter;

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
      if (_mapReady) {
        _mapController.move(widget.currentLocation!, _currentZoom);
      } else {
        _pendingCenter = widget.currentLocation!;
      }
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
      _showRivers = false;
      _showPois = false;
    } else if (zoom < 7) {
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
    if (!_mapReady) return;

    final nextZoom = (_currentZoom + 1).clamp(4.0, 10.0);
    _mapController.move(_mapController.camera.center, nextZoom);

    setState(() {
      _currentZoom = nextZoom;
      if (_layerMode == 0) {
        _applyZoomPreset(_currentZoom);
      }
    });
  }

  void _zoomOut() {
    if (!_mapReady) return;

    final nextZoom = (_currentZoom - 1).clamp(4.0, 10.0);
    _mapController.move(_mapController.camera.center, nextZoom);

    setState(() {
      _currentZoom = nextZoom;
      if (_layerMode == 0) {
        _applyZoomPreset(_currentZoom);
      }
    });
  }

  LatLngBounds? _expandedBoundsOrNull() {
    if (!_mapReady) return null;

    final bounds = _mapController.camera.visibleBounds;

    const padLat = 0.8;
    const padLon = 0.8;

    return LatLngBounds(
      LatLng(
        bounds.southWest.latitude - padLat,
        bounds.southWest.longitude - padLon,
      ),
      LatLng(
        bounds.northEast.latitude + padLat,
        bounds.northEast.longitude + padLon,
      ),
    );
  }

  bool _isPointVisible(LatLng point, LatLngBounds bounds) {
    final lat = point.latitude;
    final lon = point.longitude;

    final inLat =
        lat >= bounds.southWest.latitude && lat <= bounds.northEast.latitude;
    final inLon =
        lon >= bounds.southWest.longitude && lon <= bounds.northEast.longitude;

    return inLat && inLon;
  }

int _peakMinAltitude() {
  if (_currentZoom >= 10) return 1400;
  if (_currentZoom >= 9.5) return 1600;
  if (_currentZoom >= 9) return 1800;
  if (_currentZoom >= 8) return 2100;
  if (_currentZoom >= 7) return 2400;
  if (_currentZoom >= 6) return 2800;
  return 3400;
}

  int _cityMinPopulation() {
    if (_currentZoom >= 10) return 10000;
    if (_currentZoom >= 9.5) return 18000;
    if (_currentZoom >= 9) return 25000;
    if (_currentZoom >= 8) return 80000;
    if (_currentZoom >= 7) return 200000;
    if (_currentZoom >= 6) return 500000;
    return 999999999;
  }

  List<Poi> _reducePeaksByGrid(List<Poi> peaks) {
    if (_currentZoom >= 9.5) return peaks;

    final Map<String, Poi> bestPerCell = {};

    final double cellSize = _currentZoom >= 9
        ? 0.22
        : _currentZoom >= 8
            ? 0.35
            : _currentZoom >= 7
                ? 0.60
                : _currentZoom >= 6
                    ? 1.0
                    : 1.8;

    for (final peak in peaks) {
      final latCell = (peak.location.latitude / cellSize).floor();
      final lonCell = (peak.location.longitude / cellSize).floor();
      final key = '$latCell:$lonCell';

      final existing = bestPerCell[key];
      if (existing == null ||
          (peak.altitude ?? 0) > (existing.altitude ?? 0)) {
        bestPerCell[key] = peak;
      }
    }

    return bestPerCell.values.toList();
  }

  List<Poi> _reduceCitiesByGrid(List<Poi> cities) {
    if (_currentZoom >= 10) return cities;

    final Map<String, Poi> bestPerCell = {};

    final double cellSize = _currentZoom >= 9.5
        ? 0.12
        : _currentZoom >= 9
            ? 0.18
            : _currentZoom >= 8
                ? 0.32
                : _currentZoom >= 7
                    ? 0.55
                    : 0.9;

    for (final city in cities) {
      final latCell = (city.location.latitude / cellSize).floor();
      final lonCell = (city.location.longitude / cellSize).floor();
      final key = '$latCell:$lonCell';

      final existing = bestPerCell[key];
      if (existing == null ||
          (city.population ?? 0) > (existing.population ?? 0)) {
        bestPerCell[key] = city;
      }
    }

    return bestPerCell.values.toList();
  }

  List<Poi> get _visiblePeaks {
    final bounds = _expandedBoundsOrNull();
    if (bounds == null) return const [];

    final minAltitude = _peakMinAltitude();

    final peaks = widget.pois.where((p) {
      return p.type == PoiType.mountain &&
          (p.altitude ?? 0) >= minAltitude &&
          _isPointVisible(p.location, bounds);
    }).toList();

    return _reducePeaksByGrid(peaks);
  }

  List<Poi> get _visibleCities {
    final bounds = _expandedBoundsOrNull();
    if (bounds == null) return const [];

    final minPopulation = _cityMinPopulation();

    final cities = widget.pois.where((p) {
      return p.type == PoiType.city &&
          (p.population ?? 0) >= minPopulation &&
          _isPointVisible(p.location, bounds);
    }).toList();

    return _reduceCitiesByGrid(cities);
  }

  bool _showPeakLabels() => _currentZoom >= 7.8;
  bool _showPeakAltitude() => _currentZoom >= 8.8;
  bool _showCityLabels() => _currentZoom >= 7.4;

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
            maxZoom: 10,
            onMapReady: () {
              _mapReady = true;

              if (_pendingCenter != null) {
                _mapController.move(_pendingCenter!, _currentZoom);
                _pendingCenter = null;
              }
            },
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
            if (_currentZoom >= 5 && widget.lakes.isNotEmpty)
              PolygonLayer(
                polygons: widget.lakes,
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
            if (_showPois && _currentZoom >= 5)
              MarkerLayer(
                markers: _visiblePeaks.map((poi) {
                  final showLabel = _showPeakLabels();
                  return Marker(
                    point: poi.location,
                    width: showLabel ? 76 : 16,
                    height: showLabel ? 42 : 16,
                    child: _PoiMarker(
                      icon: _getPoiIcon(poi.type),
                      label: showLabel
                          ? (_showPeakAltitude() && poi.altitude != null
                              ? '${poi.name} ${poi.altitude!.toInt()} m'
                              : poi.name)
                          : null,
                      fontSize: 8,
                      maxLines: 2,
                    ),
                  );
                }).toList(),
              ),
            if (_showPois && _currentZoom >= 6)
              MarkerLayer(
                markers: _visibleCities.map((poi) {
                  final showLabel = _showCityLabels();
                  return Marker(
                    point: poi.location,
                    width: showLabel ? 74 : 18,
                    height: showLabel ? 34 : 18,
                    child: _PoiMarker(
                      icon: _getPoiIcon(poi.type),
                      label: showLabel ? poi.name : null,
                      fontSize: 8,
                      maxLines: 1,
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
        return const Icon(Icons.location_city, color: Colors.amber, size: 12);
      case PoiType.mountain:
        return const Icon(Icons.terrain, color: Colors.orange, size: 10);
      case PoiType.river:
        return const Icon(Icons.waves, color: Colors.blue, size: 12);
      case PoiType.airport:
        return const Icon(Icons.local_airport, color: Colors.green, size: 12);
    }
  }
}

class _PoiMarker extends StatelessWidget {
  final Widget icon;
  final String? label;
  final double fontSize;
  final int maxLines;

  const _PoiMarker({
    required this.icon,
    required this.label,
    required this.fontSize,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    if (label == null || label!.isEmpty) {
      return Center(child: icon);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(height: 1),
        Flexible(
          child: Text(
            label!,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              height: 1.0,
              shadows: const [
                Shadow(blurRadius: 4, color: Colors.black),
              ],
            ),
            textAlign: TextAlign.center,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}