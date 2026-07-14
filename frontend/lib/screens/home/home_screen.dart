import 'package:flutter/material.dart';
import 'package:frontend/screens/task_details/task_details2.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = context.watch<TaskProvider>();

    final assigned = taskProvider.tasks.length;
    final completed = taskProvider.tasks
        .where((t) => t.status == "Completed")
        .length;

    // Calculate completion progress
    final double completionPercent = assigned > 0
        ? (completed / assigned)
        : 0.0;

    // 🔍 Dynmically find the latest "In Progress" and "Pending" tasks
    // This assumes your Task model has '.status' and '.title' (or similar properties)
    final latestInProgress = taskProvider.tasks
        .where((t) => t.status == "In Progress")
        .toList()
        .lastOrNull; // Safely gets the latest, or null if none exist

    final latestPending = taskProvider.tasks
        .where((t) => t.status == "Pending" || t.status == "To Do")
        .toList()
        .lastOrNull;

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light
          ? Colors.grey[50]
          : Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "FieldOps",
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_outlined,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              selectedIcon: Icon(Icons.assignment),
              label: "Tasks",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header / Greeting Section
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to profile later
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 26,
                        child: Icon(Icons.person, size: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back,",
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Ahmed",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Ready for today's tasks?",
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// Progress Tracker Card
              _buildProgressCard(theme, completed, assigned, completionPercent),

              const SizedBox(height: 28),

              Text(
                "Today's Overview",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 14),

              /// Dual Overview Cards
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      theme: theme,
                      icon: Icons.assignment_rounded,
                      iconColor: Colors.blue,
                      value: assigned.toString(),
                      label: "Assigned Tasks",
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      theme: theme,
                      icon: Icons.check_circle_rounded,
                      iconColor: Colors.green,
                      value: completed.toString(),
                      label: "Completed",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// 🚀 NEW SECTION: Quick Focus (In Progress & Pending Shortcuts)
              Text(
                "Quick Focus",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 14),

              // 1. Latest In Progress Card
              if (latestInProgress != null) ...[
                _buildFocusTaskCard(
                  theme: theme,
                  title: "Resume Working",
                  taskName: latestInProgress
                      .title, // Adjust to match your Task model property
                  statusText: "In Progress",
                  statusColor: Colors.orange,
                  icon: Icons.play_circle_filled_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewTaskDetailsScreen(task: latestInProgress),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
              ] else ...[
                _buildEmptyFocusCard(
                  theme: theme,
                  message: "No tasks currently in progress.",
                  icon: Icons.bolt_outlined,
                ),
                const SizedBox(height: 12),
              ],

              // 2. Latest Pending Card
              if (latestPending != null) ...[
                _buildFocusTaskCard(
                  theme: theme,
                  title: "Up Next",
                  taskName: latestPending
                      .title, // Adjust to match your Task model property
                  statusText: "Pending",
                  statusColor: Colors.blueGrey,
                  icon: Icons.pause_circle_filled_rounded,
                  onTap: () {
                    // Navigate directly to this specific task detail screen
                  },
                ),
              ] else ...[
                _buildEmptyFocusCard(
                  theme: theme,
                  message: "No pending tasks remaining!",
                  icon: Icons.done_all_rounded,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Refactored Modern Metric Card Helper
  Widget _buildMetricCard({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  /// Modern Visual Task Progress Card
  Widget _buildProgressCard(
    ThemeData theme,
    int completed,
    int assigned,
    double percent,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withRed(110),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Daily Progress",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  assigned > 0
                      ? "$completed of $assigned Tasks Done"
                      : "No Tasks Scheduled",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: percent,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 55,
                height: 55,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 5,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              Text(
                "${(percent * 100).toInt()}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🛠️ Helper: Dynamic Focus Task Card
  Widget _buildFocusTaskCard({
    required ThemeData theme,
    required String title,
    required String taskName,
    required String statusText,
    required Color statusColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: statusColor, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    taskName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  /// 🛠️ Helper: Empty State Focus Card
  Widget _buildEmptyFocusCard({
    required ThemeData theme,
    required String message,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.2),
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
            size: 22,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
