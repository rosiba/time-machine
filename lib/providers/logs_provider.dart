import 'package:flutter/foundation.dart';

import '../models/time_log.dart';
import '../services/storage_service.dart';

class LogsProvider extends ChangeNotifier {
  List<TimeLog> _logs = [];
  bool _loaded = false;

  List<TimeLog> get logs => List.unmodifiable(_logs.reversed.toList());

  Future<void> load() async {
    if (_loaded) return;
    _logs = await StorageService.instance.loadLogs();
    _loaded = true;
    notifyListeners();
  }

  Future<void> addLog(TimeLog log) async {
    _logs.add(log);
    await StorageService.instance.saveLogs(_logs);
    notifyListeners();
  }
}
