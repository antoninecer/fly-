import 'package:flutter/material.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const _ArchiveToolbar(),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: const [
                  _ArchiveItemCard(
                    title: 'Demo Prague → Naples',
                    subtitle: 'Replay · 2h 00m',
                  ),
                  _ArchiveItemCard(
                    title: 'Blackbox Session',
                    subtitle: 'Tracker · 0h 25m',
                  ),
                  _ArchiveItemCard(
                    title: 'Imported Flight',
                    subtitle: 'Flight · 1h 45m',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArchiveToolbar extends StatelessWidget {
  const _ArchiveToolbar();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            SizedBox(
              width: 220,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search archive',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArchiveItemCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ArchiveItemCard({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            Wrap(
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
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Details'),
                ),
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
