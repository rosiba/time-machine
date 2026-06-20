import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project.dart';
import '../providers/projects_provider.dart';

const _palette = [
  Color(0xFFEF4444),
  Color(0xFFEC4899),
  Color(0xFF8B5CF6),
  Color(0xFF6366F1),
  Color(0xFF3B82F6),
  Color(0xFF06B6D4),
  Color(0xFF10B981),
  Color(0xFF84CC16),
  Color(0xFFF59E0B),
  Color(0xFFF97316),
];

class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectsProvider>().projects;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (projects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open_rounded, size: 64,
                color: cs.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('No projects yet', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Tap + to create your first project',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: projects.length,
      itemBuilder: (ctx, i) => _ProjectTile(project: projects[i]),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({required this.project});
  final Project project;

  String _fmtDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(project.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Text(
            project.name[0].toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(project.name),
        subtitle: Text('Created ${_fmtDate(project.createdAt)}',
            style: theme.textTheme.bodySmall),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline_rounded,
              color: theme.colorScheme.error),
          tooltip: 'Delete project',
          onPressed: () => _confirmDelete(context),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete project?'),
        content: Text(
            'Delete "${project.name}"? Existing logs will be kept.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              context.read<ProjectsProvider>().remove(project.id);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

void showAddProjectDialog(BuildContext context) {
  final nameCtrl = TextEditingController();
  var selectedColor = _palette[3];

  showDialog<void>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('New project'),
        content: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Project name',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) =>
                    _submit(ctx, context, nameCtrl, selectedColor),
              ),
              const SizedBox(height: 20),
              Text('Color',
                  style: Theme.of(ctx).textTheme.labelMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _palette
                    .map((c) => GestureDetector(
                          onTap: () =>
                              setState(() => selectedColor = c),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: selectedColor == c
                                  ? Border.all(
                                      color: Colors.white, width: 3)
                                  : null,
                            ),
                            child: selectedColor == c
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 18)
                                : null,
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () =>
                _submit(ctx, context, nameCtrl, selectedColor),
            child: const Text('Create'),
          ),
        ],
      ),
    ),
  );
}

void _submit(BuildContext dialogCtx, BuildContext parentCtx,
    TextEditingController ctrl, Color color) {
  final name = ctrl.text.trim();
  if (name.isEmpty) return;
  parentCtx.read<ProjectsProvider>().add(name, color);
  Navigator.pop(dialogCtx);
}
