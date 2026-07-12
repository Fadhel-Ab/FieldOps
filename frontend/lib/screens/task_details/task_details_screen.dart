import 'package:flutter/material.dart';
import '../../models/task.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

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
            TaskButtons(task: task),
          ],
        ),
      ),
    );
  }
}

class TaskButtons extends StatelessWidget {
  final Task task;

  const TaskButtons({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    if (task.status == "Pending") {
      return ElevatedButton(
        onPressed: () {
          // TODO: Start Task
        },
        child: const Text("Start Task"),
      );
    }

    if (task.status == "In Progress") {
      return ElevatedButton(
        onPressed: () {
          // TODO: Complete Task
        },
        child: const Text("Complete Task"),
      );
    }

    return const Text("Task Completed", style: TextStyle(color: Colors.green));
  }
}
