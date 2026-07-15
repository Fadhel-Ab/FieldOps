import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/task_provider.dart';
import 'package:frontend/services/location_service.dart';
import 'package:frontend/services/camera_service.dart';
import 'package:provider/provider.dart';
import '../../models/task.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool isCompleting = false;

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final authProvider = context.read<AuthProvider>();
    final locationService = context.read<LocationService>();
    final cameraService = context.read<CameraService>();

    final token = authProvider.token;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),

            Text(widget.task.description),

            const SizedBox(height: 12),

            Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),

            Text(widget.task.status),
            TaskButtons(
              task: widget.task,
              onStart: () async {
                final success = await context.read<TaskProvider>().startTask(
                  widget.task.id,
                  context.read<AuthProvider>().token!,
                );
                if (success && context.mounted) {
                  Navigator.pop(context);
                }
              },
              onComplete: () async {
                setState(() {
                  isCompleting = true;
                });

                try {
                  final position = await locationService.getCurrentLocation();

                  final image = await cameraService.captureImage();

                  if (image == null) {
                    return;
                  }

                  final success = await taskProvider.completeTask(
                    widget.task.id,
                    token!,
                    position.position.latitude,
                    position.position.longitude,
                    image,
                  );

                  if (success && context.mounted) {
                    Navigator.pop(context);
                  }
                } finally {
                  if (mounted) {
                    setState(() {
                      isCompleting = false;
                    });
                  }
                }
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

    return ElevatedButton(onPressed: null, child: const Text("Task Completed"));
  }
}
