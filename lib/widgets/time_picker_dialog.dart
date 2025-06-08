import 'package:flutter/material.dart';
import '../utils/color_utils.dart';

class CustomTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeSelected;

  const CustomTimePickerDialog({
    Key? key,
    required this.initialTime,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  State<CustomTimePickerDialog> createState() => _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<CustomTimePickerDialog> {
  late TimeOfDay _selectedTime;
  late bool _isAM;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    _isAM = _selectedTime.hour < 12;
  }

  void _toggleAmPm() {
    setState(() {
      _isAM = !_isAM;
      int hour = _selectedTime.hour;

      if (_isAM && hour >= 12) {
        // Convert PM to AM
        hour = hour - 12;
        if (hour == 0) hour = 12;
      } else if (!_isAM && hour < 12) {
        // Convert AM to PM
        hour = hour + 12;
        if (hour == 24) hour = 12;
      }

      _selectedTime = TimeOfDay(
        hour: hour == 12 && _isAM ? 0 : hour,
        minute: _selectedTime.minute,
      );
    });
  }

  void _adjustHour(int amount) {
    setState(() {
      // First convert to 12-hour display format
      int displayHour = _selectedTime.hour % 12;
      if (displayHour == 0) displayHour = 12;

      // Adjust the display hour
      displayHour += amount;

      // Handle 12-hour format overflow
      if (displayHour > 12) {
        displayHour = 1;
      } else if (displayHour < 1) {
        displayHour = 12;
      }

      // Convert back to 24-hour format for internal storage
      int newHour;
      if (_isAM) {
        newHour = displayHour == 12 ? 0 : displayHour;
      } else {
        newHour = displayHour == 12 ? 12 : displayHour + 12;
      }

      _selectedTime = TimeOfDay(hour: newHour, minute: _selectedTime.minute);
    });
  }

  void _adjustMinute(int amount) {
    setState(() {
      int newMinute = _selectedTime.minute + amount;
      int hourChange = 0;

      // Handle minute overflow
      if (newMinute < 0) {
        newMinute = 59;
        hourChange = -1;
      }
      if (newMinute > 59) {
        newMinute = 0;
        hourChange = 1;
      }

      // Update hour if needed
      if (hourChange != 0) {
        // First convert to 12-hour display format
        int displayHour = _selectedTime.hour % 12;
        if (displayHour == 0) displayHour = 12;

        // Adjust the display hour
        displayHour += hourChange;

        // Handle 12-hour format overflow
        if (displayHour > 12) {
          displayHour = 1;
          _isAM = !_isAM; // Toggle AM/PM when going from 12 to 1
        } else if (displayHour < 1) {
          displayHour = 12;
          _isAM = !_isAM; // Toggle AM/PM when going from 1 to 12
        }

        // Convert back to 24-hour format for internal storage
        int newHour;
        if (_isAM) {
          newHour = displayHour == 12 ? 0 : displayHour;
        } else {
          newHour = displayHour == 12 ? 12 : displayHour + 12;
        }

        _selectedTime = TimeOfDay(hour: newHour, minute: newMinute);
      } else {
        _selectedTime = TimeOfDay(hour: _selectedTime.hour, minute: newMinute);
      }
    });
  }

  String _formatHour(int hour) {
    // Convert 24-hour to 12-hour format
    int displayHour = hour % 12;
    if (displayHour == 0) displayHour = 12;
    return displayHour.toString();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardBgColor = isDarkMode ? Colors.grey.shade800 : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color toggleBgColor =
        isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200;
    final Color timeBoxBgColor = isDarkMode
        ? Theme.of(context).primaryColor.withAlpha(26)
        : Theme.of(context).primaryColor.withAlpha(10);
    final Color timeBoxBorderColor = isDarkMode
        ? Theme.of(context).primaryColor.withOpacity(0.4)
        : Theme.of(context).primaryColor.withOpacity(0.3);

    final hourString = _formatHour(_selectedTime.hour);
    final minuteString = _selectedTime.minute.toString().padLeft(2, '0');
    final primaryColor = Theme.of(context).primaryColor;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: cardBgColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title row with AM/PM toggle
            Row(
              children: [
                Text(
                  'Select Time',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const Spacer(),
                // AM/PM toggle button
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: toggleBgColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // AM button
                      GestureDetector(
                        onTap: _isAM ? null : _toggleAmPm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _isAM ? primaryColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            'AM',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _isAM
                                  ? Colors.white
                                  : isDarkMode
                                      ? Colors.grey.shade300
                                      : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      // PM button
                      GestureDetector(
                        onTap: _isAM ? _toggleAmPm : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: !_isAM ? primaryColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            'PM',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: !_isAM
                                  ? Colors.white
                                  : isDarkMode
                                      ? Colors.grey.shade300
                                      : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Time selector row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hour selector
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_up,
                        color: primaryColor,
                        size: 32,
                      ),
                      onPressed: () => _adjustHour(1),
                    ),
                    Container(
                      width: 100,
                      height: 70,
                      decoration: BoxDecoration(
                        color: timeBoxBgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: timeBoxBorderColor),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        hourString,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: primaryColor,
                        size: 32,
                      ),
                      onPressed: () => _adjustHour(-1),
                    ),
                    Text(
                      'Hour',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? Colors.grey.shade300
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),

                // Time separator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),

                // Minute selector
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_up,
                        color: primaryColor,
                        size: 32,
                      ),
                      onPressed: () => _adjustMinute(1),
                    ),
                    Container(
                      width: 100,
                      height: 70,
                      decoration: BoxDecoration(
                        color: timeBoxBgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: timeBoxBorderColor),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        minuteString,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: primaryColor,
                        size: 32,
                      ),
                      onPressed: () => _adjustMinute(-1),
                    ),
                    Text(
                      'Minute',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? Colors.grey.shade300
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.grey.shade300
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.onTimeSelected(_selectedTime);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Select',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
