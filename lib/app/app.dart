import 'package:flutter/material.dart';

import '../features/archive/presentation/archive_screen.dart';
import '../features/flight/presentation/flight_screen.dart';
import '../features/import_flight/presentation/import_flight_screen.dart';
import '../features/maps/presentation/maps_screen.dart';
import '../features/replay/presentation/replay_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/tracker/presentation/tracker_screen.dart';

class Fly2App extends StatelessWidget {
  const Fly2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLY2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const RootShell(),
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int index = 0;
  String? _replaySessionId;

  final List<String> titles = const [
    'Flight',
    'Import',
    'Tracker',
    'Replay',
    'Archive',
    'Maps',
  ];

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
      ),
    );
  }

  void _openReplayInShell(String sessionId) {
    setState(() {
      _replaySessionId = sessionId;
      index = 3;
    });
  }

  List<Widget> _buildScreens() {
    return [
      const FlightScreen(),
      const ImportFlightScreen(),
      const TrackerScreen(),
      ReplayScreen(
        key: ValueKey('replay:${_replaySessionId ?? 'demo-prague-naples'}'),
        sessionId: _replaySessionId,
      ),
      ArchiveScreen(
        onPlaySession: _openReplayInShell,
      ),
      const MapsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screens = _buildScreens();

    return Scaffold(
      appBar: AppBar(
        title: Text('FLY2 · ${titles[index]}'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: _openSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.flight),
            label: 'Flight',
          ),
          NavigationDestination(
            icon: Icon(Icons.input),
            label: 'Import',
          ),
          NavigationDestination(
            icon: Icon(Icons.gps_fixed),
            label: 'Tracker',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle),
            label: 'Replay',
          ),
          NavigationDestination(
            icon: Icon(Icons.archive),
            label: 'Archive',
          ),
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'Maps',
          ),
        ],
      ),
    );
  }
}