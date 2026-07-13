import 'dart:io';

import '../models/task.dart';
import '../services/task_service.dart';

class TaskRepository {
  final TaskService _taskService;

  TaskRepository({required TaskService taskService})
    : _taskService = taskService;

  Future<List<Task>> getTasks(String token) {
    return _taskService.getTasks(token);
  }

  Future<void> startTask(int taskId, String token) {
    return _taskService.startTask(taskId, token);
  }

  Future<void> updateTask(
    int taskId,
    String token,
    String status,
    double latitude,
    double longitude,
    File image,) {
    return _taskService.updateTask(taskId, token, status, latitude, longitude, image);
  }
}
