import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/planner_task.dart';
import '../models/habit.dart';
import '../models/goal.dart';
import '../models/task_category.dart';

class PlannerStore extends ChangeNotifier {
  static const _storageKey = 'planner_store_v1';

  List<PlannerTask> tasks = [];
  List<Habit> habits = [];
  List<Goal> goals = [];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return;

    try {
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      final taskList = (decoded['tasks'] as List?) ?? [];
      final habitList = (decoded['habits'] as List?) ?? [];
      final goalList = (decoded['goals'] as List?) ?? [];

      tasks = taskList
          .map((e) => PlannerTask.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      habits = habitList
          .map((e) => Habit.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      goals = goalList
          .map((e) => Goal.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load store: $e');
      }
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final snapshot = {
      'tasks': tasks.map((t) => t.toJson()).toList(),
      'habits': habits.map((h) => h.toJson()).toList(),
      'goals': goals.map((g) => g.toJson()).toList(),
    };
    await prefs.setString(_storageKey, jsonEncode(snapshot));
  }

  // --- Task helpers ---

  List<PlannerTask> tasksForCategory(TaskCategory category) {
    final filtered =
        tasks.where((t) => t.category == category).toList(growable: false);
    filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return filtered;
  }

  Future<void> addTask(String title, TaskCategory category) async {
    tasks.add(
      PlannerTask(
        title: title,
        category: category,
      ),
    );
    await _save();
    notifyListeners();
  }

  Future<void> toggleTask(PlannerTask task) async {
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) return;
    tasks[index] = tasks[index].copyWith(isCompleted: !tasks[index].isCompleted);
    await _save();
    notifyListeners();
  }

  Future<void> deleteTasksByIds(List<String> ids) async {
    tasks.removeWhere((t) => ids.contains(t.id));
    await _save();
    notifyListeners();
  }

  // --- Habit helpers ---

  Future<void> addHabit(String name) async {
    habits.add(Habit(name: name));
    await _save();
    notifyListeners();
  }

  bool isHabitDone(Habit habit, DateTime date) {
    return habit.isDoneOn(date);
  }

  Future<void> toggleHabit(Habit habit, DateTime date) async {
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index == -1) return;
    habits[index].toggleOn(date);
    await _save();
    notifyListeners();
  }

  // --- Goal helpers ---

  Future<void> addGoal(String title) async {
    goals.add(Goal(title: title));
    await _save();
    notifyListeners();
  }

  Future<void> updateGoal(Goal updated) async {
    final index = goals.indexWhere((g) => g.id == updated.id);
    if (index == -1) return;
    goals[index] = updated;
    await _save();
    notifyListeners();
  }
}
