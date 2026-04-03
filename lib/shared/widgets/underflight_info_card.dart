import 'package:flutter/material.dart';
import '../../data/models/poi.dart';

class UnderflightInfoCard extends StatelessWidget {
  final Poi poi;
  final double distanceKm;

  const UnderflightInfoCard({
    super.key,
    required this.poi,
    required this.distanceKm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 1),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Icon and Title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: _getPoiColor(poi.type).withValues(alpha: 0.3),
              child: Row(
                children: [
                  Icon(_getPoiIcon(poi.type), color: _getPoiColor(poi.type), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      poi.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Body with Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (poi.altitude != null)
                    _detailRow(Icons.height, 'Výška: ${poi.altitude!.toInt()} m'),
                  if (poi.population != null)
                    _detailRow(Icons.people, 'Populace: ${poi.population}'),
                  if (poi.extra != null && poi.type == PoiType.river)
                    _detailRow(Icons.straighten, 'Délka: ${poi.extra}'),
                  if (poi.extra != null && poi.type == PoiType.airport)
                    _detailRow(Icons.local_airport, 'IATA: ${poi.extra}'),
                  _detailRow(Icons.near_me, 'Vzdálenost: ${distanceKm.toStringAsFixed(1)} km'),
                  if (poi.info != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      poi.info!,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.white60),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }

  IconData _getPoiIcon(PoiType type) {
    switch (type) {
      case PoiType.city: return Icons.location_city;
      case PoiType.mountain: return Icons.landscape;
      case PoiType.river: return Icons.waves;
      case PoiType.airport: return Icons.local_airport;
    }
  }

  Color _getPoiColor(PoiType type) {
    switch (type) {
      case PoiType.city: return Colors.amber;
      case PoiType.mountain: return Colors.brown;
      case PoiType.river: return Colors.blue;
      case PoiType.airport: return Colors.green;
    }
  }
}
