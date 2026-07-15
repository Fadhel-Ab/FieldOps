import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/task_details/task_details2.dart';
import 'package:frontend/screens/task_details/task_details_screen.dart';
import 'package:frontend/widgets/start_task.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = context.watch<TaskProvider>();
    final authProvider = context.read<AuthProvider>();

    return DefaultTabController(
      length: 3, // Three main states: To Do/Pending, In Progress, Completed
      child: Scaffold(
        backgroundColor: theme.brightness == Brightness.light
            ? Colors.grey[50]
            : Colors.grey[900],
        appBar: AppBar(
          title: Text(
            "My Tasks",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          bottom: TabBar(
            isScrollable: false,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Pending"),
                    const SizedBox(width: 4),
                    _buildCountBadge(
                      context,
                      taskProvider.tasks
                          .where(
                            (t) => t.status == "Pending" || t.status == "To Do",
                          )
                          .length,
                      Colors.blueGrey,
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Active"),
                    const SizedBox(width: 4),
                    _buildCountBadge(
                      context,
                      taskProvider.tasks
                          .where((t) => t.status == "In Progress")
                          .length,
                      Colors.orange,
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Done"),
                    const SizedBox(width: 4),
                    _buildCountBadge(
                      context,
                      taskProvider.tasks
                          .where((t) => t.status == "Completed")
                          .length,
                      Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(child: _buildBody(context, taskProvider, authProvider)),
      ),
    );
  }

  /// Little numeric bubbles on the tab bar so workers know how many jobs are in each phase
  Widget _buildCountBadge(BuildContext context, int count, Color color) {
    if (count == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    TaskProvider provider,
    AuthProvider authProvider,
  ) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return _buildErrorState(context, provider);
    }

    if (provider.tasks.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.assignment_turned_in_outlined,
        message: "No tasks have been assigned to you yet.",
      );
    }

    // Filter tasks based on tabs
    final pendingTasks = provider.tasks
        .where((t) => t.status == "Pending" || t.status == "To Do")
        .toList();
    final activeTasks = provider.tasks
        .where((t) => t.status == "In Progress")
        .toList();
    final completedTasks = provider.tasks
        .where((t) => t.status == "Completed")
        .toList();

    return TabBarView(
      children: [
        _buildTaskListView(
          context,
          pendingTasks,
          "No pending tasks!",
          Icons.check_circle_outline,
          provider,
          authProvider,
        ),
        _buildTaskListView(
          context,
          activeTasks,
          "No tasks currently in progress.",
          Icons.play_circle_outline,
          provider,
          authProvider,
        ),
        _buildTaskListView(
          context,
          completedTasks,
          "No completed tasks yet.",
          Icons.done_all_rounded,
          provider,
          authProvider,
        ),
      ],
    );
  }

  Widget _buildTaskListView(
    BuildContext context,
    List<dynamic> filteredList,
    String emptyMessage,
    IconData emptyIcon,
    TaskProvider provider,
    AuthProvider authProvider,
  ) {
    if (filteredList.isEmpty) {
      return _buildEmptyState(context, icon: emptyIcon, message: emptyMessage);
    }

    return RefreshIndicator(
      onRefresh: () async {
        final token = context.read<AuthProvider>().token;

        if (token != null) {
          await provider.fetchTasks(token, force: true);
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final task = filteredList[index];
          return _buildTaskCard(context, task);
        },
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, dynamic task) {
    final theme = Theme.of(context);

    // Dynamic color coding based on status
    Color statusColor;
    IconData statusIcon;
    switch (task.status) {
      case "In Progress":
        statusColor = Colors.orange;
        statusIcon = Icons.pending_actions_rounded;
        break;
      case "Completed":
        statusColor = Colors.green;
        statusIcon = Icons.task_alt_rounded;
        break;
      default:
        statusColor = Colors.blue;
        statusIcon = Icons.hourglass_empty_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            final isPending =
                task.status == "Pending" || task.status == "To Do";

            if (isPending) {
              // Show the elegant confirmation sheet instead of pushing the details page
              showStartTaskSheet(context, task);
            } else if (task.status == "In Progress") {
              // Active or Completed tasks go straight to the action/details page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NewTaskDetailsScreen(task: task),
                ),
              );
            } else {
              Null;
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 12, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            task.status,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  task.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
                const SizedBox(height: 14),
                Divider(
                  height: 1,
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.3,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Due Today", // Replace dynamically if your task model has a date string (e.g. task.dueDate)
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String message,
  }) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, TaskProvider provider) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 12),
            Text(
              provider.errorMessage ?? "An unknown error occurred",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final token = context.read<AuthProvider>().token;

                if (token != null) {
                  await provider.fetchTasks(token, force: true);
                }
              },
              child: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }
}
