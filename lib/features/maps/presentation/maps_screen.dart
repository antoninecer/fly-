import 'package:flutter/material.dart';

class MapsScreen extends StatelessWidget {
  const MapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: const [
            _MapPackageCard(
              title: 'World Base',
              fileName: 'world_base_z4_z5.mbtiles',
              zooms: 'Zoom 4–5',
              size: '14 MB',
              badge: 'Fallback',
            ),
            _MapPackageCard(
              title: 'Europe Detail',
              fileName: 'europe_detail_z6_z7.mbtiles',
              zooms: 'Zoom 6–7',
              size: '5.6 MB',
              badge: 'Detail',
            ),
            _MapPackageCard(
              title: 'Europe Legacy',
              fileName: 'europe_med_satellite_legacy.mbtiles',
              zooms: 'Zoom 4–6',
              size: '2.9 MB',
              badge: 'Legacy',
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPackageCard extends StatelessWidget {
  final String title;
  final String fileName;
  final String zooms;
  final String size;
  final String badge;

  const _MapPackageCard({
    required this.title,
    required this.fileName,
    required this.zooms,
    required this.size,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Chip(label: Text(badge)),
              ],
            ),
            const SizedBox(height: 8),
            Text(fileName),
            const SizedBox(height: 4),
            Text(zooms),
            const SizedBox(height: 4),
            Text('Size: $size'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Activate'),
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
