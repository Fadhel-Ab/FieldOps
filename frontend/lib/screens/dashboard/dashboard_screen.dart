import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
      ),

      body: _buildBody(taskProvider),
    );
  }


  Widget _buildBody(TaskProvider provider) {

    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }


    if (provider.errorMessage != null) {
      return Center(
        child: Text(provider.errorMessage!),
      );
    }


    if (provider.tasks.isEmpty) {
      return const Center(
        child: Text("No tasks assigned"),
      );
    }


    return ListView.builder(
      itemCount: provider.tasks.length,

      itemBuilder: (context, index) {

        final task = provider.tasks[index];

        return Card(
          margin: const EdgeInsets.all(10),

          child: ListTile(
            title: Text(task.title),

            subtitle: Text(task.description),

            trailing: Text(task.status),
          ),
        );
      },
    );
  }
}