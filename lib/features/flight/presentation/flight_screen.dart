import 'package:flutter/material.dart';

class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key});

  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {
  int leftInfoIndex = 0;
  int rightInfoIndex = 0;

  final List<Map<String, String>> leftInfoModes = const [
    {'label': 'SPD', 'value': '0 km/h'},
    {'label': 'ALT', 'value': '0 m'},
    {'label': 'GPS', 'value': '50.087, 14.421'},
  ];

  final List<Map<String, String>> rightInfoModes = const [
    {'label': 'ELAPSED', 'value': '00:00'},
    {'label': 'REMAIN', 'value': '02:00'},
    {'label': 'ETA', 'value': '10:35'},
    {'label': 'DEV', 'value': '0 km'},
  ];

  void _cycleLeftInfo() {
    setState(() {
      leftInfoIndex = (leftInfoIndex + 1) % leftInfoModes.length;
    });
  }

  void _cycleRightInfo() {
    setState(() {
      rightInfoIndex = (rightInfoIndex + 1) % rightInfoModes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final leftInfo = leftInfoModes[leftInfoIndex];
    final rightInfo = rightInfoModes[rightInfoIndex];

    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.public, size: 96, color: Colors.white70),
                    SizedBox(height: 16),
                    Text(
                      'Flight map canvas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'World base 4–5 + Europe detail 6–7',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
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
                    from: 'Prague',
                    to: 'Naples',
                    status: 'Flight mode',
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
