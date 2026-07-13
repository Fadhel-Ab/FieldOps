import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/task.dart';
import '../repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _taskRepository;
  String? _lastToken;

  TaskProvider({required TaskRepository taskRepository})
    : _taskRepository = taskRepository;

  bool _isLoading = false;
  String? _errorMessage;
  List<Task> _tasks = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Task> get tasks => _tasks;

  Future<void> fetchTasks(String token) async {
    _isLoading = true;
    _errorMessage = null;
    _lastToken = token;
    notifyListeners();

    try {
      _tasks = await _taskRepository.getTasks(token);
    } catch (e, stackTrace) {
      if (e is DioException) {
        _errorMessage = e.response?.data["message"] ?? "Failed to load tasks";
      } else {
        debugPrint(e.toString());
        debugPrint(stackTrace.toString());
        _errorMessage = "Unexpected error occurred";
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> startTask(int taskId, String token) async {
    _isLoading = true;
    _errorMessage = null;
    _lastToken = token;
    notifyListeners();

    try {
      await _taskRepository.startTask(taskId, token);
      await fetchTasks(token);
      return true;
    } catch (e, stackTrace) {
      if (e is DioException) {
        _errorMessage = e.response?.data["message"] ?? "Failed to update tasks";
        return false;
      } else {
        debugPrint(e.toString());
        debugPrint(stackTrace.toString());
        _errorMessage = "Unexpected error occurred";
        return false;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearTasks() {
    _lastToken = null;
    _tasks = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
