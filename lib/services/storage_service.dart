import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/project.dart';
import '../models/time_log.dart';

class StorageService {
  StorageService._();
  static final instance = StorageService._();

  Future<String> get _dir async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<List<Project>> loadProjects() async {
    try {
      final file = File('${await _dir}/tm_projects.json');
      if (!file.existsSync()) return [];
      final raw = await file.readAsString();
      return (jsonDecode(raw) as List)
          .map((e) => Project.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveProjects(List<Project> projects) async {
    final file = File('${await _dir}/tm_projects.json');
    await file.writeAsString(
        jsonEncode(projects.map((p) => p.toJson()).toList()));
  }

  Future<List<TimeLog>> loadLogs() async {
    try {
      final file = File('${await _dir}/tm_logs.json');
      if (!file.existsSync()) return [];
      final raw = await file.readAsString();
      return (jsonDecode(raw) as List)
          .map((e) => TimeLog.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveLogs(List<TimeLog> logs) async {
    final file = File('${await _dir}/tm_logs.json');
    await file
        .writeAsString(jsonEncode(logs.map((l) => l.toJson()).toList()));
  }
}
