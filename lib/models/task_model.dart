import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.color,
  });

  // Create a Task from JSON (for storage/retrieval)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      color: Color(json['color']),
    );
  }

  // Convert Task to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'color': color.value,
    };
  }
}

class TaskModel extends ChangeNotifier {
  List<Task> _tasks = [];
  static const String _storageKey = 'tasks';
  bool _isLoading = true;

  // Getter for loading state
  bool get isLoading => _isLoading;

  // Getter for tasks
  List<Task> get tasks => _tasks;

  // Constructor to initialize the model
  TaskModel() {
    _loadTasks();
  }

  // Load tasks from SharedPreferences
  Future<void> _loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getStringList(_storageKey);

      if (tasksJson != null) {
        _tasks = tasksJson
            .map((taskJson) => Task.fromJson(json.decode(taskJson)))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      // If there's an error, we'll start with an empty task list
      _tasks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save tasks to SharedPreferences
  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson =
          _tasks.map((task) => json.encode(task.toJson())).toList();
      await prefs.setStringList(_storageKey, tasksJson);
    } catch (e) {
      debugPrint('Error saving tasks: $e');
    }
  }

  // Add a new task
  void addTask(Task task) {
    _tasks.add(task);
    _saveTasks();
    notifyListeners();
  }

  // Remove a task
  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasks();
    notifyListeners();
  }

  // Update a task
  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      _saveTasks();
      notifyListeners();
    }
  }
}
