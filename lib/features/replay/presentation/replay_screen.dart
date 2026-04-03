import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong2.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import '../../../data/db/app_database.dart';
import '../../../data/services/demo_data_service.dart';
import '../../../data/services/poi_service.dart';
import '../../../data/services/context_engine.dart';
import '../../../data/services/vector_data_service.dart';
import '../../../data/services/asset_service.dart';
import '../../../map/widgets/live_map.dart';
import '../../../shared/widgets/underflight_info_card.dart';

class ReplayScreen extends StatefulWidget {
  final String? sessionId; // Allow playing specific session

  const ReplayScreen({super.key, this.sessionId});

  @override
  State<ReplayScreen> createState() => _ReplayScreenState();
}

class _ReplayScreenState extends State<ReplayScreen> {
  late AppDatabase _db;
  late PoiService _poiService;
  late VectorDataService _vectorService;
  late AssetService _assetService;
  ContextEngine? _contextEngine;
  
  List<TrackPoint> _allPoints = [];
  int _currentIndex = 0;
  double _virtualTimeOffsetSec = 0; // Current playback time in seconds from start
  
  bool _isPlaying = false;
  double _speedMultiplier = 1.0;
  Timer? _timer;
  List<String> _mbtilesPaths = [];
  bool _initialized = false;

