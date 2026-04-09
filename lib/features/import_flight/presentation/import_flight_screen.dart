import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../../data/db/app_database.dart';
import '../../../data/services/aviationstack_service.dart';

class ImportFlightScreen extends StatefulWidget {
  const ImportFlightScreen({super.key});

  @override
  State<ImportFlightScreen> createState() => _ImportFlightScreenState();
}

class _ImportFlightScreenState extends State<ImportFlightScreen> {
  final _flightNumberController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final _notesController = TextEditingController();
  final _apiKeyController = TextEditingController();

  final AviationstackService _aviationstackService = AviationstackService();
  late final AppDatabase _db;

  bool _useApiLookup = true;
  bool _isLoading = false;
  bool _airportsLoaded = false;

  String _status = 'Ready';
  String? _resultSummary;

  List<AirportItem> _airports = [];

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _loadAirports();
  }

  @override
  void dispose() {
    _flightNumberController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _dateTimeController.dispose();
    _notesController.dispose();
    _apiKeyController.dispose();
    _db.close();
    super.dispose();
  }

  Future<void> _loadAirports() async {
    try {
      final raw = await rootBundle.loadString('data/source/airports.json');
      final decoded = jsonDecode(raw);

      if (decoded is List) {
        final airports = decoded
            .whereType<Map>()
            .map((item) => AirportItem.fromJson(Map<String, dynamic>.from(item)))
            .where((a) => a.name.isNotEmpty)
            .toList();

        if (!mounted) return;

        setState(() {
          _airports = airports;
          _airportsLoaded = true;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _airportsLoaded = true;
          _status = 'Airport database format not supported';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _airportsLoaded = true;
        _status = 'Failed to load airports';
        _resultSummary = e.toString();
      });
    }
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );

    if (pickedTime == null) return;

    final dt = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');

    setState(() {
      _dateTimeController.text = '${dt.year}-$mm-$dd $hh:$mi';
    });
  }

  void _clearForm() {
    setState(() {
      _flightNumberController.clear();
      _fromController.clear();
      _toController.clear();
      _dateTimeController.clear();
      _notesController.clear();
      _apiKeyController.clear();
      _resultSummary = null;
      _status = 'Cleared';
      _useApiLookup = true;
    });
  }

  AirportItem? _resolveAirport(String value) {
    final q = value.trim().toLowerCase();
    if (q.isEmpty) return null;

    for (final airport in _airports) {
      if (airport.displayLabel.toLowerCase() == q) return airport;
    }

    for (final airport in _airports) {
      if (airport.iata.toLowerCase() == q || airport.ident.toLowerCase() == q) {
        return airport;
      }
    }

    for (final airport in _airports) {
      if (airport.name.toLowerCase() == q || airport.city.toLowerCase() == q) {
        return airport;
      }
    }

    for (final airport in _airports) {
      if (airport.displayLabel.toLowerCase().contains(q)) return airport;
    }

    return null;
  }

  DateTime _parsePlannedTime(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return DateTime.now();

    final iso = DateTime.tryParse(text);
    if (iso != null) return iso.toLocal();

    final m = RegExp(
      r'^(\d{4})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2})$',
    ).firstMatch(text);

    if (m != null) {
      return DateTime(
        int.parse(m.group(1)!),
        int.parse(m.group(2)!),
        int.parse(m.group(3)!),
        int.parse(m.group(4)!),
        int.parse(m.group(5)!),
      );
    }

    return DateTime.now();
  }

  Future<void> _saveActiveFlight({
    required String flightNumber,
    required String fromText,
    required String toText,
    required String dateTimeText,
    required String notes,
    required String sourceType,
    String? apiStatus,
  }) async {
    final fromAirport = _resolveAirport(fromText);
    final toAirport = _resolveAirport(toText);
    final plannedTime = _parsePlannedTime(dateTimeText);

    final fromName = fromAirport?.displayLabel.isNotEmpty == true
        ? fromAirport!.displayLabel
        : fromText;
    final toName = toAirport?.displayLabel.isNotEmpty == true
        ? toAirport!.displayLabel
        : toText;

    final title = flightNumber.isNotEmpty
        ? flightNumber
        : '${fromName.isEmpty ? 'Unknown' : fromName} → ${toName.isEmpty ? 'Unknown' : toName}';

    final sessionId = 'active-${DateTime.now().millisecondsSinceEpoch}';

    await _db.transaction(() async {
      await (_db.update(_db.sessions)).write(
        const SessionsCompanion(
          isActive: drift.Value(false),
        ),
      );

      await _db.into(_db.sessions).insert(
            SessionsCompanion.insert(
              id: sessionId,
              type: 'flight',
              title: title,
              fromName: drift.Value(fromName.isEmpty ? null : fromName),
              toName: drift.Value(toName.isEmpty ? null : toName),
              fromLat: drift.Value(fromAirport?.lat),
              fromLon: drift.Value(fromAirport?.lon),
              toLat: drift.Value(toAirport?.lat),
              toLon: drift.Value(toAirport?.lon),
              startedAt: plannedTime,
              endedAt: const drift.Value(null),
              durationSec: const drift.Value(0),
              distanceKm: const drift.Value(0.0),
              isActive: const drift.Value(true),
              sourceType: sourceType,
              notes: drift.Value(
                [
                  if (apiStatus != null && apiStatus.trim().isNotEmpty)
                    'Status: $apiStatus',
                  if (notes.trim().isNotEmpty) notes.trim(),
                ].join('\n').trim().isEmpty
                    ? null
                    : [
                        if (apiStatus != null && apiStatus.trim().isNotEmpty)
                          'Status: $apiStatus',
                        if (notes.trim().isNotEmpty) notes.trim(),
                      ].join('\n'),
              ),
            ),
          );
    });
  }

  Future<void> _importFlight() async {
    FocusScope.of(context).unfocus();

    final flightNumber = _flightNumberController.text.trim();
    final from = _fromController.text.trim();
    final to = _toController.text.trim();
    final dateTime = _dateTimeController.text.trim();
    final apiKey = _apiKeyController.text.trim();
    final notes = _notesController.text.trim();

    if (_useApiLookup) {
      if (flightNumber.isEmpty) {
        setState(() {
          _status = 'Enter flight number';
          _resultSummary = null;
        });
        return;
      }

      if (apiKey.isEmpty) {
        setState(() {
          _status = 'Missing Aviationstack API key';
          _resultSummary =
              'Add your Aviationstack API key to enable lookup by flight number.';
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _status = 'Looking up flight via Aviationstack...';
        _resultSummary = null;
      });

      try {
        final result = await _aviationstackService.lookupFlight(
          apiKey: apiKey,
          flightNumber: flightNumber,
        );

        final resolvedFrom =
            result.departureIata ?? result.departureAirport ?? from;
        final resolvedTo = result.arrivalIata ?? result.arrivalAirport ?? to;
        final resolvedDateTime = result.departureScheduled ?? dateTime;

        await _saveActiveFlight(
          flightNumber: result.flightNumber,
          fromText: resolvedFrom,
          toText: resolvedTo,
          dateTimeText: resolvedDateTime,
          notes: notes,
          sourceType: 'api',
          apiStatus: result.flightStatus,
        );

        if (!mounted) return;

        setState(() {
          _fromController.text = resolvedFrom;
          _toController.text = resolvedTo;
          _dateTimeController.text = resolvedDateTime;
          _isLoading = false;
          _status = 'Flight imported and activated';
          _resultSummary =
              '${result.toSummary()}\n\nActive flight was updated for Flight screen.';
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _status = 'API lookup failed';
          _resultSummary = e.toString();
        });
      }

      return;
    }

    if (flightNumber.isEmpty && (from.isEmpty || to.isEmpty)) {
      setState(() {
        _status = 'Enter flight number or manual route';
        _resultSummary = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _status = 'Preparing manual import...';
      _resultSummary = null;
    });

    try {
      await _saveActiveFlight(
        flightNumber: flightNumber,
        fromText: from,
        toText: to,
        dateTimeText: dateTime,
        notes: notes,
        sourceType: 'manual',
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _status = 'Manual flight imported and activated';
        _resultSummary =
            'Flight: ${flightNumber.isEmpty ? "(manual route)" : flightNumber}\n'
            'From: ${from.isEmpty ? "-" : from}\n'
            'To: ${to.isEmpty ? "-" : to}\n'
            'Date/Time: ${dateTime.isEmpty ? "-" : dateTime}\n'
            'Notes: ${notes.isEmpty ? "-" : notes}\n\n'
            'Active flight was updated for Flight screen.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _status = 'Manual import failed';
        _resultSummary = e.toString();
      });
    }
  }

  void _createRoute() {
    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    setState(() {
      _status = 'Route draft prepared';
      _resultSummary =
          'Manual route builder will use:\n'
          'From: ${from.isEmpty ? "-" : from}\n'
          'To: ${to.isEmpty ? "-" : to}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _ImportFormCard(
                    flightNumberController: _flightNumberController,
                    fromController: _fromController,
                    toController: _toController,
                    dateTimeController: _dateTimeController,
                    notesController: _notesController,
                    apiKeyController: _apiKeyController,
                    useApiLookup: _useApiLookup,
                    airports: _airports,
                    airportsLoaded: _airportsLoaded,
                    onUseApiChanged: (value) {
                      setState(() {
                        _useApiLookup = value;
                      });
                    },
                    onPickDateTime: _pickDateTime,
                  ),
                  const SizedBox(height: 12),
                  _ImportStatusCard(
                    status: _status,
                    resultSummary: _resultSummary,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _ImportActionsCard(
              isLoading: _isLoading,
              onImportFlight: _importFlight,
              onCreateRoute: _createRoute,
              onClear: _clearForm,
            ),
          ],
        ),
      ),
    );
  }
}

