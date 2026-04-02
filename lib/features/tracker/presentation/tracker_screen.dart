import 'package:flutter/material.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            _TrackerStatusCard(),
            SizedBox(height: 12),
            _TrackerMapCard(),
            SizedBox(height: 12),
            _TrackerControlPanel(),
          ],
        ),
      ),
    );
  }
}

class _TrackerStatusCard extends StatelessWidget {
  const _TrackerStatusCard();

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _row('Mode', 'Blackbox'),
            _row('Recording', 'Stopped'),
            _row('Elapsed', '00:00'),
            _row('Distance', '0.0 km'),
            _row('Speed', '0 km/h'),
            _row('Altitude', '0 m'),
          ],
        ),
      ),
    );
  }
}

class _TrackerMapCard extends StatelessWidget {
  const _TrackerMapCard();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Container(
          width: double.infinity,
          color: Colors.black87,
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.gps_fixed, size: 72),
                SizedBox(height: 12),
                Text(
                  'Tracker map area',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text('Passive GPS / blackbox recording'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrackerControlPanel extends StatelessWidget {
  const _TrackerControlPanel();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: null,
              icon: const Icon(Icons.fiber_manual_record),
              label: const Text('Start Tracker'),
            ),
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.stop),
              label: const Text('Stop Tracker'),
            ),
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.place),
              label: const Text('Mark Point'),
            ),
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.battery_saver),
              label: const Text('Saver'),
            ),
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.share_location),
              label: const Text('Share Last Fix'),
            ),
          ],
        ),
      ),
    );
  }
}
