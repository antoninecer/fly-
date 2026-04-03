import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../data/db/app_database.dart';
import '../../../data/services/tracker_service.dart';
import '../../../data/services/asset_service.dart';
import '../../../data/services/poi_service.dart';
import '../../../data/services/vector_data_service.dart';
import '../../../map/widgets/live_map.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  late AppDatabase _db;
  late TrackerService _trackerService;
  late AssetService _assetService;
  late PoiService _poiService;
  late VectorDataService _vectorService;
  
  List<String> _mbtilesPaths = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _trackerService = TrackerService(_db);
    _assetService = AssetService();
    _poiService = PoiService();
    _vectorService = VectorDataService();
    _init();
  }

  Future<void> _init() async {
    final paths = await _assetService.initializeAssets();
    await _poiService.loadBasePois();
    await _vectorService.loadAll();
    
    if (mounted) {
      setState(() {
        _mbtilesPaths = paths;
        _initialized = true;
      });
    }
  }

  @override
  void dispose() {
    _trackerService.dispose();
    _db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _trackerService,
      builder: (context, _) {
        final pos = _trackerService.currentLatLng;

        return SafeArea(
          child: Stack(
            children: [
              // 1. Map Layer
              Positioned.fill(
                child: _initialized 
                  ? LiveMap(
                      mbtilesPaths: _mbtilesPaths,
                      initialCenter: pos ?? const LatLng(50.087, 14.421),
                      initialZoom: 7, // High detail for tracker
                      currentLocation: pos,
                      heading: _trackerService.currentPosition?.heading,
                      pois: _poiService.allPois,
                      borders: _vectorService.borders,
                      rivers: _vectorService.rivers,
                      autoCenter: true,
                    )
                  : const Center(child: CircularProgressIndicator()),
              ),

              // 2. Status & Telemetry Overlay
              Positioned(
                top: 12, left: 12, right: 12,
                child: _TrackerStatusHeader(service: _trackerService),
              ),

              // 3. Bottom Action Panel
              Positioned(
                bottom: 16, left: 12, right: 12,
                child: _TrackerControls(service: _trackerService),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TrackerStatusHeader extends StatelessWidget {
  final TrackerService service;
  const _TrackerStatusHeader({required this.service});

  @override
  Widget build(BuildContext context) {
    final pos = service.currentPosition;
    final bool active = service.mode != TrackerMode.idle;

    return Card(
      color: Colors.black.withValues(alpha: 0.75),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _statusIndicator(service.mode),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.isRecording ? 'BLACKBOX RECORDING' : (service.isWatching ? 'ONLINE WATCHING' : 'TRACKER IDLE'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                  ),
                  if (active && pos != null)
                    Text(
                      '${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)} · Alt: ${pos.altitude.toInt()}m',
                      style: const TextStyle(color: Colors.white54, fontSize: 10),
                    ),
                ],
              ),
            ),
            if (active && pos != null)
              _telemetryBadge('SPD', '${(pos.speed * 3.6).toInt()}'),
          ],
        ),
      ),
    );
  }

  Widget _statusIndicator(TrackerMode mode) {
    Color color = Colors.grey;
    if (mode == TrackerMode.watching) color = Colors.blueAccent;
    if (mode == TrackerMode.recording) color = Colors.redAccent;

    return Container(
      width: 10, height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _telemetryBadge(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 8, color: Colors.white54)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ],
    );
  }
}

class _TrackerControls extends StatelessWidget {
  final TrackerService service;
  const _TrackerControls({required this.service});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (service.mode == TrackerMode.idle)
          _actionButton(
            label: 'START WATCHING',
            icon: Icons.visibility,
            color: Colors.blueAccent,
            onTap: () => service.startWatching(),
          ),
        if (service.mode == TrackerMode.watching)
          Row(
            children: [
              _actionButton(
                label: 'START RECORD',
                icon: Icons.fiber_manual_record,
                color: Colors.redAccent,
                onTap: () => service.startRecording(),
              ),
              const SizedBox(width: 12),
              _actionButton(
                label: 'STOP',
                icon: Icons.stop,
                color: Colors.grey,
                onTap: () => service.stop(),
              ),
            ],
          ),
        if (service.mode == TrackerMode.recording)
          _actionButton(
            label: 'STOP & SAVE BLACKBOX',
            icon: Icons.stop_circle,
            color: Colors.redAccent,
            onTap: () => service.stop(),
          ),
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return FilledButton.icon(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