class _ImportFormCard extends StatelessWidget {
  final TextEditingController flightNumberController;
  final TextEditingController fromController;
  final TextEditingController toController;
  final TextEditingController dateTimeController;
  final TextEditingController notesController;
  final TextEditingController apiKeyController;
  final bool useApiLookup;
  final bool airportsLoaded;
  final List<AirportItem> airports;
  final ValueChanged<bool> onUseApiChanged;
  final VoidCallback onPickDateTime;

  const _ImportFormCard({
    required this.flightNumberController,
    required this.fromController,
    required this.toController,
    required this.dateTimeController,
    required this.notesController,
    required this.apiKeyController,
    required this.useApiLookup,
    required this.airportsLoaded,
    required this.airports,
    required this.onUseApiChanged,
    required this.onPickDateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Import flight data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Use Aviationstack lookup when available, or fill route manually.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: useApiLookup,
              onChanged: onUseApiChanged,
              title: const Text('Use Aviationstack API lookup'),
              subtitle:
                  const Text('Lookup by flight number when API key is available'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: apiKeyController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Aviationstack API key',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.key),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: flightNumberController,
              decoration: const InputDecoration(
                labelText: 'Flight number',
                hintText: 'e.g. OK123 / LH1402 / FR654',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flight),
              ),
            ),
            const SizedBox(height: 12),
            _AirportAutocompleteField(
              controller: fromController,
              airports: airports,
              enabled: airportsLoaded,
              label: 'From airport / city',
              hint: airportsLoaded
                  ? 'Type airport, city, IATA or ICAO'
                  : 'Loading airports...',
              icon: Icons.flight_takeoff,
            ),
            const SizedBox(height: 12),
            _AirportAutocompleteField(
              controller: toController,
              airports: airports,
              enabled: airportsLoaded,
              label: 'To airport / city',
              hint: airportsLoaded
                  ? 'Type airport, city, IATA or ICAO'
                  : 'Loading airports...',
              icon: Icons.flight_land,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dateTimeController,
              readOnly: true,
              onTap: onPickDateTime,
              decoration: const InputDecoration(
                labelText: 'Date / time',
                hintText: 'Select date and time',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.schedule),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Manual notes',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AirportAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final List<AirportItem> airports;
  final String label;
  final String hint;
  final IconData icon;
  final bool enabled;

  const _AirportAutocompleteField({
    required this.controller,
    required this.airports,
    required this.label,
    required this.hint,
    required this.icon,
    required this.enabled,
  });

  @override
  State<_AirportAutocompleteField> createState() =>
      _AirportAutocompleteFieldState();
}

class _AirportAutocompleteFieldState extends State<_AirportAutocompleteField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Iterable<AirportItem> _filterAirports(String query) {
    if (query.trim().isEmpty) {
      return widget.airports.take(12);
    }

    final q = query.toLowerCase();

    return widget.airports.where((airport) {
      return airport.name.toLowerCase().contains(q) ||
          airport.city.toLowerCase().contains(q) ||
          airport.country.toLowerCase().contains(q) ||
          airport.ident.toLowerCase().contains(q) ||
          airport.iata.toLowerCase().contains(q);
    }).take(12);
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<AirportItem>(
      textEditingController: widget.controller,
      focusNode: _focusNode,
      displayStringForOption: (option) => option.displayLabel,
      optionsBuilder: (textEditingValue) {
        if (!widget.enabled) return const Iterable<AirportItem>.empty();
        return _filterAirports(textEditingValue.text);
      },
      onSelected: (selection) {
        widget.controller.text = selection.displayLabel;
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: widget.enabled,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            border: const OutlineInputBorder(),
            prefixIcon: Icon(widget.icon),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final list = options.toList();
        if (list.isEmpty) {
          return const SizedBox.shrink();
        }

        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).cardColor,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700,
                maxHeight: 280,
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                shrinkWrap: true,
                itemCount: list.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final airport = list[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.local_airport),
                    title: Text(
                      airport.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      airport.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => onSelected(airport),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ImportStatusCard extends StatelessWidget {
  final String status;
  final String? resultSummary;
  final bool isLoading;

  const _ImportStatusCard({
    required this.status,
    required this.resultSummary,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isLoading ? Icons.sync : Icons.info_outline,
                  color: isLoading ? Colors.amber : Colors.blueAccent,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            if (resultSummary != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  resultSummary!,
                  style: const TextStyle(height: 1.4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ImportActionsCard extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onImportFlight;
  final VoidCallback onCreateRoute;
  final VoidCallback onClear;

  const _ImportActionsCard({
    required this.isLoading,
    required this.onImportFlight,
    required this.onCreateRoute,
    required this.onClear,
  });

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
              onPressed: isLoading ? null : onImportFlight,
              icon: const Icon(Icons.download),
              label: const Text('Import Flight'),
            ),
            OutlinedButton.icon(
              onPressed: isLoading ? null : onCreateRoute,
              icon: const Icon(Icons.route),
              label: const Text('Create Route'),
            ),
            OutlinedButton.icon(
              onPressed: isLoading ? null : onClear,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Clear'),
            ),
          ],
        ),
      ),
    );
  }
}

class AirportItem {
  final String ident;
  final String iata;
  final String name;
  final String city;
  final String country;
  final double? lat;
  final double? lon;

  const AirportItem({
    required this.ident,
    required this.iata,
    required this.name,
    required this.city,
    required this.country,
    this.lat,
    this.lon,
  });

  factory AirportItem.fromJson(Map<String, dynamic> json) {
    return AirportItem(
      ident: (json['ident'] ?? '').toString(),
      iata: (json['iata'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      country: (json['country'] ?? '').toString(),
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
    );
  }

  String get displayLabel {
    final code = iata.isNotEmpty ? iata : ident;
    if (city.isNotEmpty) {
      return '$code — $city — $name';
    }
    return '$code — $name';
  }

  String get subtitle {
    final parts = <String>[];
    if (city.isNotEmpty) parts.add(city);
    if (country.isNotEmpty) parts.add(country);
    if (iata.isNotEmpty) {
      parts.add('IATA: $iata');
    } else if (ident.isNotEmpty) {
      parts.add('ICAO: $ident');
    }
    return parts.join(' · ');
  }
}