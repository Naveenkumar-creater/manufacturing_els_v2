import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:prominous/features/presentation_layer/api_services/employee_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofworkstation_di.dart';
import 'package:provider/provider.dart';
import 'package:prominous/features/presentation_layer/api_services/actual_qty_di.dart';
import 'package:prominous/features/presentation_layer/api_services/attendace_count_di.dart';

import 'package:prominous/features/presentation_layer/api_services/login_di.dart';
import 'package:prominous/features/presentation_layer/api_services/plan_qty_di.dart';
import 'package:prominous/features/presentation_layer/api_services/process_di.dart';
import 'package:prominous/features/presentation_layer/api_services/shift_status_di.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
import 'package:prominous/features/presentation_layer/provider/process_provider.dart';
import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';


class MobileMyDrawer extends StatefulWidget {
  int? deptid;
   MobileMyDrawer({this.deptid});
  static late String? processName;

  @override
  State<MobileMyDrawer> createState() => _MobileMyDrawerState();
}

class _MobileMyDrawerState extends State<MobileMyDrawer> {
  ProcessApiService processApiService = ProcessApiService();
  EmployeeApiService employeeApiService = EmployeeApiService();
  LoginApiService logout = LoginApiService();
  final ActualQtyService actualQtyService = ActualQtyService();
  AttendanceCountService attendanceCountService = AttendanceCountService();
  PlanQtyService planQtyService = PlanQtyService();
  ShiftStatusService shiftStatusService = ShiftStatusService();
    ListofworkstationService listofworkstationService =
      ListofworkstationService();

  bool isLoading = false;
  bool isFetching = false;
  bool isTapped=false;
  DateTime? lastTapTime;
  ScrollController _scrollController = ScrollController();

@override
void initState() {
  super.initState();
  getProcess();
}

Future<void> getProcess() async {
  try {
    await processApiService.getProcessdetail(
      context: context,
      deptid: widget.deptid ?? 1057,
    );
    if (mounted) { // Check if the widget is still mounted
      setState(() {
        isLoading = true; // Set isLoading to true when data is fetched
      });
    }
  } catch (e) {
    if (mounted) { // Check if the widget is still mounted
      setState(() {
        isLoading = false; // Set isLoading to false if there's an error
      });
    }
  }
}


  int? _selectedIndex; // State variable to store the selected index
  @override
  Widget build(BuildContext context) {
    final processList =
        Provider.of<ProcessProvider>(context).user?.listofProcessEntity;
    final userName =
        Provider.of<LoginProvider>(context).user?.userLoginEntity?.loginId;

    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,

      elevation: 0,
      width: 250.w,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 70.h, left: 10.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30.r, // Adjust the radius as needed
                        backgroundColor: Color.fromARGB(
                            255, 80, 96, 203), // Background color
                        child: Icon(
                          Icons.person, // Profile icon
                          size: 30, // Icon size
                          color: Colors.white, // Icon color
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello,',
                            style: TextStyle(
                                fontSize: 14.w,
                                color: Color.fromARGB(255, 80, 96, 203),
                                fontFamily: "Lexend"),
                          ),
                          Text(
                            '${userName}',
                            style: TextStyle(
                                fontSize: 20.w,
                                color: Color.fromARGB(255, 80, 96, 203),
                                fontFamily: "Lexend",
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            ListTile(
              title: Text(
                'PROCESS AREA ',
                style: const TextStyle(
                    fontSize: 16, color: Colors.black, fontFamily: "Lexend"),
              ),
            ),
            Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              width: double.infinity,
              height: 450.h,
              child: Scrollbar(
                controller: _scrollController,

                radius: Radius.circular(8),
                thickness: 8.w,
                thumbVisibility: true,
                child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    itemCount: processList?.length ?? 0,
                    itemBuilder: (context, index) => GestureDetector(
                          child: Container(
                            padding:
                                EdgeInsets.only(bottom: 12, top: 12, left: 16),
                            decoration: BoxDecoration(
                              color: _selectedIndex == index
                                  ? Color.fromARGB(110, 163, 173, 236)
                                  : null,
                            ), // Set unique background color for selected tile
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  processList![index].processName ?? "",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: "Lexend"),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                _selectedIndex != index
                                    ? Container(
                                        width: double.infinity,
                                        height: 1.h,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade100),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 0,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade100),
                                      )
                              ],
                            ),
                          ),
                onTap: () async {
  if (isTapped) {
    return;
  }
  isTapped = true;

  Future.microtask(() async {
    try {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        _selectedIndex = index;
      });

      final processId = processList[index].processId ?? 0;
      final deptId = processList[index].deptId ?? 0;

    

      // Fetch shift status
      if (!mounted) return;
      await shiftStatusService.getShiftStatus(
        context: context,
        deptid: deptId,
        processid: processId,
      );

      final psId = Provider.of<ShiftStatusProvider>(context, listen: false)
              .user
              ?.shiftStatusdetailEntity
              ?.psId ??
          0;

      if (psId == 0) {
        throw Exception("Invalid psId: $psId");
      }

      // Fetch employee list
      if (!mounted) return;
      await employeeApiService.employeeList(
        context: context,
        processid: processId,
        deptid: deptId,
        psid: psId,
      );

      // Fetch list of workstations
      if (!mounted) return;
      await listofworkstationService.getListofWorkstation(
        context: context,
        deptid: deptId,
        psid: psId,
        processid: processId,
      );

      // Fetch attendance count
      if (!mounted) return;
      await attendanceCountService.getAttCount(
        context: context,
        id: processId,
        deptid: deptId,
        psid: psId,
      );

      // Fetch actual quantity
      if (!mounted) return;
      await actualQtyService.getActualQty(
        context: context,
        id: processId,
        psid: psId,
      );

      // Fetch plan quantity
      if (!mounted) return;
      await planQtyService.getPlanQty(
        context: context,
        id: processId,
        psid: psId,
      );

        Navigator.pop(context);
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      await Future.delayed(Duration(milliseconds: 200));
      if (mounted) {
        setState(() {
          isTapped = false;
        });
      }
    }
  });
}


                        )),
              ),
            ),
            SizedBox(
              height: 30.h
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/svg/log-out.svg',
                color: Colors.red,
                width: 25.w,
              ),
              title: Text(
                'LOGOUT',
                style:  TextStyle(
                    fontSize: 16.sp, color: Colors.black, fontFamily: "Lexend"),
              ),
              onTap: () {
                logout.logOutUser(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
