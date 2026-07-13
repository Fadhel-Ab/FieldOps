import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/task_provider.dart';
import 'package:frontend/services/location_service.dart';
import 'package:provider/provider.dart';
import '../../models/task.dart';


class TaskDetailsScreen extends StatelessWidget {
  final Task task;
  final LocationService locationService = LocationService();

  TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
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
                final position = await locationService.getCurrentLocation();

                debugPrint("Latitude: ${position.latitude}");
                debugPrint("Longitude: ${position.longitude}");
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
