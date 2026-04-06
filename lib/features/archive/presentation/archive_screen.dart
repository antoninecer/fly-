import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/db/app_database.dart';
import '../../../data/repositories/session_repository.dart';
import '../../replay/presentation/replay_screen.dart';

class ArchiveScreen extends StatefulWidget {
  final ValueChanged<String>? onPlaySession;

  const ArchiveScreen({super.key, this.onPlaySession});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  late AppDatabase _db;
  late SessionRepository _repository;
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _repository = SessionRepository(_db);
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  void _playSession(String sessionId) {
    if (widget.onPlaySession != null) {
      widget.onPlaySession!(sessionId);
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReplayScreen(sessionId: sessionId),
      ),
    );
  }

  Future<void> _deleteSession(Session session) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Session?'),
        content: Text('Are you sure you want to delete "${session.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _repository.deleteSession(session.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Session "${session.title}" deleted')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const _ArchiveToolbar(),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<List<Session>>(
                stream: _repository.watchAllSessions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final sessions = snapshot.data ?? [];

                  if (sessions.isEmpty) {
                    return const Center(
                      child: Text(
                        'No sessions found in archive.',
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (ctx, index) {
                      final session = sessions[index];
                      return _ArchiveItemCard(
                        session: session,
                        dateLabel: _dateFormat.format(session.startedAt),
                        onPlay: () => _playSession(session.id),
                        onDelete: () => _deleteSession(session),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArchiveToolbar extends StatelessWidget {
  const _ArchiveToolbar();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withValues(alpha: 0.5),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.search, size: 20, color: Colors.white54),
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search archive...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArchiveItemCard extends StatelessWidget {
  final Session session;
  final String dateLabel;
  final VoidCallback onPlay;
  final VoidCallback onDelete;

  const _ArchiveItemCard({
    required this.session,
    required this.dateLabel,
    required this.onPlay,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDemo = session.sourceType == 'demo';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  session.type == 'flight'
                      ? Icons.flight_takeoff
                      : Icons.gps_fixed,
                  color: Colors.blueAccent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    session.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isDemo)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'DEMO',
                      style: TextStyle(fontSize: 10, color: Colors.amber),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${session.fromName ?? 'Unknown'} → ${session.toName ?? 'Unknown'}',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 12, color: Colors.white54),
                const SizedBox(width: 4),
                Text(
                  dateLabel,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.timer, size: 12, color: Colors.white54),
                const SizedBox(width: 4),
                Text(
                  _formatDuration(session.durationSec),
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: onPlay,
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text('Play'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Delete'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}