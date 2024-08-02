import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MobileUpdateTime extends StatefulWidget {
  final void Function(String) onTimeChanged; // Made onTimeChanged required
  final String shiftFromTime; // Shift from time in "HH:mm:ss" format
  final String shiftToTime; // Shift to time in "HH:mm:ss" format

  MobileUpdateTime(
      {Key? key,
      required this.onTimeChanged,
      required this.shiftFromTime,
      required this.shiftToTime})
      : super(key: key);

  @override
  State<MobileUpdateTime> createState() => _UpdateTimeState();
}

class _UpdateTimeState extends State<MobileUpdateTime> {
  late DateTime now;
  late int currentYear;
  late int currentMonth;
  late int currentDay;
  late int currentHour;
  late int currentMinute;
  late int currentSecond;
  late String currentTime; // Initialized to avoid null check

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    currentYear = now.year;
    currentMonth = now.month;
    currentDay = now.day;
    currentHour = now.hour;
    currentMinute = now.minute;
    currentSecond = now.second;
    currentTime =
        '$currentYear-$currentMonth-$currentDay $currentHour:${currentMinute.toString().padLeft(2, '0')}:${currentSecond.toString().padLeft(2, '0')}'; // Initial time display
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 25,
          height: 25,
          child: FloatingActionButton(
            heroTag: 'decrementButton',
            backgroundColor: Colors.grey.shade200,
            tooltip: 'Decrement',
            mini: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onPressed: () {
              setState(() {
                if (currentMinute >= 30) {
                  currentMinute -= 30;
                } else {
                  if (currentHour == 0) {
                    currentHour = 23;
                    currentMinute = 30;
                  } else {
                    currentHour -= 1;
                    currentMinute = 30;
                  }
                }
              });
              updateTime();
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 85),
              child: Icon(
                Icons.minimize,
                color: Colors.black54,
                size: 15.sp,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(
          "30",
          style: TextStyle(fontSize: 16.sp, color: Colors.black54),
        ),
        SizedBox(
          width: 10.w,
        ),
        SizedBox(
          width: 25.w,
          height: 25.h,
          child: FloatingActionButton(
            heroTag: 'IncrementButton',
            backgroundColor: Colors.grey.shade200,
            tooltip: 'Increment',
            mini: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onPressed: () {
              // Increase time by 30 minutes
              setState(() {
                if (currentMinute < 30) {
                  currentMinute += 30;
                } else {
                  if (currentHour == 23) {
                    currentHour = 0;
                    currentMinute = 0;
                  } else {
                    currentHour += 1;
                    currentMinute = 0;
                  }
                }
              });
              updateTime(); // Update time after each change
            },
            child:  Icon(Icons.add, color: Colors.black54, size: 15.sp),
          ),
        ),
        SizedBox(
          width: 16,
        ),
        ElevatedButton(
          onPressed: () async {
            final TimeOfDay? result = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: currentHour, minute: currentMinute),
              initialEntryMode: TimePickerEntryMode.input,
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    alwaysUse24HourFormat: true,
                  ),
                  child: child!,
                );
              },
            );

            if (result != null) {
              setState(() {
                // Update only the time part, keeping the date part fixed
                currentHour = result.hour;
                currentMinute = result.minute;
                currentSecond = 0; // reset seconds to 0
              });
              updateTime();
            }
          },
          child: Text(
            "Set Time",
            style: TextStyle(fontSize: 12.sp, fontFamily: "Lexend" ,color: Colors.black54),
          ),
        ),
      ],
    );
  }

  void updateTime() {
    setState(() {
      final selectedTime = DateTime(
        currentYear,
        currentMonth,
        currentDay,
        currentHour,
        currentMinute,
        currentSecond,
      );

      final shiftFromTimeParts = widget.shiftFromTime.split(':');
      var shiftFromTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(shiftFromTimeParts[0]),
        int.parse(shiftFromTimeParts[1]),
        int.parse(shiftFromTimeParts[2]),
      );

      final shiftToTimeParts = widget.shiftToTime.split(':');
      var shiftToTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(shiftToTimeParts[0]),
        int.parse(shiftToTimeParts[1]),
        int.parse(shiftToTimeParts[2]),
      );

      if (shiftToTime.isBefore(shiftFromTime)) {
        // Shift period crosses midnight
        if (selectedTime.isBefore(shiftFromTime)) {
          shiftFromTime = shiftFromTime.subtract(Duration(days: 1));
        } else {
          shiftToTime = shiftToTime.add(Duration(days: 1));
        }
      }

      if (selectedTime.isBefore(shiftFromTime)) {
        currentHour = shiftFromTime.hour;
        currentMinute = shiftFromTime.minute;
        currentSecond = shiftFromTime.second;
      } else if (selectedTime.isAfter(shiftToTime)) {
        currentHour = shiftToTime.hour;
        currentMinute = shiftToTime.minute;
        currentSecond = shiftToTime.second;
      }

      currentTime =
          '$currentYear-$currentMonth-$currentDay $currentHour:${currentMinute.toString().padLeft(2, '0')}:${currentSecond.toString().padLeft(2, '0')}'; // Update currentTime
    });

    widget
        .onTimeChanged(currentTime); // Call the callback with the updated time
  }
}
