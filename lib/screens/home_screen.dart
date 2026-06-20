import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/timer_provider.dart';
import 'logs_tab.dart';
import 'projects_tab.dart';
import 'timer_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  static const _destinations = [
    (icon: Icons.timer_outlined, selected: Icons.timer_rounded, label: 'Timer'),
    (
      icon: Icons.folder_outlined,
      selected: Icons.folder_rounded,
      label: 'Projects'
    ),
    (
      icon: Icons.history_outlined,
      selected: Icons.history_rounded,
      label: 'Logs'
    ),
  ];

  Widget _body() => switch (_index) {
        0 => const TimerTab(),
        1 => ProjectsTab(onAdd: () => showAddProjectDialog(context)),
        _ => const LogsTab(),
      };

  @override
  Widget build(BuildContext context) {
    final isRunning = context.select<TimerProvider, bool>((t) => t.isRunning);
    final wide = MediaQuery.sizeOf(context).width > 640;

    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              labelType: NavigationRailLabelType.all,
              leading: const SizedBox(height: 8),
              destinations: _destinations
                  .map((d) => NavigationRailDestination(
                        icon: Icon(d.icon),
                        selectedIcon: Icon(d.selected),
                        label: Text(d.label),
                      ))
                  .toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: _body()),
          ],
        ),
        floatingActionButton: _index == 1
            ? FloatingActionButton(
                onPressed: () => showAddProjectDialog(context),
                child: const Icon(Icons.add),
              )
            : null,
      );
    }

    return Scaffold(
      body: _body(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: _destinations
            .map((d) => NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: d.label == 'Timer' && isRunning
                      ? const _PulsingDot()
                      : Icon(d.selected),
                  label: d.label,
                ))
            .toList(),
      ),
      floatingActionButton: _index == 1
          ? FloatingActionButton(
              onPressed: () => showAddProjectDialog(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: Icon(Icons.timer_rounded,
          color: Theme.of(context).colorScheme.primary),
    );
  }
}
