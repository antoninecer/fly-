import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../data/services/asset_service.dart';
import '../../../data/services/poi_service.dart';
import '../../../data/services/vector_data_service.dart';
import '../../../map/widgets/live_map.dart';

class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key});

  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {
  final AssetService _assetService = AssetService();
  final PoiService _poiService = PoiService();
  final VectorDataService _vectorService = VectorDataService();

  List<String> _mbtilesPaths = [];
  bool _initialized = false;

  int leftInfoIndex = 0;
  int rightInfoIndex = 0;

  // Temporary dynamic state until flight import / GPS session is wired in
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

  @override
  void initState() {
    super.initState();
    _initData();
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

  void _cycleLeftInfo() {
    setState(() {
      leftInfoIndex = (leftInfoIndex + 1) % 3;
    });
  }

  void _cycleRightInfo() {
    setState(() {
      rightInfoIndex = (rightInfoIndex + 1) % 4;
    });
  }

  Map<String, String> _leftInfo() {
    switch (leftInfoIndex) {
      case 0:
        return {'label': 'SPD', 'value': '${_currentSpeedKmh.toStringAsFixed(0)} km/h'};
      case 1:
        return {'label': 'ALT', 'value': '${_currentAltitudeM.toStringAsFixed(0)} m'};
      case 2:
        if (_currentLocation == null) {
          return {'label': 'GPS', 'value': 'No fix'};
        }
        return {
          'label': 'GPS',
          'value':
              '${_currentLocation!.latitude.toStringAsFixed(3)}, ${_currentLocation!.longitude.toStringAsFixed(3)}'
        };
      default:
        return {'label': 'GPS', 'value': 'No fix'};
    }
  }

  Map<String, String> _rightInfo() {
    switch (rightInfoIndex) {
      case 0:
        return {'label': 'ELAPSED', 'value': _elapsed};
      case 1:
        return {'label': 'REMAIN', 'value': _remaining};
      case 2:
        return {'label': 'ETA', 'value': _eta};
      case 3:
        return {'label': 'DEV', 'value': '${_routeDeviationKm.toStringAsFixed(1)} km'};
      default:
        return {'label': 'ELAPSED', 'value': _elapsed};
    }
  }

  @override
  Widget build(BuildContext context) {
    final leftInfo = _leftInfo();
    final rightInfo = _rightInfo();

    final LatLng fallbackCenter = _currentLocation ?? const LatLng(20.0, 0.0);

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
                  )
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(),
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
            child: _BottomFlightOverlay(),
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