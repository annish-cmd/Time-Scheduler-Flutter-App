import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum TaskPriority { low, normal, high }

extension TaskPriorityExtension on TaskPriority {
  String get name {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.normal:
        return 'Normal';
      case TaskPriority.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.normal:
        return Colors.blue;
      case TaskPriority.high:
        return Colors.red;
    }
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final TaskPriority priority;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.color,
    this.priority = TaskPriority.normal,
  });

  // Create a Task from JSON (for storage/retrieval)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      color: Color(json['color'] as int),
      priority: TaskPriority
          .values[json['priority'] ?? 1], // Default to normal if not set
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
      'priority': priority.index,
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

  // Sort tasks by priority and time
  void _sortTasks() {
    _tasks.sort((a, b) {
      // First compare by priority (high to low)
      int priorityComparison = b.priority.index.compareTo(a.priority.index);
      if (priorityComparison != 0) return priorityComparison;

      // Then compare by date and time
      int dateComparison = a.startTime.year.compareTo(b.startTime.year);
      if (dateComparison != 0) return dateComparison;

      dateComparison = a.startTime.month.compareTo(b.startTime.month);
      if (dateComparison != 0) return dateComparison;

      dateComparison = a.startTime.day.compareTo(b.startTime.day);
      if (dateComparison != 0) return dateComparison;

      int timeComparison = a.startTime.hour.compareTo(b.startTime.hour);
      if (timeComparison != 0) return timeComparison;

      return a.startTime.minute.compareTo(b.startTime.minute);
    });
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
        _sortTasks(); // Sort tasks after loading
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
    _sortTasks(); // Sort tasks after adding
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
      _sortTasks(); // Sort tasks after updating
      _saveTasks();
      notifyListeners();
    }
  }

  // Reorder tasks (for drag and drop functionality)
  void reorderTasks(List<Task> reorderedTasks) {
    _tasks = reorderedTasks;
    _sortTasks(); // Sort tasks after manual reordering
    _saveTasks();
    notifyListeners();
  }
}
