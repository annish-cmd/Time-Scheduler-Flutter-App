import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'package:intl/intl.dart';
import 'edit_task_dialog.dart';
import 'package:provider/provider.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(String) onDeleteTask;
  final Function(String) onEditTask;

  const TaskList({
    Key? key,
    required this.tasks,
    required this.onDeleteTask,
    required this.onEditTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color titleColor =
        isDarkMode ? Colors.white : const Color(0xFF424242);
    final Color descriptionColor =
        isDarkMode ? Colors.grey[300]! : Colors.grey[600]!;

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [Colors.grey[700]!, Colors.grey[800]!]
                      : [const Color(0xFFF0F0F0), const Color(0xFFE6E6E6)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 60,
                color: isDarkMode ? Colors.grey[400] : const Color(0xFF9E9E9E),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No tasks yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : const Color(0xFF616161),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Add a task to get started',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : const Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      );
    }

    // List of pastel colors for the tasks
    final List<Color> taskColors = [
      const Color(0xFF90CAF9), // Light Blue
      const Color(0xFFA5D6A7), // Light Green
      const Color(0xFFFFCC80), // Light Orange
      const Color(0xFFCE93D8), // Light Purple
      const Color(0xFFEF9A9A), // Light Red
    ];

    return ListView.builder(
      itemCount: tasks.length,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      itemBuilder: (context, index) {
        final task = tasks[index];

        // Use color from task, or fall back to color based on index if task color is default
        final Color cardColor = task.color == Colors.blue
            ? taskColors[index % taskColors.length]
            : task.color;

        // Format time in 12-hour format with AM/PM
        final timeFormat = DateFormat('hh:mm a');
        final startTime = timeFormat.format(task.startTime);
        final endTime = timeFormat.format(task.endTime);

        return Dismissible(
          key: Key(task.id),
          background: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 30,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            // Delete the task
            onDeleteTask(task.id);

            // Show a snackbar to confirm deletion
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Task deleted'),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    // Restore the task using TaskModel (requires access via Provider)
                    Provider.of<TaskModel>(context, listen: false)
                        .addTask(task);
                  },
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          },
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                final bool dialogIsDarkMode =
                    Theme.of(context).brightness == Brightness.dark;
                final Color dialogBgColor =
                    dialogIsDarkMode ? Colors.grey.shade800 : Colors.white;
                final Color dialogTextColor =
                    dialogIsDarkMode ? Colors.white : Colors.black87;

                return AlertDialog(
                  backgroundColor: dialogBgColor,
                  title: Text(
                    'Delete Task',
                    style: TextStyle(color: dialogTextColor),
                  ),
                  content: Text(
                    'Are you sure you want to delete this task?',
                    style: TextStyle(color: dialogTextColor),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        'DELETE',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? cardColor.withOpacity(0.4)
                  : cardColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onEditTask(task.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.grey.shade700
                              : Colors.black.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Time indicator
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? cardColor.withOpacity(0.8) : cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$startTime - $endTime',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                // Description
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    task.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: descriptionColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
