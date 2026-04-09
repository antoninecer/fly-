import '../db/app_database.dart';

class KmlExporter {
  static String buildSessionKml({
    required Session session,
    required List<TrackPoint> points,
  }) {
    final safeTitle = _xml(session.title);
    final fromName = _xml(session.fromName ?? 'Unknown');
    final toName = _xml(session.toName ?? 'Unknown');
    final notes = _xml(session.notes ?? '');
    final sourceType = _xml(session.sourceType);
    final startedAt = session.startedAt.toUtc().toIso8601String();
    final endedAt = session.endedAt?.toUtc().toIso8601String() ?? '';
    final distanceKm = session.distanceKm.toStringAsFixed(1);
    final durationSec = session.durationSec.toString();

    final startPoint = points.isNotEmpty ? points.first : null;
    final endPoint = points.isNotEmpty ? points.last : null;

    final whenLines = points
        .map((p) => '        <when>${p.timestamp.toUtc().toIso8601String()}</when>')
        .join('\n');

    final coordLines = points
        .map((p) => '        <gx:coord>${p.lon} ${p.lat} ${p.altMeters}</gx:coord>')
        .join('\n');

    final lineCoords = points
        .map((p) => '${p.lon},${p.lat},${p.altMeters}')
        .join(' ');

    final startPlacemark = startPoint == null
        ? ''
        : '''
    <Placemark>
      <name>Start</name>
      <Style>
        <IconStyle>
          <color>ff00ff00</color>
          <scale>1.1</scale>
          <Icon>
            <href>http://maps.google.com/mapfiles/kml/paddle/grn-circle.png</href>
          </Icon>
        </IconStyle>
      </Style>
      <Point>
        <coordinates>${startPoint.lon},${startPoint.lat},${startPoint.altMeters}</coordinates>
      </Point>
    </Placemark>
''';

    final endPlacemark = endPoint == null
        ? ''
        : '''
    <Placemark>
      <name>End</name>
      <Style>
        <IconStyle>
          <color>ff0000ff</color>
          <scale>1.1</scale>
          <Icon>
            <href>http://maps.google.com/mapfiles/kml/paddle/red-circle.png</href>
          </Icon>
        </IconStyle>
      </Style>
      <Point>
        <coordinates>${endPoint.lon},${endPoint.lat},${endPoint.altMeters}</coordinates>
      </Point>
    </Placemark>
''';

    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2"
     xmlns:gx="http://www.google.com/kml/ext/2.2">
  <Document>
    <name>$safeTitle</name>
    <description>FLY2 export</description>

    <Style id="trackLineStyle">
      <LineStyle>
        <color>ff00a5ff</color>
        <width>4</width>
      </LineStyle>
    </Style>

    <Style id="trackPointStyle">
      <IconStyle>
        <scale>1.0</scale>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/shapes/airports.png</href>
        </Icon>
      </IconStyle>
    </Style>

    <Placemark>
      <name>$safeTitle</name>
      <description><![CDATA[
        <b>From:</b> $fromName<br/>
        <b>To:</b> $toName<br/>
        <b>Started:</b> $startedAt<br/>
        <b>Ended:</b> $endedAt<br/>
        <b>Distance:</b> $distanceKm km<br/>
        <b>Duration:</b> $durationSec s<br/>
        <b>Source:</b> $sourceType<br/>
        <b>Notes:</b> $notes
      ]]></description>
      <styleUrl>#trackPointStyle</styleUrl>
      <gx:Track>
$whenLines
$coordLines
      </gx:Track>
    </Placemark>

    <Placemark>
      <name>$safeTitle Route</name>
      <styleUrl>#trackLineStyle</styleUrl>
      <LineString>
        <tessellate>1</tessellate>
        <altitudeMode>absolute</altitudeMode>
        <coordinates>$lineCoords</coordinates>
      </LineString>
    </Placemark>

$startPlacemark
$endPlacemark
  </Document>
</kml>
''';
  }

  static String _xml(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }
}