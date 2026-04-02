import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          _SettingsSection(
            title: 'Language',
            children: [
              ListTile(
                leading: Icon(Icons.language),
                title: Text('App language'),
                subtitle: Text('en / de / it / cs'),
              ),
            ],
          ),
          SizedBox(height: 12),
          _SettingsSection(
            title: 'Display',
            children: [
              ListTile(
                leading: Icon(Icons.battery_saver),
                title: Text('Saver mode'),
                subtitle: Text('Full / Reduced / Saver'),
              ),
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Map behavior'),
                subtitle: Text('World fallback + region detail'),
              ),
            ],
          ),
          SizedBox(height: 12),
          _SettingsSection(
            title: 'Replay',
            children: [
              ListTile(
                leading: Icon(Icons.speed),
                title: Text('Default replay speed'),
                subtitle: Text('1x'),
              ),
            ],
          ),
          SizedBox(height: 12),
          _SettingsSection(
            title: 'Data',
            children: [
              ListTile(
                leading: Icon(Icons.download),
                title: Text('Import / export'),
                subtitle: Text('Planned for next step'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
