import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prominous/constant/utilities/exception_handle/show_pop_error.dart';

class UpdateFromTime extends StatefulWidget {
  final void Function(String) onTimeChanged;
  final String shiftFromTime; // e.g., "2024-09-05 08:00:00"
  final String shiftToTime; // e.g., "2024-09-05 18:00:00"

  UpdateFromTime({
    Key? key,
    required this.onTimeChanged,
    required this.shiftFromTime,
    required this.shiftToTime,
  }) : super(key: key);

  @override
  State<UpdateFromTime> createState() => _UpdateFromTimeState();
}

class _UpdateFromTimeState extends State<UpdateFromTime> {
  late DateTime selectedTime;

  @override
  void initState() {
    super.initState();
    // Parse the shiftFromTime as initial selectedTime
    selectedTime = DateTime.parse(widget.shiftFromTime);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(
          width: screenSize.width < 572 ? 90.w : 100.w,
          height: 30.h,
          child: ElevatedButton(
            onPressed: () async {
              // Open time picker with initial selectedTime
              final TimeOfDay? result = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute),
                initialEntryMode: TimePickerEntryMode.input,
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  );
                },
              );

              if (result != null) {
                setState(() {
                  // Update selectedTime with the new time but keep the date part intact
                  selectedTime = DateTime(
                    selectedTime.year,
                    selectedTime.month,
                    selectedTime.day,
                    result.hour,
                    result.minute,
                    0, // Reset seconds to 0
                  );
                });
                updateTime();
              }
            },
            child: Text(
              "Set Time",
              style: TextStyle(fontSize: screenSize.width < 572 ? 9.w.sp : 12.sp),
            ),
          ),
        ),
      ],
    );
  }

  void updateTime() {
    // Parse shiftFromTime and shiftToTime
    final shiftFromTime = DateTime.parse(widget.shiftFromTime);
    final shiftToTime = DateTime.parse(widget.shiftToTime);

    // Adjust for midnight crossing
    DateTime adjustedShiftToTime = shiftToTime;

    // If shiftToTime is before or equal to shiftFromTime, it means the shift crosses midnight
    if (shiftToTime.isBefore(shiftFromTime) || shiftToTime == shiftFromTime) {
      adjustedShiftToTime = shiftToTime.add(Duration(days: 1));
    }

    // Validate selectedTime to be within the range of shiftFromTime and shiftToTime
    if (selectedTime.isBefore(shiftFromTime)) {
      selectedTime = shiftFromTime;
      ShowError.showAlert(context, "Timing entry should be within the current shift time window.", "Alert");
    } else if (selectedTime.isAfter(adjustedShiftToTime)) {
      selectedTime = adjustedShiftToTime;
      ShowError.showAlert(context, "Timing entry should be within the current shift time window.", "Alert");
    }

    // Format the selectedTime into the correct format and pass it back
    String formattedTime = '${selectedTime.year.toString().padLeft(4, '0')}-'
        '${selectedTime.month.toString().padLeft(2, '0')}-'
        '${selectedTime.day.toString().padLeft(2, '0')} '
        '${selectedTime.hour.toString().padLeft(2, '0')}:'
        '${selectedTime.minute.toString().padLeft(2, '0')}:'
        '${selectedTime.second.toString().padLeft(2, '0')}';

    widget.onTimeChanged(formattedTime); // Callback with the updated time
  }
}
