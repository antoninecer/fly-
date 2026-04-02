import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong2.dart';
import '../../../data/db/app_database.dart';
import '../../../data/services/demo_data_service.dart';
import '../../../data/services/poi_service.dart';
import '../../../map/widgets/live_map.dart';

class ReplayScreen extends StatefulWidget {
  const ReplayScreen({super.key});

  @override
  State<ReplayScreen> createState() => _ReplayScreenState();
}

class _ReplayScreenState extends State<ReplayScreen> {
  late AppDatabase _db;
  late PoiService _poiService;
  List<TrackPoint> _allPoints = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  double _speedMultiplier = 1.0;
  Timer? _timer;
  String? _poiAlert;

  final List<String> _mbtilesPaths = [
    'data/maps/source/world_base_z4_z5.mbtiles',
    'data/maps/source/europe_detail_z6_z7.mbtiles',
  ];

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _poiService = PoiService();
    _initData();
  }

  Future<void> _initData() async {
    await _poiService.loadBasePois();
    final demoService = DemoDataService(_db);
    await demoService.seedPragueToNaples();
    
    final points = await (_db.select(_db.trackPoints)
          ..where((t) => t.sessionId.equals('demo-prague-naples'))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .get();

    if (mounted) {
      setState(() {
        _allPoints = points;
      });
    }
  }

  void _checkContext(LatLng location) {
    final nearby = _poiService.getNearby(location, 50.0);
    if (nearby.isNotEmpty) {
      final closest = nearby.first;
      if (_poiAlert != closest.name) {
        setState(() {
          _poiAlert = closest.name;
        });
      }
    } else {
      if (_poiAlert != null) {
        setState(() {
          _poiAlert = null;
        });
      }
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
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_currentIndex < _allPoints.length - 1) {
        setState(() {
          _currentIndex++;
          final p = _allPoints[_currentIndex];
          _checkContext(LatLng(p.lat, p.lon));
        });
      } else {
        setState(() {
          _isPlaying = false;
          _timer?.cancel();
        });
      }
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
    if (_allPoints.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentPoint = _allPoints[_currentIndex];
    final currentLocation = LatLng(currentPoint.lat, currentPoint.lon);
    final track = _allPoints.take(_currentIndex + 1).map((p) => LatLng(p.lat, p.lon)).toList();

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
            ),
          ),

          if (_poiAlert != null)
            Positioned(
              top: 140,
              left: 12,
              right: 12,
              child: _PoiAlertBadge(name: _poiAlert!),
            ),

          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: _ReplayTopBar(
              title: 'Prague → Naples',
              status: _isPlaying ? 'Playing ${_speedMultiplier.toInt()}x' : 'Paused',
            ),
          ),

          Positioned(
            top: 76,
            left: 12,
            child: _ReplayCornerInfoBadge(
              title: 'SPD',
              value: '${currentPoint.speedKmh.toInt()} km/h',
              alignRight: false,
            ),
          ),
          Positioned(
            top: 76,
            right: 12,
            child: _ReplayCornerInfoBadge(
              title: 'ALT',
              value: '${currentPoint.altMeters.toInt()} m',
              alignRight: true,
            ),
          ),

          Positioned(
            left: 12,
            right: 12,
            bottom: 16,
            child: _ReplayBottomOverlay(
              scrubValue: _currentIndex.toDouble(),
              maxScrubValue: (_allPoints.length - 1).toDouble(),
              isPlaying: _isPlaying,
              speedLabel: '${_speedMultiplier.toInt()}x',
              onScrubChanged: (value) {
                setState(() {
                  _currentIndex = value.toInt();
                  _checkContext(LatLng(_allPoints[_currentIndex].lat, _allPoints[_currentIndex].lon));
                });
              },
              onPlayToggle: _togglePlay,
              onSpeedToggle: () => setState(() => _speedMultiplier = (_speedMultiplier % 10) + 1),
              onSkipBack: () => setState(() => _currentIndex = (_currentIndex - 10).clamp(0, _allPoints.length - 1)),
              onSkipForward: () => setState(() => _currentIndex = (_currentIndex + 10).clamp(0, _allPoints.length - 1)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PoiAlertBadge extends StatelessWidget {
  final String name;
  const _PoiAlertBadge({required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.amber.withValues(alpha: 0.9),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                'Blížíte se k: $name',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReplayTopBar extends StatelessWidget {
  final String title;
  final String status;
  const _ReplayTopBar({required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withValues(alpha: 0.7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.play_circle, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
            Text(status, style: const TextStyle(color: Colors.white70)),
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
      color: Colors.black.withValues(alpha: 0.7),
      child: Container(
        constraints: const BoxConstraints(minWidth: 100),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white60, fontSize: 10)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
      color: Colors.black.withValues(alpha: 0.7),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: scrubValue,
              max: maxScrubValue,
              onChanged: onScrubChanged,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: onSkipBack, icon: const Icon(Icons.replay_10)),
                IconButton(
                  onPressed: onPlayToggle,
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 32,
                ),
                IconButton(onPressed: onSkipForward, icon: const Icon(Icons.forward_10)),
                const SizedBox(width: 20),
                ActionChip(
                  label: Text(speedLabel),
                  onPressed: onSpeedToggle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
