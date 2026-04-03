import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../db/app_database.dart';

enum TrackerMode { idle, watching, recording }

class TrackerService extends ChangeNotifier {
  final AppDatabase db;
  TrackerMode _mode = TrackerMode.idle;
  
  Position? _currentPosition;
  String? _currentSessionId;
  StreamSubscription<Position>? _positionSubscription;
  Timer? _recordingTimer;

  TrackerService(this.db);

  TrackerMode get mode => _mode;
  Position? get currentPosition => _currentPosition;
  LatLng? get currentLatLng => _currentPosition != null 
      ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude) 
      : null;

  bool get isRecording => _mode == TrackerMode.recording;
  bool get isWatching => _mode != TrackerMode.idle;

  /// Starts just watching position without saving
  Future<void> startWatching() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    _mode = TrackerMode.watching;
    _startPositionStream();
    notifyListeners();
  }

  /// Starts recording position to DB every X seconds
  Future<void> startRecording() async {
    if (_mode == TrackerMode.idle) await startWatching();
    
    _currentSessionId = 'log-${const Uuid().v4().substring(0, 8)}';
    
    // Create Session in DB
    await db.into(db.sessions).insert(
      SessionsCompanion.insert(
        id: _currentSessionId!,
        type: 'tracker',
        title: 'Blackbox Log: ${DateTime.now().hour}:${DateTime.now().minute}',
        startedAt: DateTime.now(),
        sourceType: 'tracker',
      ),
    );

    _mode = TrackerMode.recording;
    
    // Start periodic recording timer
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 5), (_) => _recordPoint());
    
    notifyListeners();
  }

  void stop() {
    _mode = TrackerMode.idle;
    _positionSubscription?.cancel();
    _recordingTimer?.cancel();
    _currentSessionId = null;
    notifyListeners();
  }

  void _startPositionStream() {
    _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
      ),
    ).listen((position) {
      _currentPosition = position;
      notifyListeners();
    });
  }

  Future<void> _recordPoint() async {
    if (_currentPosition == null || _currentSessionId == null) return;

    await db.into(db.trackPoints).insert(
      TrackPointsCompanion.insert(
        sessionId: _currentSessionId!,
        timestamp: DateTime.now(),
        lat: _currentPosition!.latitude,
        lon: _currentPosition!.longitude,
        altMeters: _currentPosition!.altitude,
        speedKmh: _currentPosition!.speed * 3.6, // m/s to km/h
        headingDeg: _currentPosition!.heading,
      ),
    );
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}
