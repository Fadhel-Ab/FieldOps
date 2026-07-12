import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/task.dart';
import '../repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _taskRepository;

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
    notifyListeners();

    try {
      _tasks = await _taskRepository.getTasks(token);
    } catch (e) {
      if (e is DioException) {
        _errorMessage = e.response?.data["message"] ?? "Login failed";
      } else {
        _errorMessage = "Unexpected error occurred";
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
