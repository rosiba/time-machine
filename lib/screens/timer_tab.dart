import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/projects_provider.dart';
import '../providers/timer_provider.dart';

class TimerTab extends StatelessWidget {
  const TimerTab({super.key});

  String _fmt(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String _fmtTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<TimerProvider>();
    final projects = context.watch<ProjectsProvider>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Project selector
              DropdownButtonFormField<String>(
                initialValue: timer.selectedProjectId,
                decoration: InputDecoration(
                  labelText: 'Project',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.folder_outlined),
                  filled: true,
                  fillColor: cs.surfaceContainerHighest,
                ),
                items: projects.projects
                    .map((p) => DropdownMenuItem(
                          value: p.id,
                          child: Row(children: [
                            CircleAvatar(
                                backgroundColor: Color(p.color), radius: 7),
                            const SizedBox(width: 10),
                            Text(p.name),
                          ]),
                        ))
                    .toList(),
                onChanged: timer.isRunning
                    ? null
                    : (id) => timer.selectProject(id),
                hint: const Text('Select a project'),
              ),

              const SizedBox(height: 56),

              // Elapsed display
              Text(
                _fmt(timer.elapsed),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 6,
                  fontFamily: 'monospace',
                  color: timer.isRunning ? cs.primary : cs.onSurface,
                ),
              ),

              // Started at label
              AnimatedOpacity(
                opacity: timer.isRunning ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    timer.startedAt != null
                        ? 'Started at ${_fmtTime(timer.startedAt!)}'
                        : '',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
              ),

              const SizedBox(height: 56),

              // Start / Stop button
              FilledButton.icon(
                onPressed: timer.selectedProjectId == null
                    ? null
                    : timer.isRunning
                        ? timer.stop
                        : timer.start,
                icon: Icon(timer.isRunning ? Icons.stop_rounded : Icons.play_arrow_rounded),
                label: Text(
                  timer.isRunning ? 'Stop' : 'Start',
                  style: const TextStyle(fontSize: 16),
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor:
                      timer.isRunning ? cs.error : cs.primary,
                  foregroundColor:
                      timer.isRunning ? cs.onError : cs.onPrimary,
                ),
              ),

              if (projects.projects.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    'Create a project in the Projects tab first.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
