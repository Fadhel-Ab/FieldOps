import '../models/task.dart';
import '../services/task_service.dart';

class TaskRepository {
  final TaskService _taskService;

  TaskRepository({
    required TaskService taskService,
  }) : _taskService = taskService;


  Future<List<Task>> getTasks(String token) {
    return _taskService.getTasks(token);
  }

  Future<void> startTask(int taskId,String token) {
    return _taskService.startTask(taskId, token);
  }
}