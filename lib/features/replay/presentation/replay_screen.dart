import 'package:flutter/material.dart';

class ReplayScreen extends StatefulWidget {
  const ReplayScreen({super.key});

  @override
  State<ReplayScreen> createState() => _ReplayScreenState();
}

class _ReplayScreenState extends State<ReplayScreen> {
  int leftInfoIndex = 0;
  int rightInfoIndex = 0;
  double scrubValue = 0;

  final List<Map<String, String>> leftInfoModes = const [
    {'label': 'SPD', 'value': '0 km/h'},
    {'label': 'ALT', 'value': '0 m'},
    {'label': 'GPS', 'value': '49.8, 13.7'},
  ];

  final List<Map<String, String>> rightInfoModes = const [
    {'label': 'ELAPSED', 'value': '00:00'},
    {'label': 'REMAIN', 'value': '02:00'},
    {'label': 'ETA', 'value': '11:05'},
    {'label': 'SPEED', 'value': '1x'},
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
                    Icon(Icons.play_circle_fill, size: 96, color: Colors.white70),
                    SizedBox(height: 16),
                    Text(
                      'Replay map canvas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Demo route: Prague → Naples',
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
              children: const [
                Expanded(
                  child: _ReplayTopBar(
                    title: 'Prague → Naples',
                    status: 'Replay mode',
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
              child: _ReplayCornerInfoBadge(
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
              child: _ReplayCornerInfoBadge(
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
            child: _ReplayBottomOverlay(
              scrubValue: scrubValue,
              onChanged: (value) {
                setState(() {
                  scrubValue = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReplayTopBar extends StatelessWidget {
  final String title;
  final String status;

  const _ReplayTopBar({
    required this.title,
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
            const Icon(Icons.play_circle, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
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

class _ReplayCornerInfoBadge extends StatelessWidget {
  final String title;
  final String value;
  final bool alignRight;

  const _ReplayCornerInfoBadge({
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

class _ReplayBottomOverlay extends StatelessWidget {
  final double scrubValue;
  final ValueChanged<double> onChanged;

  const _ReplayBottomOverlay({
    required this.scrubValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withValues(alpha: 0.72),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: scrubValue,
              max: 7200,
              onChanged: onChanged,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play'),
                ),
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                ),
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.replay_10),
                  label: const Text('-10s'),
                ),
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.forward_10),
                  label: const Text('+10s'),
                ),
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.speed),
                  label: const Text('1x / 2x / 5x / 10x'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
