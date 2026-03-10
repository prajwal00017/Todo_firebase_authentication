import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';
import '../utils/api_config.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];
  final String? authToken;
  final String? userId;

  TaskProvider(this.authToken, this.userId, this._tasks);

  List<TaskModel> get tasks {
    return [..._tasks];
  }

  List<TaskModel> get pendingTasks {
    return _tasks.where((t) => !t.isCompleted).toList();
  }

  List<TaskModel> get completedTasks {
    return _tasks.where((t) => t.isCompleted).toList();
  }

  Future<void> fetchAndSetTasks() async {
    if (userId == null || authToken == null) return;
    
    final url = Uri.parse('${ApiConfig.databaseUrl}/tasks/$userId.json?auth=$authToken');
    
    try {
      final response = await http.get(url);
      if (response.body == 'null') {
        _tasks = [];
        notifyListeners();
        return;
      }
      
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<TaskModel> loadedTasks = [];
      
      extractedData.forEach((taskId, taskData) {
        loadedTasks.add(TaskModel.fromJson(taskData, taskId));
      });
      
      loadedTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _tasks = loadedTasks;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addTask(String title, String description) async {
    if (userId == null || authToken == null) return;
    
    final url = Uri.parse('${ApiConfig.databaseUrl}/tasks/$userId.json?auth=$authToken');
    final newTask = TaskModel(
      id: '', // Placeholder, gets assigned by Firebase
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    
    try {
      final response = await http.post(
        url,
        body: json.encode(newTask.toJson()),
      );
      
      final newId = json.decode(response.body)['name']; // Firebase auto-generated ID
      _tasks.insert(0, TaskModel(
        id: newId,
        title: title,
        description: description,
        createdAt: newTask.createdAt,
      ));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateTask(String id, String newTitle, String newDescription) async {
    if (userId == null || authToken == null) return;
    
    final taskIndex = _tasks.indexWhere((t) => t.id == id);
    if (taskIndex >= 0) {
      final url = Uri.parse('${ApiConfig.databaseUrl}/tasks/$userId/$id.json?auth=$authToken');
      
      try {
        await http.patch(
          url,
          body: json.encode({
            'title': newTitle,
            'description': newDescription,
          }),
        );
        _tasks[taskIndex] = _tasks[taskIndex].copyWith(title: newTitle, description: newDescription);
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    }
  }

  Future<void> toggleTaskStatus(String id) async {
    if (userId == null || authToken == null) return;
    
    final taskIndex = _tasks.indexWhere((t) => t.id == id);
    if (taskIndex >= 0) {
      final oldStatus = _tasks[taskIndex].isCompleted;
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(isCompleted: !oldStatus);
      notifyListeners(); // Optimistic update
      
      final url = Uri.parse('${ApiConfig.databaseUrl}/tasks/$userId/$id.json?auth=$authToken');
      
      try {
        await http.patch(
          url,
          body: json.encode({
            'isCompleted': !oldStatus,
          }),
        );
      } catch (error) {
        _tasks[taskIndex] = _tasks[taskIndex].copyWith(isCompleted: oldStatus); // Rollback
        notifyListeners();
        rethrow;
      }
    }
  }

  Future<void> deleteTask(String id) async {
    if (userId == null || authToken == null) return;
    
    final existingTaskIndex = _tasks.indexWhere((t) => t.id == id);
    TaskModel? existingTask = _tasks[existingTaskIndex];
    
    _tasks.removeAt(existingTaskIndex);
    notifyListeners(); // Optimistic update
    
    final url = Uri.parse('${ApiConfig.databaseUrl}/tasks/$userId/$id.json?auth=$authToken');
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw Exception('Could not delete task.');
      }
      existingTask = null;
    } catch (error) {
      _tasks.insert(existingTaskIndex, existingTask!);
      notifyListeners();
      rethrow;
    }
  }
}
