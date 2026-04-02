import 'package:flutter/material.dart';
import '../../../map/widgets/live_map_placeholder.dart';
import '../../../map/sources/map_source_resolver.dart';

class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const previewZoom = 5;
    final pkg = MapSourceResolver.forZoom(previewZoom);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FLY2 Live'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LiveMapPlaceholder(
                title: pkg?.name ?? 'No map package',
                subtitle: pkg == null
                    ? 'No package available for zoom $previewZoom'
                    : 'Using ${pkg.fileName} for zoom $previewZoom',
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Flight', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text('No flight selected'),
                          ],
                        ),
                      ),
                    ),
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
