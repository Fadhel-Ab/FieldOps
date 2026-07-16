import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
    debugPrint("Calling PUT for task $taskId");
    await _dio.put(
      "${ApiConstants.tasks}/$taskId",
      data: {"status": "In Progress"},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    debugPrint("PUT succeeded");
  }

  Future<void> updateTask(
    int taskId,
    String token,
    String status,
    double latitude,
    double longitude,
    File image,
    String note,
  ) async {
    final formData = FormData.fromMap({
      "status": status,
      "latitude": latitude,
      "longitude": longitude,
      "image": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
      "note": note,
    });

    await _dio.put(
      "${ApiConstants.tasks}/$taskId",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        },
      ),
    );
  }
}
