import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/task_provider.dart';
import 'package:frontend/services/location_service.dart';
import 'package:frontend/services/camera_service.dart';
import 'package:provider/provider.dart';
import '../../models/task.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;
  final LocationService locationService = LocationService();
  final CameraService cameraService = CameraService();

  TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final authProvider = context.read<AuthProvider>();

    final token = authProvider.token;
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title),
            const SizedBox(height: 12),

            Text(task.description),
            const SizedBox(height: 12),

            Text("Status: ${task.status}"),
            const SizedBox(height: 12),
            TaskButtons(
              task: task,
              onStart: () async {
                final success = await context.read<TaskProvider>().startTask(
                  task.id,
                  context.read<AuthProvider>().token!,
                );
                if (success && context.mounted) {
                  Navigator.pop(context);
                }
              },
              onComplete: () async {
                debugPrint("Before location");

                final position = await locationService.getCurrentLocation();

                debugPrint("After location");

                final image = await cameraService.captureImage();

                debugPrint("After camera");

                if (image == null) {
                  return;
                }
                final success = await taskProvider.completeTask(
                  task.id,
                  token!,
                  position.latitude,
                  position.longitude,
                  image,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }

                debugPrint(position.latitude.toString());
                debugPrint(position.longitude.toString());
                debugPrint(image.path);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TaskButtons extends StatelessWidget {
  final Task task;
  final VoidCallback onStart;
  final VoidCallback onComplete;
  const TaskButtons({
    super.key,
    required this.task,
    required this.onStart,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (task.status == "Pending") {
      return ElevatedButton(
        onPressed: onStart,
        child: const Text("Start Task"),
      );
    }

    if (task.status == "In Progress") {
      return ElevatedButton(
        onPressed: onComplete,
        child: const Text("Complete Task"),
      );
    }

    return const Text("Task Completed", style: TextStyle(color: Colors.green));
  }
}
