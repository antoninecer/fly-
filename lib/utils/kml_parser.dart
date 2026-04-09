import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/db/app_database.dart';
import '../../../data/models/poi.dart';
import '../../../data/services/asset_service.dart';
import '../../../data/services/poi_service.dart';
import '../../../data/services/vector_data_service.dart';
import '../../../map/widgets/live_map.dart';
import '../../../shared/widgets/underflight_info_card.dart';

class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key});

  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {
  final AssetService _assetService = AssetService();
  final PoiService _poiService = PoiService();
  final VectorDataService _vectorService = VectorDataService();
  final Distance _distance = const Distance();

  late final AppDatabase _db;
  StreamSubscription<Session?>? _activeFlightSub;
  Timer? _clockTimer;

  List<String> _mbtilesPaths = [];
  bool _initialized = false;

  int leftInfoIndex = 0;
  int rightInfoIndex = 0;

  Poi? _selectedPoi;
  Session? _activeFlight;

  String _fromName = 'Unknown';
  String _toName = 'Unknown';
  String _status = 'No active flight';

  LatLng? _currentLocation;
  double _currentSpeedKmh = 0;
  double _currentAltitudeM = 0;
  double _routeDeviationKm = 0;
  String _elapsed = '00:00';
  String _remaining = '--:--';
  String _eta = '--:--';
  String _startsIn = '--:--';

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _initData();
    _watchActiveFlight();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      _refreshDerivedTimeInfo();
    });
  }

  Future<void> _initData() async {
    final paths = await _assetService.initializeAssets();
    await _poiService.loadBasePois();
    await _vectorService.loadAll();

    if (!mounted) return;

    setState(() {
      _mbtilesPaths = paths;
      _initialized = true;
    });
  }

  void _watchActiveFlight() {
    _activeFlightSub?.cancel();

    _activeFlightSub = (_db.select(_db.sessions)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.startedAt)])
          ..limit(1))
        .watchSingleOrNull()
        .listen((session) {
      if (!mounted) return;

      setState(() {
        _activeFlight = session;
        _fromName = session?.fromName ?? 'Unknown';
        _toName = session?.toName ?? 'Unknown';
        _status = _buildFlightStatus(session);

        final hasFromCoords =
            session?.fromLat != null && session?.fromLon != null;
        if (_currentLocation == null && hasFromCoords) {
          _currentLocation = LatLng(session!.fromLat!, session.fromLon!);
        }
      });

      _refreshDerivedTimeInfo();
    });
  }

  String _buildFlightStatus(Session? session) {
    if (session == null) return 'No active flight';

    final now = DateTime.now();
    final diff = session.startedAt.difference(now);

    if (diff.inSeconds > 0) {
      return 'Planned';
    }

    if (_currentSpeedKmh > 45) {
      return 'Recording';
    }

    return 'Armed';
  }

  void _refreshDerivedTimeInfo() {
    final session = _activeFlight;
    final now = DateTime.now();

    if (session == null) {
      if (!mounted) return;
      setState(() {
        _elapsed = '00:00';
        _remaining = '--:--';
        _eta = '--:--';
        _startsIn = '--:--';
        _status = 'No active flight';
      });
      return;
    }

    final start = session.startedAt;
    final diff = start.difference(now);

    String elapsed = '00:00';
    String remaining = '--:--';
    String eta = _formatClock(start);
    String startsIn = '--:--';

    if (diff.inSeconds > 0) {
      startsIn = _formatDurationShort(diff);
      remaining = startsIn;
      elapsed = '00:00';
    } else {
      final flown = now.difference(start);
      elapsed = _formatDurationShort(flown);

      if (session.durationSec > 0) {
        final remain =
            Duration(seconds: session.durationSec) - flown;
        remaining = remain.isNegative
            ? '00:00'
            : _formatDurationShort(remain);

        final endTime = start.add(Duration(seconds: session.durationSec));
        eta = _formatClock(endTime);
      }
    }

    if (!mounted) return;
    setState(() {
      _elapsed = elapsed;
      _remaining = remaining;
      _eta = eta;
      _startsIn = startsIn;
      _status = _buildFlightStatus(session);
    });
  }

  void _cycleLeftInfo() {
    setState(() {
      leftInfoIndex = (leftInfoIndex + 1) % 3;
    });
  }

  void _cycleRightInfo() {
    setState(() {
      rightInfoIndex = (rightInfoIndex + 1) % 5;
    });
  }

  void _handlePoiSelected(Poi? poi) {
    if (!mounted) return;
    setState(() {
      _selectedPoi = poi;
    });
  }

  double _selectedPoiDistanceKm() {
    final poi = _selectedPoi;
    final currentLocation = _currentLocation;
    if (poi == null || currentLocation == null) return 0.0;
    return _distance.as(LengthUnit.Kilometer, currentLocation, poi.location);
  }

  Map<String, String> _leftInfo() {
    switch (leftInfoIndex) {
      case 0:
        return {
          'label': 'SPD',
          'value': '${_currentSpeedKmh.toStringAsFixed(0)} km/h',
        };
      case 1:
        return {
          'label': 'ALT',
          'value': '${_currentAltitudeM.toStringAsFixed(0)} m',
        };
      case 2:
        if (_currentLocation == null) {
          return {'label': 'GPS', 'value': 'No fix'};
        }
        return {
          'label': 'GPS',
          'value':
              '${_currentLocation!.latitude.toStringAsFixed(3)}, ${_currentLocation!.longitude.toStringAsFixed(3)}',
        };
      default:
        return {'label': 'GPS', 'value': 'No fix'};
    }
  }

  Map<String, String> _rightInfo() {
    switch (rightInfoIndex) {
      case 0:
        return {'label': 'STARTS IN', 'value': _startsIn};
      case 1:
        return {'label': 'ELAPSED', 'value': _elapsed};
      case 2:
        return {'label': 'REMAIN', 'value': _remaining};
      case 3:
        return {'label': 'ETA', 'value': _eta};
      case 4:
        return {
          'label': 'DEV',
          'value': '${_routeDeviationKm.toStringAsFixed(1)} km',
        };
      default:
        return {'label': 'STARTS IN', 'value': _startsIn};
    }
  }

  String _formatDurationShort(Duration d) {
    final totalSec = d.inSeconds.abs();
    final h = totalSec ~/ 3600;
    final m = (totalSec % 3600) ~/ 60;
    final s = totalSec % 60;

    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _formatClock(DateTime dt) {
    final local = dt.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  @override
  void dispose() {
    _activeFlightSub?.cancel();
    _clockTimer?.cancel();
    _db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leftInfo = _leftInfo();
    final rightInfo = _rightInfo();

    final LatLng fallbackCenter = _currentLocation ??
        (_activeFlight?.fromLat != null && _activeFlight?.fromLon != null
            ? LatLng(_activeFlight!.fromLat!, _activeFlight!.fromLon!)
            : const LatLng(20.0, 0.0));

    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: _initialized
                ? LiveMap(
                    mbtilesPaths: _mbtilesPaths,
                    initialCenter: fallbackCenter,
                    initialZoom: 4.5,
                    currentLocation: _currentLocation,
                    heading: 0,
                    pois: _poiService.allPois,
                    borders: _vectorService.borders,
                    rivers: _vectorService.rivers,
                    autoCenter: true,
                    onPoiSelected: _handlePoiSelected,
                  )
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          ),
          if (_selectedPoi != null)
            Positioned(
              right: 12,
              bottom: 160,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPoi = null;
                  });
                },
                child: UnderflightInfoCard(
                  poi: _selectedPoi!,
                  distanceKm: _selectedPoiDistanceKm(),
                ),
              ),
            ),
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Row(
              children: [
                Expanded(
                  child: _TopRouteBar(
                    from: _fromName,
                    to: _toName,
                    status: _status,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 76,
            left: 12,
            child: GestureDetector(
              onTap: _cycleLeftInfo,
              child: _CornerInfoBadge(
                title: leftInfo['label']!,
                value: leftInfo['value']!,
                alignRight: false,
              ),
            ),
          ),
          Positioned(
            top: 76,
            right: 12,
            child: GestureDetector(
              onTap: _cycleRightInfo,
              child: _CornerInfoBadge(
                title: rightInfo['label']!,
                value: rightInfo['value']!,
                alignRight: true,
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 16,
            child: const _BottomFlightOverlay(),
          ),
        ],
      ),
    );
  }
}

class _TopRouteBar extends StatelessWidget {
  final String from;
  final String to;
  final String status;

  const _TopRouteBar({
    required this.from,
    required this.to,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withValues(alpha: 0.70),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.flight, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$from → $to',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              status,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _CornerInfoBadge extends StatelessWidget {
  final String title;
  final String value;
  final bool alignRight;

  const _CornerInfoBadge({
    required this.title,
    required this.value,
    required this.alignRight,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withValues(alpha: 0.70),
      child: Container(
        constraints: const BoxConstraints(minWidth: 110),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment:
              alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 11,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomFlightOverlay extends StatelessWidget {
  const _BottomFlightOverlay();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withValues(alpha: 0.72),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: null,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start'),
            ),
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.stop),
              label: const Text('Stop'),
            ),
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.center_focus_strong),
              label: const Text('Center'),
            ),
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.layers),
              label: const Text('Layers'),
            ),
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.battery_saver),
              label: const Text('Saver'),
            ),
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.share_location),
              label: const Text('Share'),
            ),
          ],
        ),
      ),
    );
  }
}