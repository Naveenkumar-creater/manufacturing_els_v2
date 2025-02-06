import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prominous/constant/request_data_model/non_production_entry_model.dart';
import 'package:prominous/constant/utilities/customwidgets/custom_textform_field.dart';
import 'package:prominous/constant/utilities/customwidgets/custombutton.dart';
import 'package:prominous/constant/utilities/exception_handle/show_pop_error.dart';

import 'package:prominous/features/domain/entity/listof_rootcause_entity.dart';
import 'package:prominous/features/domain/entity/listofproblem_catagory_entity.dart';
import 'package:prominous/features/presentation_layer/api_services/listofproblem_catagory_di.dart';

import 'package:prominous/features/presentation_layer/api_services/listofrootcause_di.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';

import 'package:prominous/features/presentation_layer/provider/non_production_activity_provider.dart';
import 'package:prominous/features/presentation_layer/provider/non_production_stroed_list_provider.dart';
import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';

import 'package:prominous/features/presentation_layer/widget/timing_widget/update_time.dart';
import 'package:prominous/features/presentation_layer/widget/workstation_entry_widget/change_dateformate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NonProductionActivityPopup extends StatefulWidget {
  NonProductionActivityPopup({
    super.key,
    this.shiftFromTime,
    this.shiftToTime,
    this.showList
  });

  String? shiftFromTime;
  String? shiftToTime;
  bool? showList;

  @override
  State<NonProductionActivityPopup> createState() =>
      _NonProductionActivityPopupState();
}

class _NonProductionActivityPopupState
    extends State<NonProductionActivityPopup> {
  final ListofproblemCategoryservice listofproblemCategoryservice =
      ListofproblemCategoryservice();
  final ListofRootCauseService listofRootCauseService =
      ListofRootCauseService();
  final TextEditingController reasonController = TextEditingController();

  List<Map<String, dynamic>> submittedDataList = [];

  String? fromTime; // This will store the selected time
  String? lastupdatedTime;
  String? selectedName;
  String? selectNonProduction;
  String? NonProductionDropdown;
  String? selectproblemCategoryname;
  String? selectrootcausename;
  String? dropdownProduct;
  String? activityDropdown;
  String? npamname;
  int? npamid;
  String? problemCategoryDropdown;

  List<ListOfIncidentCategoryEntity>? problemCategory;
  List<ListrootcauseEntity>? listofrootcause;

  late DateTime now;
  late int currentYear;
  late int currentMonth;
  late int currentDay;
  late int currentHour;
  late int currentMinute;
  late String currentTime;
  late int currentSecond;
  late DateTime currentDateTime;
  String? currentDate;


  @override
  void initState() {
    super.initState();
    String? shiftTime;
    currentDateTime = DateTime.now();
    now = DateTime.now();
    currentYear = now.year;
    currentMonth = now.month;
    currentDay = now.day;
    currentHour = now.hour;
    currentMinute = now.minute;
    currentSecond = now.second;

    final shiftToTimeString =
        Provider.of<ShiftStatusProvider>(context, listen: false)
            .user
            ?.shiftStatusdetailEntity
            ?.shiftToTime;

    if (shiftToTimeString != null) {
      DateTime? shiftToTime;
      // Parse the shiftToTime
      final shiftToTimeParts = shiftToTimeString.split(':');
      final now = DateTime.now();
      shiftToTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(shiftToTimeParts[0]),
        int.parse(shiftToTimeParts[1]),
        int.parse(shiftToTimeParts[2]),
      );

      // Get the current time
      final currentTime = DateTime.now();

      final shiftFromTimeString =
          Provider.of<ShiftStatusProvider>(context, listen: false)
              .user
              ?.shiftStatusdetailEntity
              ?.shiftFromTime;

      if (shiftFromTimeString != null) {
        // Parse the shiftFromTime
        final shiftFromTimeParts = shiftFromTimeString.split(':');
        final shiftFromTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(shiftFromTimeParts[0]),
          int.parse(shiftFromTimeParts[1]),
          int.parse(shiftFromTimeParts[2]),
        );
// Check if shiftToTime is on the next day
        if (shiftToTime.isBefore(shiftFromTime)) {
          shiftToTime = shiftToTime.add(Duration(days: 1));
        }

        if (currentTime.isAfter(shiftFromTime) &&
            currentTime.isBefore(shiftToTime)) {
          // Current time is within the shift time
          final timeString =
              '$currentHour:${currentMinute.toString().padLeft(2, '0')}:${currentSecond.toString().padLeft(2, '0')}';
          shiftTime = timeString;
        } else {
          // Current time exceeds the shift time
          print("Current time exceeds the shift time.");
          shiftTime = shiftToTimeString;
        }
      } else {
        print("shiftToTime is not available.");
        // Handle the case where shiftToTime is not available
      }
    }
