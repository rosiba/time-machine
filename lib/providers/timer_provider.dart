import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/time_log.dart';
import 'logs_provider.dart';

class TimerProvider extends ChangeNotifier {
  String? _selectedProjectId;
  DateTime? _startedAt;
  Timer? _ticker;
  Duration _elapsed = Duration.zero;
  bool _isRunning = false;
  LogsProvider? _logsProvider;

  String? get selectedProjectId => _selectedProjectId;
  Duration get elapsed => _elapsed;
  bool get isRunning => _isRunning;
  DateTime? get startedAt => _startedAt;

  void setLogsProvider(LogsProvider provider) {
    _logsProvider = provider;
  }

  void selectProject(String? id) {
    if (_isRunning) return;
    _selectedProjectId = id;
    notifyListeners();
  }

  void start() {
    if (_selectedProjectId == null || _isRunning) return;
    _startedAt = DateTime.now();
    _elapsed = Duration.zero;
    _isRunning = true;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed = DateTime.now().difference(_startedAt!);
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> stop() async {
    if (!_isRunning || _startedAt == null) return;
    _ticker?.cancel();
    _ticker = null;
    _isRunning = false;
    final finishedAt = DateTime.now();
    await _logsProvider?.addLog(TimeLog(
      id: const Uuid().v4(),
      projectId: _selectedProjectId!,
      startedAt: _startedAt!,
      finishedAt: finishedAt,
      duration: finishedAt.difference(_startedAt!),
    ));
    _elapsed = Duration.zero;
    _startedAt = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
