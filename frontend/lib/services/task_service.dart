import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../models/task.dart';

class TaskService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<List<Task>> getTasks(String token) async {
    final response = await _dio.get(
      ApiConstants.tasks,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return (response.data as List).map((task) => Task.fromJson(task)).toList();
  }

  Future<void> startTask(int taskId, String token) async {
    await _dio.put(
      "${ApiConstants.tasks}/$taskId",
      data: {"status": "In Progress"},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
