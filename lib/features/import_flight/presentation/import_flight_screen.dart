import 'package:flutter/material.dart';

class ImportFlightScreen extends StatelessWidget {
  const ImportFlightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            _ImportFormCard(),
            SizedBox(height: 12),
            _ImportActionsCard(),
          ],
        ),
      ),
    );
  }
}

class _ImportFormCard extends StatelessWidget {
  const _ImportFormCard();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ListView(
            children: const [
              Text(
                'Import flight data',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Flight number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'From airport / city',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'To airport / city',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Date / time',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Manual notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImportActionsCard extends StatelessWidget {
  const _ImportActionsCard();

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
              onPressed: null,
              icon: const Icon(Icons.download),
              label: const Text('Import Flight'),
            ),
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.route),
              label: const Text('Create Route'),
            ),
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Clear'),
            ),
          ],
        ),
      ),
    );
  }
}
