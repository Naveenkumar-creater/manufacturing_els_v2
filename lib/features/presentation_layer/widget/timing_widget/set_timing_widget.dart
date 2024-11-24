import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prominous/constant/utilities/customwidgets/custombutton.dart';

class UpdateTime extends StatefulWidget {
  final void Function(String) onTimeChanged;
  final String shiftFromTime;  // Expected format: "HH:mm:ss"
  final String shiftToTime;    // Expected format: "HH:mm:ss"
  final DateTime shiftDate;    // Date on which the shift starts

  UpdateTime({
    Key? key,
    required this.onTimeChanged,
    required this.shiftFromTime,
    required this.shiftToTime,
    required this.shiftDate,
  }) : super(key: key);

  @override
  State<UpdateTime> createState() => _UpdateTimeState();
}

class _UpdateTimeState extends State<UpdateTime> {
  late DateTime selectedDateTime;
  late DateTime shiftFromDateTime;
  late DateTime shiftToDateTime;
  late String formattedTime;

  @override
  void initState() {
    super.initState();
    _initializeTimes();
  }

  void _initializeTimes() {
    // Parse shiftFromTime and shiftToTime
    final shiftFromParts = widget.shiftFromTime.split(':');
    final shiftToParts = widget.shiftToTime.split(':');

    // Set the shiftFromDateTime and shiftToDateTime using the provided shift date
    shiftFromDateTime = DateTime(
      widget.shiftDate.year,
      widget.shiftDate.month,
      widget.shiftDate.day,
      int.parse(shiftFromParts[0]),
      int.parse(shiftFromParts[1]),
      int.parse(shiftFromParts[2]),
    );

    shiftToDateTime = DateTime(
      widget.shiftDate.year,
      widget.shiftDate.month,
      widget.shiftDate.day,
      int.parse(shiftToParts[0]),
      int.parse(shiftToParts[1]),
      int.parse(shiftToParts[2]),
    );

    // If shiftToTime is before shiftFromTime, it means the shift crosses midnight
    if (shiftToDateTime.isBefore(shiftFromDateTime)) {
      shiftToDateTime = shiftToDateTime.add(Duration(days: 1));  // Move to the next day
    }

    // Set selectedDateTime to the shiftFromDateTime initially
    selectedDateTime = shiftFromDateTime;
    formattedTime = _formatDateTime(selectedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Decrement Button
        SizedBox(
          width: 30,
          height: 30,
          child: FloatingActionButton(
            heroTag: 'decrementButton',
            backgroundColor: Colors.white,
            tooltip: 'Decrement',
            mini: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onPressed: () {
              setState(() {
                _decrementTime();
              });
              _updateTime();
            },
            child: Icon(Icons.remove, color: Colors.black, size: 20),
          ),
        ),
        SizedBox(width: 16),
        Text(
          "30",
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
        SizedBox(width: 16),
        // Increment Button
        SizedBox(
          width: 30,
          height: 30,
          child: FloatingActionButton(
            heroTag: 'incrementButton',
            backgroundColor: Colors.white,
            tooltip: 'Increment',
            mini: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onPressed: () {
              setState(() {
                _incrementTime();
              });
              _updateTime();
            },
            child: Icon(Icons.add, color: Colors.black, size: 20),
          ),
        ),
        SizedBox(width: 16),
        // Set Time Button
        CustomButton(
         
         
          onPressed: () async {
            final TimeOfDay? result = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(
                hour: selectedDateTime.hour,
                minute: selectedDateTime.minute,
              ),
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
                // Update selectedDateTime with the new time while keeping the date
                selectedDateTime = DateTime(
                  widget.shiftDate.year,
                  widget.shiftDate.month,
                  widget.shiftDate.day,
                  result.hour,
                  result.minute,
                );
        
                // Handle midnight crossing
                if (selectedDateTime.isBefore(shiftFromDateTime) && result.hour < shiftFromDateTime.hour) {
                  selectedDateTime = selectedDateTime.add(Duration(days: 1));
                }
        
                // Validate: Ensure selected time is within the shift time range
                if (selectedDateTime.isBefore(shiftFromDateTime)) {
                  selectedDateTime = shiftFromDateTime;
                } else if (selectedDateTime.isAfter(shiftToDateTime)) {
                  selectedDateTime = shiftToDateTime;
                }
              });
        
              _updateTime(); // Call the update function to handle the new time
            }
          },
         width:MediaQuery.of(context).size.width<576 ? 80.w:120.h,
                        height:MediaQuery.of(context).size.width<576 ? 30.h : 35.h,
                          backgroundColor: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(50.r),
                                                
          child: Text("Set Time",style: TextStyle(fontFamily: "lexend",fontSize: MediaQuery.of(context).size.width<576 ? 12.sp: 14.sp),),
        ),
      ],
    );
  }
  

    // Decrement time by 30 minutes
  void _decrementTime() {
    selectedDateTime = selectedDateTime.subtract(Duration(minutes: 30));
    if (selectedDateTime.isBefore(shiftFromDateTime)) {
      selectedDateTime = shiftFromDateTime;
    }
  }

  // Increment time by 30 minutes
  void _incrementTime() {
    selectedDateTime = selectedDateTime.add(Duration(minutes: 30));
    if (selectedDateTime.isAfter(shiftToDateTime)) {
      selectedDateTime = shiftToDateTime;
    }
  }

  // Update the time and call the callback function
  void _updateTime() {
    formattedTime = _formatDateTime(selectedDateTime);
    widget.onTimeChanged(formattedTime);
  }

  // Format the date and time as a string
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }
}
