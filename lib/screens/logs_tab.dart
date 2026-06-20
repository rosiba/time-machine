import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/logs_provider.dart';
import '../providers/projects_provider.dart';

class LogsTab extends StatelessWidget {
  const LogsTab({super.key});

  String _fmtDuration(Duration d) {
    if (d.inHours > 0) {
      return '${d.inHours}h ${d.inMinutes % 60}m ${d.inSeconds % 60}s';
    }
    if (d.inMinutes > 0) return '${d.inMinutes}m ${d.inSeconds % 60}s';
    return '${d.inSeconds}s';
  }

  String _fmtDateTime(DateTime dt) {
    final date =
        '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    final time =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
    return '$date  $time';
  }

  @override
  Widget build(BuildContext context) {
    final logs = context.watch<LogsProvider>().logs;
    final projectsProvider = context.watch<ProjectsProvider>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, size: 64,
                color: cs.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('No sessions yet', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Start a timer to record your first session',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (ctx, i) {
        final log = logs[i];
        final project = projectsProvider.findById(log.projectId);
        final color =
            project != null ? Color(project.color) : cs.outline;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Color bar
                Container(
                  width: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12)
                      .copyWith(left: 12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project?.name ?? 'Deleted project',
                          style: theme.textTheme.titleSmall?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        _row(context, Icons.play_arrow_rounded,
                            _fmtDateTime(log.startedAt)),
                        const SizedBox(height: 2),
                        _row(context, Icons.stop_rounded,
                            _fmtDateTime(log.finishedAt)),
                      ],
                    ),
                  ),
                ),
                // Duration badge
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _fmtDuration(log.duration),
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _row(BuildContext context, IconData icon, String text) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 13, color: cs.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(text,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: cs.onSurfaceVariant)),
      ],
    );
  }
}
