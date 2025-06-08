import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'time_picker_dialog.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onAddTask;

  const AddTaskDialog({super.key, required this.onAddTask});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 1));
  Color _selectedColor = Colors.blue;
  TaskPriority _selectedPriority = TaskPriority.normal;

  final List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task title'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final newTask = Task(
      id: DateTime.now().toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      startTime: _startTime,
      endTime: _endTime,
      color: _selectedColor,
      priority: _selectedPriority,
    );

    widget.onAddTask(newTask);
    Navigator.of(context).pop();
  }

  void _selectStartTime() {
    showDialog(
      context: context,
      builder: (context) => CustomTimePickerDialog(
        initialTime: TimeOfDay.fromDateTime(_startTime),
        onTimeSelected: (time) {
          setState(() {
            _startTime = DateTime(
              _startTime.year,
              _startTime.month,
              _startTime.day,
              time.hour,
              time.minute,
            );

            // If end time is before start time, adjust it
            if (_endTime.isBefore(_startTime)) {
              _endTime = _startTime.add(const Duration(hours: 1));
            }
          });
        },
      ),
    );
  }

  void _selectEndTime() {
    showDialog(
      context: context,
      builder: (context) => CustomTimePickerDialog(
        initialTime: TimeOfDay.fromDateTime(_endTime),
        onTimeSelected: (time) {
          final selectedTime = DateTime(
            _endTime.year,
            _endTime.month,
            _endTime.day,
            time.hour,
            time.minute,
          );

          if (selectedTime.isBefore(_startTime)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('End time must be after start time'),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }

          setState(() {
            _endTime = selectedTime;
          });
        },
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dialogBgColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return Dialog(
      backgroundColor: dialogBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Task',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 24),
            // Basic Info Section
            _buildSection(
              context,
              title: 'Basic Information',
              icon: Icons.info_outline,
              content: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    style: TextStyle(color: textColor),
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter task title',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    style: TextStyle(color: textColor),
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter task description (optional)',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Time Section
            _buildSection(
              context,
              title: 'Time',
              icon: Icons.access_time,
              content: Column(
                children: [
                  // Start Time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Time',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _selectStartTime,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1)
                                : Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatTimeOfDay(
                                    TimeOfDay.fromDateTime(_startTime)),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // End Time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'End Time',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _selectEndTime,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1)
                                : Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatTimeOfDay(
                                    TimeOfDay.fromDateTime(_endTime)),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Color Section
            _buildSection(
              context,
              title: 'Color',
              icon: Icons.palette_outlined,
              content: Container(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colors.length,
                  itemBuilder: (context, index) {
                    final color = _colors[index];
                    final isSelected = _selectedColor == color;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedColor = color),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: isSelected ? 8 : 4,
                                spreadRadius: isSelected ? 2 : 0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 24,
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final sectionColor = isDarkMode ? Colors.grey[800] : Colors.grey[100];
    final titleColor = isDarkMode ? Colors.white : Colors.black87;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: sectionColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }
}
