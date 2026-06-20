import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/project.dart';
import '../services/storage_service.dart';

class ProjectsProvider extends ChangeNotifier {
  List<Project> _projects = [];
  bool _loaded = false;

  List<Project> get projects => List.unmodifiable(_projects);

  Future<void> load() async {
    if (_loaded) return;
    _projects = await StorageService.instance.loadProjects();
    _loaded = true;
    notifyListeners();
  }

  Future<void> add(String name, Color color) async {
    _projects.add(Project(
      id: const Uuid().v4(),
      name: name,
      color: color.toARGB32(),
      createdAt: DateTime.now(),
    ));
    await StorageService.instance.saveProjects(_projects);
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _projects.removeWhere((p) => p.id == id);
    await StorageService.instance.saveProjects(_projects);
    notifyListeners();
  }

  Project? findById(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
