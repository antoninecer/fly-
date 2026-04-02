class MapPackage {
  final String id;
  final String name;
  final String fileName;
  final int minZoom;
  final int maxZoom;
  final int priority;
  final bool isFallback;

  const MapPackage({
    required this.id,
    required this.name,
    required this.fileName,
    required this.minZoom,
    required this.maxZoom,
    required this.priority,
    required this.isFallback,
  });
}