  final DateFormat _timeFormat = DateFormat('HH:mm:ss');
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _poiService = PoiService();
    _vectorService = VectorDataService();
    _assetService = AssetService();
    _initData();
  }

  Future<void> _initData() async {
    final paths = await _assetService.initializeAssets();
    await _poiService.loadBasePois();
    await _vectorService.loadAll();
    _contextEngine = ContextEngine(pois: _poiService.allPois);

    final String targetSessionId = widget.sessionId ?? 'demo-prague-naples';
    
    if (targetSessionId == 'demo-prague-naples') {
      final demoService = DemoDataService(_db);
      await demoService.seedPragueToNaples();
    }
    
    final points = await (_db.select(_db.trackPoints)
          ..where((t) => t.sessionId.equals(targetSessionId))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.timestamp)]))
        .get();

    if (mounted) {
      setState(() {
        _mbtilesPaths = paths;
        _allPoints = points;
        _initialized = true;
      });
    }
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    const tickMs = 100; // Update every 100ms
    _timer = Timer.periodic(const Duration(milliseconds: tickMs), (timer) {
      if (_allPoints.isEmpty) return;

      final totalDurationSec = _allPoints.last.timestamp.difference(_allPoints.first.timestamp).inSeconds;
      
      setState(() {
        // Increase virtual time based on multiplier
        _virtualTimeOffsetSec += (tickMs / 1000.0) * _speedMultiplier;

        if (_virtualTimeOffsetSec >= totalDurationSec) {
          _virtualTimeOffsetSec = totalDurationSec.toDouble();
          _isPlaying = false;
          _timer?.cancel();
        }

        // Find closest point for this virtual time
        _currentIndex = _findClosestIndex(_virtualTimeOffsetSec);
        
        final p = _allPoints[_currentIndex];
        _updateContext(LatLng(p.lat, p.lon));
      });
    });
  }

  int _findClosestIndex(double offsetSec) {
    final startTime = _allPoints.first.timestamp;
    // Simple linear search or binary search could be used here. 
    // Since points are usually ordered, we can optimize.
    for (int i = _currentIndex; i < _allPoints.length; i++) {
      final pOffset = _allPoints[i].timestamp.difference(startTime).inSeconds;
      if (pOffset >= offsetSec) return i;
    }
    return _allPoints.length - 1;
  }

  void _updateContext(LatLng location) {
    if (_contextEngine == null) return;
    final ctx = _contextEngine!.update(location);
    if (ctx != _activeContext) {
      setState(() {
        _activeContext = ctx;
      });
    }
  }

  void _changeSpeed() {
    setState(() {
      if (_speedMultiplier == 1.0) _speedMultiplier = 2.0;
      else if (_speedMultiplier == 2.0) _speedMultiplier = 5.0;
      else if (_speedMultiplier == 5.0) _speedMultiplier = 10.0;
      else if (_speedMultiplier == 10.0) _speedMultiplier = 50.0; // Added 50x for long flights
      else _speedMultiplier = 1.0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _allPoints.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentPoint = _allPoints[_currentIndex];
    final currentLocation = LatLng(currentPoint.lat, currentPoint.lon);
    final track = _allPoints.take(_currentIndex + 1).map((p) => LatLng(p.lat, p.lon)).toList();
    
    final totalDuration = _allPoints.last.timestamp.difference(_allPoints.first.timestamp);
    final currentDuration = Duration(seconds: _virtualTimeOffsetSec.toInt());

    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: LiveMap(
              mbtilesPaths: _mbtilesPaths,
              initialCenter: currentLocation,
              initialZoom: 5,
              track: track,
              currentLocation: currentLocation,
              heading: currentPoint.headingDeg,
              pois: _poiService.allPois,
              borders: _vectorService.borders,
              rivers: _vectorService.rivers,
            ),
          ),

          if (_activeContext != null)
            Positioned(
              right: 12,
              bottom: 160,
              child: UnderflightInfoCard(
                poi: _activeContext!.poi,
                distanceKm: _activeContext!.distanceKm,
              ),
            ),

          // Top Info Bar - Added Date & Time
          Positioned(
            top: 12, left: 12, right: 12,
            child: _ReplayTopBar(
              title: '${_dateFormat.format(currentPoint.timestamp)} · ${_timeFormat.format(currentPoint.timestamp)}',
              status: _isPlaying ? 'PLAY ${_speedMultiplier.toInt()}x' : 'PAUSED',
            ),
          ),

          // Telemetry - Added GPS
          Positioned(
            top: 76, left: 12,
            child: _ReplayCornerInfoBadge(
              title: 'GPS / SPD',
              value: '${currentPoint.lat.toStringAsFixed(3)}, ${currentPoint.lon.toStringAsFixed(3)}\n${currentPoint.speedKmh.toInt()} km/h',
              alignRight: false,
            ),
          ),
          Positioned(
            top: 76, right: 12,
            child: _ReplayCornerInfoBadge(
              title: 'ALT / TIME',
              value: '${currentPoint.altMeters.toInt()} m\n+${_formatDuration(currentDuration)}',
              alignRight: true,
            ),
          ),

          // Controls
          Positioned(
            left: 12, right: 12, bottom: 16,
            child: _ReplayBottomOverlay(
              scrubValue: _virtualTimeOffsetSec,
              maxScrubValue: totalDuration.inSeconds.toDouble(),
              isPlaying: _isPlaying,
              speedLabel: '${_speedMultiplier.toInt()}x',
              onScrubChanged: (value) {
                setState(() {
                  _virtualTimeOffsetSec = value;
                  _currentIndex = _findClosestIndex(value);
                  _updateContext(LatLng(currentPoint.lat, currentPoint.lon));
                });
              },
              onPlayToggle: _togglePlay,
              onSpeedToggle: _changeSpeed,
              onSkipBack: () => setState(() {
                _virtualTimeOffsetSec = (_virtualTimeOffsetSec - 30).clamp(0, totalDuration.inSeconds.toDouble());
                _currentIndex = _findClosestIndex(_virtualTimeOffsetSec);
              }),
              onSkipForward: () => setState(() {
                _virtualTimeOffsetSec = (_virtualTimeOffsetSec + 30).clamp(0, totalDuration.inSeconds.toDouble());
                _currentIndex = _findClosestIndex(_virtualTimeOffsetSec);
              }),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    return d.toString().split('.').first.padLeft(8, "0");
  }
}

class _ReplayTopBar extends StatelessWidget {
  final String title;
  final String status;
  const _ReplayTopBar({required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withValues(alpha: 0.75),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.history, size: 18, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: status.contains('PLAY') ? Colors.green.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(status, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReplayCornerInfoBadge extends StatelessWidget {
  final String title;
  final String value;
  final bool alignRight;
  const _ReplayCornerInfoBadge({required this.title, required this.value, required this.alignRight});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withValues(alpha: 0.75),
      child: Container(
        constraints: const BoxConstraints(minWidth: 120),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 1)),
            const SizedBox(height: 2),
            Text(value, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.2),
              textAlign: alignRight ? TextAlign.right : TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReplayBottomOverlay extends StatelessWidget {
  final double scrubValue;
  final double maxScrubValue;
  final bool isPlaying;
  final String speedLabel;
  final ValueChanged<double> onScrubChanged;
  final VoidCallback onPlayToggle;
  final VoidCallback onSpeedToggle;
  final VoidCallback onSkipBack;
  final VoidCallback onSkipForward;

  const _ReplayBottomOverlay({
    required this.scrubValue,
    required this.maxScrubValue,
    required this.isPlaying,
    required this.speedLabel,
    required this.onScrubChanged,
    required this.onPlayToggle,
    required this.onSpeedToggle,
    required this.onSkipBack,
    required this.onSkipForward,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withValues(alpha: 0.8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: scrubValue,
              max: maxScrubValue,
              onChanged: onScrubChanged,
              activeColor: Colors.blueAccent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(onPressed: onSkipBack, icon: const Icon(Icons.replay_30)),
                IconButton(
                  onPressed: onPlayToggle,
                  icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                  iconSize: 48,
                  color: Colors.white,
                ),
                IconButton(onPressed: onSkipForward, icon: const Icon(Icons.forward_30)),
                const SizedBox(width: 10),
                ActionChip(
                  label: Text(speedLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: onSpeedToggle,
                  backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
