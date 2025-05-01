import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'time_picker_dialog.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;
  final Function(Task) onUpdateTask;
  final Function(String)? onDeleteTask;

  const EditTaskDialog({
    Key? key,
    required this.task,
    required this.onUpdateTask,
    this.onDeleteTask,
  }) : super(key: key);

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late Color _selectedColor;

  // List of solid colors
  final List<Color> _availableColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.amber,
    Colors.cyan,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.lime,
    Colors.deepOrange,
  ];

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing task data
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description;

    // Initialize times from existing task
    _startTime = TimeOfDay.fromDateTime(widget.task.startTime);
    _endTime = TimeOfDay.fromDateTime(widget.task.endTime);

    // Initialize color
    _selectedColor = widget.task.color;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _selectStartTime() async {
    showDialog(
      context: context,
      builder: (context) => CustomTimePickerDialog(
        initialTime: _startTime,
        onTimeSelected: (time) {
          setState(() {
            _startTime = time;

            // If end time is before start time, adjust it
            if (_endTime.hour < _startTime.hour ||
                (_endTime.hour == _startTime.hour &&
                    _endTime.minute < _startTime.minute)) {
              int endHour = _startTime.hour + 1;
              if (endHour >= 24) {
                endHour = 23;
              }
              _endTime = TimeOfDay(hour: endHour, minute: _startTime.minute);
            }
          });
        },
      ),
    );
  }

  void _selectEndTime() async {
    showDialog(
      context: context,
      builder: (context) => CustomTimePickerDialog(
        initialTime: _endTime,
        onTimeSelected: (time) {
          setState(() {
            _endTime = time;
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

  void _updateTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    // Create updated datetime objects for start and end time (preserve the original date)
    final originalDate = widget.task.startTime;
    final startDateTime = DateTime(
      originalDate.year,
      originalDate.month,
      originalDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    final endDateTime = DateTime(
      originalDate.year,
      originalDate.month,
      originalDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    // Create the updated task
    final updatedTask = Task(
      id: widget.task.id, // Keep the same ID
      title: _titleController.text,
      description: _descriptionController.text,
      startTime: startDateTime,
      endTime: endDateTime,
      color: _selectedColor,
    );

    widget.onUpdateTask(updatedTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDarkMode
        ? Theme.of(context).primaryColor.withOpacity(0.15)
        : Theme.of(context).primaryColor.withOpacity(0.08);
    final Color cardBgColor =
        isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50;
    final Color textFieldBgColor =
        isDarkMode ? Colors.grey.shade700 : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color hintColor =
        isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final Color borderColor = isDarkMode
        ? Theme.of(context).primaryColor.withOpacity(0.4)
        : Theme.of(context).primaryColor.withOpacity(0.2);
    final Color sectionBgColor =
        isDarkMode ? Colors.grey.shade900.withOpacity(0.6) : bgColor;
    final Color sectionTitleColor = isDarkMode
        ? Color(0xFF94BBFF) // Light blue color for dark mode
        : Theme.of(context).primaryColor;
    final Color sectionIconColor = isDarkMode
        ? Color(0xFFB8DAFF) // Slightly lighter blue for dark mode icons
        : Theme.of(context).primaryColor;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      backgroundColor: cardBgColor,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: sectionBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit_note_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Edit Task',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Title input
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: sectionBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 16,
                        bottom: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.title_rounded,
                            color: sectionIconColor,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Title',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: sectionTitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      decoration: BoxDecoration(
                        color: textFieldBgColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(isDarkMode ? 0.3 : 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _titleController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: 'Enter task title',
                          hintStyle: TextStyle(color: hintColor),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Description input
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: sectionBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 16,
                        bottom: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            color: sectionIconColor,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: sectionTitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      decoration: BoxDecoration(
                        color: textFieldBgColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(isDarkMode ? 0.3 : 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _descriptionController,
                        style: TextStyle(color: textColor),
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter task description',
                          hintStyle: TextStyle(color: hintColor),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Time selectors (Start and End)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: sectionBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            color: sectionIconColor,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Time',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: sectionTitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        // Start time selector
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 8),
                                child: Text(
                                  'Start Time',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _selectStartTime,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: textFieldBgColor,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                            isDarkMode ? 0.3 : 0.15),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          _formatTimeOfDay(_startTime),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // End time selector
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 8),
                                child: Text(
                                  'End Time',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _selectEndTime,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: textFieldBgColor,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                            isDarkMode ? 0.3 : 0.15),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          _formatTimeOfDay(_endTime),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Task Color selection
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: sectionBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.palette_outlined,
                          size: 22,
                          color: sectionIconColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Task Color',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: sectionTitleColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Color options with horizontal scroll
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _availableColors.length,
                        itemBuilder: (context, index) {
                          final color = _availableColors[index];
                          final isSelected = _selectedColor == color;

                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = color;
                                });
                              },
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
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Delete button
                  TextButton.icon(
                    onPressed: () {
                      // Ask for confirmation
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: cardBgColor,
                          title: Text('Delete Task',
                              style: TextStyle(color: textColor)),
                          content: Text(
                            'Are you sure you want to delete this task?',
                            style: TextStyle(color: textColor),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                    context); // Close confirmation dialog
                                Navigator.pop(context); // Close edit dialog

                                // Call the delete function if provided
                                if (widget.onDeleteTask != null) {
                                  widget.onDeleteTask!(widget.task.id);
                                }

                                // Show feedback to user
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Task deleted')),
                                );
                              },
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.red),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Delete'),
                  ),
                  const Spacer(),

                  // Cancel button
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: isDarkMode
                            ? Colors.grey.shade300
                            : Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Update Task button
                  ElevatedButton(
                    onPressed: _updateTask,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.save_outlined,
                            size: 18, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