// Assuming currentYear, currentMonth, and currentDay are defined earlier in your code
    fromTime = widget.shiftFromTime;
    lastupdatedTime = widget.shiftToTime;

    currentDate =
          '${currentYear.toString().padLeft(4, '0')}-'
          '${currentMonth.toString().padLeft(2, '0')}-'
          '${currentDay.toString().padLeft(2, '0')} '
          '${currentHour.toString().padLeft(2, '0')}:'
          '${currentMinute.toString().padLeft(2, '0')}:'
          '${currentSecond.toString().padLeft(2, '0')}';

  
    
  }




  @override
  Widget build(BuildContext context) {

    final listofNonProduction =
        Provider.of<NonProductionActivityProvider>(context, listen: false)
            ?.user
            ?.nonProductionActivity;

    final nonProductionlist =
        Provider.of<NonProductionStoredListProvider>(context, listen: false)
            .getNonProductionList;


            print(nonProductionlist);

    // final shiftStarttime = widget.shiftFromTime!.substring(10, fromTime!.length - 0);
    DateTime fromDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(widget.shiftFromTime!);
      
    final shiftStarttime = DateFormat('yyyy-MM-dd HH:mm:ss').format(fromDate);
// final enddate=ChaneDateformate.formatDate(widget.shiftToTime!)
// DateTime date = DateTime.parse(enddate);
// String shiftEndtime = DateFormat('HH:mm:ss').format(date);
    String correctedShiftToTime =
        widget.shiftToTime!.replaceAll(RegExp(r'\s+'), ' ');
    DateTime toDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(correctedShiftToTime);

    final shiftEndtime = DateFormat('yyyy-MM-dd HH:mm:ss').format(toDate);

    // final shiftEndtime =widget.shiftToTime!.substring(10, fromTime!.length - 0);

    // final setStartTime = fromTime!.substring(10, fromTime!.length - 0);
    
    final setStartTime = fromTime;

    Size screenSize = MediaQuery.of(context).size;

    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Color.fromARGB(150, 235, 236, 255),
      child: Padding(
        padding: EdgeInsets.only(top: 16.h),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: screenSize.width < 572 ? EdgeInsets.only(top:20.h,left:8.w,):EdgeInsets.only(left: 16.w,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Non Productive Activities',
                      style: TextStyle(
                        fontSize: screenSize.width < 572 ? 18.sp : 24.sp,
                        color: Color.fromARGB(255, 80, 96, 203),
                        fontFamily: "Lexend",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              ' From Time :',
                              style: TextStyle(
                                fontFamily: "lexend",
                                fontSize:
                              screenSize.width < 572 ? 12.sp : 16.sp,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              fromTime != null
                                  ? fromTime!.substring(0, fromTime!.length - 3)
                                  : 'No Time Selected',
                              style: TextStyle(
                                fontFamily: "lexend",
                                fontSize:
                                       screenSize.width < 572 ? 11.sp : 16.sp,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 10),
                            UpdateFromTime(
                              onTimeChanged: (time) {
                                setState(() {
                                  fromTime = time.toString();
                                });
                              },
                              shiftFromTime: shiftStarttime ?? "",
                              shiftToTime: shiftEndtime ?? "",
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Text(
                              ' To Time      :',
                              style: TextStyle(
                                fontFamily: "lexend",
                                fontSize:
                                    screenSize.width < 572 ? 12.sp : 16.sp,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              lastupdatedTime != null
                                  ? lastupdatedTime!
                                      .substring(0, lastupdatedTime!.length - 3)
                                  : 'No Time Selected',
                              style: TextStyle(
                                fontFamily: "lexend",
                                fontSize:
                                    screenSize.width < 572 ? 11.sp : 16.sp,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 10),
                            UpdateFromTime(
                              onTimeChanged: (time) {
                                setState(() {
                                  lastupdatedTime = time.toString();
                                });
                              },
                              shiftFromTime: setStartTime ?? "",
                              shiftToTime: shiftEndtime ?? "",
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Non Production Activity',
                              style: TextStyle(
                                fontFamily: "lexend",
                                fontSize:
                                    screenSize.width < 572 ? 12.sp : 16.sp,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              ' *',
                              style: TextStyle(
                                fontFamily: "lexend",
                                fontSize: 16.sp,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Container(  
                          width: screenSize.width < 572 ? 280.w : 360.w,
                        height: screenSize.height < 572 ? 35.h : 40.h,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: NonProductionDropdown,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 2.h),
                              border: InputBorder.none,
                            ),
                            hint: Text("Select", style:TextStyle( fontSize:screenSize.width < 572 ? 12.sp : 16.sp, ),),
                            isExpanded: true,
                            onChanged: (String? newvalue) async {
                              if (newvalue != null) {
                                setState(() {
                                  NonProductionDropdown = newvalue;
                                });

                                final selectedNonProduction =
                                    listofNonProduction?.firstWhere(
                                        (nonproduction) =>
                                            nonproduction.npamName == newvalue);

                                npamname = selectedNonProduction?.npamName;

                                if (selectedNonProduction != null &&
                                    selectedNonProduction.npamId != null) {
                                  npamid = selectedNonProduction.npamId;
                                }
                              } else {
                                setState(() {
                                  NonProductionDropdown = null;
                                });
                              }
                            },
                            items: listofNonProduction
                                    ?.map((nonProduction) {
                                      return DropdownMenuItem<String>(
                                        onTap: () {
                                          setState(() {
                                            selectNonProduction =
                                                nonProduction.npamName;
                                          });
                                        },
                                        value: nonProduction.npamName,
                                        child: Text(
                                          nonProduction.npamName ?? "",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: "lexend",
                                            fontSize: screenSize.width < 572
                                                ? 14.sp
                                                : 16.sp,
                                          ),
                                        ),
                                      );
                                    })
                                    .toSet()
                                    .toList() ??
                                [],
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: screenSize.width < 572 ? 280.w : 360.w,
                          height: 100.h,
                          child: CustomTextFormfield(
                            maxline: 5,
                            controller: reasonController,
                            hintText: "Description",
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                        SizedBox(height: 20.w),
                        SizedBox(
                          height: 40.h,
                          child: Row(
                            children: [
                              CustomButton(
                                width: screenSize.width < 572 ? 70.w : 110.w,
                                height: screenSize.width < 572 ? 30.h : 50.h,
                                onPressed: selectNonProduction != null
                                    ? () {
                                        setState(() {
                                          // Function to convert nullable string to DateTime
                                          DateTime? parseDateTime(
                                              String? dateTimeStr) {
                                            if (dateTimeStr == null ||
                                                dateTimeStr.isEmpty) {
                                              return null; // Return null if the string is null or empty
                                            }
                                            return DateTime.tryParse(
                                                dateTimeStr); // Return null if parsing fails
                                          }
                                                int? orgid=Provider.of<LoginProvider>(context, listen: false).user?.userLoginEntity?.orgId  ?? 0;
                                          NonProductionEntryModel data =
                                              NonProductionEntryModel(
                                                  notes: reasonController.text,
                                                  npamFromTime: fromTime,
                                                  npamId: npamid,
                                                  npamToTime: lastupdatedTime,
                                                  npamName: npamname,
                                                  orgid: orgid);

// Convert fromTime and lastupdatedTime to DateTime
                                          DateTime? newFromTime =
                                              parseDateTime(fromTime);
                                          DateTime? newToTime =
                                              parseDateTime(lastupdatedTime);

// Debugging: Print new time range
                                          print(
                                              "New Time Range: From $newFromTime to $newToTime");

// Check if the new time range overlaps with any existing entries
                                          bool timeConflictExists =
                                              nonProductionlist?.any((entry) {
                                                    DateTime? entryFromTime =
                                                        parseDateTime(
                                                            entry.npamFromTime);
                                                    DateTime? entryToTime =
                                                        parseDateTime(
                                                            entry.npamToTime);

                                                    // Debugging: Print existing time range
                                                    print(
                                                        "Existing Time Range: From $entryFromTime to $entryToTime");

                                                    if (entryFromTime == null ||
                                                        entryToTime == null ||
                                                        newFromTime == null ||
                                                        newToTime == null) {
                                                      return false; // Skip comparison if any date is null
                                                    }

                                                    // Check for overlap: new range starts before existing range ends and ends after existing range starts
                                                    bool isOverlap =
                                                        (newFromTime.isBefore(
                                                                entryToTime) &&
                                                            newToTime.isAfter(
                                                                entryFromTime));
                                                    print(
                                                        "Overlap Detected: $isOverlap");

                                                    return isOverlap;
                                                  }) ??
                                                  false;

                                          print(
                                              "time conflict: ${!timeConflictExists}");
// Combine all checks
                                          if (!timeConflictExists) {
                                            Provider.of<NonProductionStoredListProvider>(
                                                    context,
                                                    listen: false)
                                                .addNonProductionList(data);

                                            print("Entry added: $data");
                                          } else {
                                            // Show error if there is an overlap
                                            ShowError.showAlert(context,
                                                "Choose a different time: This time range overlaps with an existing non-production time entry.","Alert");
                                          }
                                        });
                                      }
                                    : null,
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                    fontFamily: "lexend",
                                    fontSize:
                                        screenSize.width < 572 ? 12.w : 15.w,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.green,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              CustomButton(
                                width: screenSize.width < 572 ? 70.w : 110.w,
                                height: screenSize.width < 572 ? 30.h : 50.h,
                                onPressed: selectNonProduction != null
                                    ? () {
                                        Navigator.pop(context);
                                      }
                                    : null,
                                child: Text(
                                  'Closed',
                                  style: TextStyle(
                                    fontFamily: "lexend",
                                    fontSize:
                                        screenSize.width < 572 ? 12.w : 15.w,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.green,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),

    
              Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.w, right: 8.w),
                  child: Container(
                    height: screenSize.height < 572 ? 40.h : 50.h,

                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 45, 54, 104),
                        borderRadius: BorderRadius.circular(5.r)),
                    child: Padding(
                      padding:  EdgeInsets.all(8.sp),
                      child: Row(
                        children: [
                          Container(
                              width: screenSize.width < 572 ? 40.w : 50.w,
                              alignment: Alignment.center,
                              child: Text(
                                "S.No",
                                style: TextStyle(
                                    fontSize:
                                        screenSize.width < 572 ? 14.sp : 16.sp,
                                    fontFamily: "Lexend",
                                    color: Colors.white),
                              )),
                          Container(
                              width: screenSize.width < 572 ? 100.w : 150.w,
                              alignment: Alignment.center,
                              child: Text(
                                "Activity",
                                style: TextStyle(
                                    fontSize:
                                        screenSize.width < 572 ? 14.sp : 16.sp,
                                    fontFamily: "Lexend",
                                    color: Colors.white),
                              )),
                          Container(
                              width: screenSize.width < 572 ? 80.w : 90.w,
                              alignment: Alignment.center,
                              child: Text(
                                "Minutes",
                                style: TextStyle(
                                    fontSize:
                                        screenSize.width < 572 ? 14.sp : 16.sp,
                                    fontFamily: "Lexend",
                                    color: Colors.white),
                              )),
                          // Container(
                          //     width: screenSize.width < 572 ? 50.w : 90.w,
                          //     alignment: Alignment.center,
                          //     child: Text(
                          //       "Delete",
                          //       style: TextStyle(  
                          //           fontSize:
                          //               screenSize.width < 572 ? 14.sp : 16.sp,
                          //           fontFamily: "Lexend",
                          //           color: Colors.white),
                          //     ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              (widget.showList ==true) ? Text(""):
              
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5))),
                width: double.infinity,
                height: 270.h,
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 8.w, right: 8.w),
                    itemCount: nonProductionlist?.length,
                    itemBuilder: (context, index) {
                      final item = nonProductionlist?[index];
                      String formatFromDate =
                          ChaneDateformate.formatDate('${item?.npamFromTime}');
                      String formateToDate =
                          ChaneDateformate.formatDate('${item?.npamToTime}');

                      DateTime fromtime = DateTime.parse(formatFromDate);
                      DateTime totime = DateTime.parse(formateToDate);

                      Duration difference = totime.difference(fromtime);

                      int seconsdifference = difference.inMinutes;

                      return Container(
                        height: 70.h,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1, color: Colors.white),
                          ),
                          color: index % 2 == 0
                              ? Colors.grey.shade50
                              : Colors.grey.shade100,
                        ),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: screenSize.width < 572 ? 40.w : 50.w,
                              child: Text(
                                ' ${index + 1}  ',
                                style: TextStyle(
                                    fontFamily: "lexend",
                                    fontSize:
                                        screenSize.width < 572 ? 14.sp : 16.sp,
                                    color: Colors.black54),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              width: screenSize.width < 572 ? 110.w : 170.w,
                              child: Text(
                                ' ${item?.npamName}  ',
                                style: TextStyle(
                                    fontFamily: "lexend",
                                    fontSize:
                                        screenSize.width < 572 ? 14.sp : 16.sp,
                                    color: Colors.black54),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: screenSize.width < 572 ? 60.w : 80.w,
                              child: Text(
                                ' ${seconsdifference} m ',
                                style: TextStyle(
                                    fontFamily: "lexend",
                                    fontSize:
                                        screenSize.width < 572 ? 14.sp : 16.sp,
                                    color: Colors.black54),
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: screenSize.width < 572 ? 60.w : 95.w,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        nonProductionlist?.removeAt(index);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: screenSize.width < 572
                                          ? 20.sp
                                          : 25.sp,
                                    ))),
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
