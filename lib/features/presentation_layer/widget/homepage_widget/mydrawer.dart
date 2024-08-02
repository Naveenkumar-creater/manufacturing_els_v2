import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
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
import 'package:prominous/features/presentation_layer/widget/homepage_widget/shift_status_widget.dart';

import '../../api_services/employee_di.dart';

class MyDrawer extends StatefulWidget {
  int? deptid;
  MyDrawer({this.deptid});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
  DateTime? lastTapTime;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getProcess();
  }

  //   @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Access the inherited widget and fetch data here
  //   _getProcess();
  // }

  Future<void> _getProcess() async {
    try {
      await processApiService.getProcessdetail(
          context: context, deptid: widget.deptid ?? 0);

      setState(() {
        isLoading = true; // Set isLoading to false when data is fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Set isLoading to false even if there's an error
      });
    }
  }

  int? _selectedIndex; // State variable to store the selected index
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String toDate = DateFormat('dd-MM-yyyy ').format(now);
    String toTime = DateFormat(' HH:mm:ss').format(now);

    final processList =
        Provider.of<ProcessProvider>(context).user?.listofProcessEntity;
    final userName =
        Provider.of<LoginProvider>(context).user?.userLoginEntity?.loginId;
    Size size = MediaQuery.of(context).size;

    var padding = MediaQuery.of(context).padding;
    var topPadding = padding.left * 0.25;
    // var textSize = MediaQuery.of(context).textScaler;

    return Container(
      height: 758.h,
      width: 252.w,
      child: Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
        backgroundColor: Color.fromARGB(150, 235, 236, 255),
        child: Column(
          children: [
            Container(
              height: 155.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30.r, // Adjust the radius as needed
                          backgroundColor: Color.fromARGB(
                              255, 80, 96, 203), // Background color
                          child: Icon(
                            Icons.person, // Profile icon
                            size: 30.r, // Icon size
                            color: Colors.white, // Icon color
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello,',
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Color.fromARGB(255, 80, 96, 203),
                                  fontFamily: "Lexend"),
                            ),
                            Text(
                              '${userName}',
                              style: TextStyle(
                                  fontSize: 24.sp,
                                  color: Color.fromARGB(255, 80, 96, 203),
                                  fontFamily: "Lexend",
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'PROCESS AREA ',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: "Lexend",
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              width: double.infinity,
              height: 450.h,
              child: Scrollbar(
                controller: _scrollController,
                radius: Radius.circular(5.r),
                thickness: 8,
                thumbVisibility: true,
                child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    itemCount: processList?.length ?? 0,
                    itemBuilder: (context, index) => GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.h, horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: _selectedIndex == index
                                  ? Colors.blue.withOpacity(0.3)
                                  : null
                                  
                            ), // Set unique background color for selected tile
                            child: Text(
                              processList![index].processName ?? "",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: "Lexend",
                                  fontSize: 15.sp),
                            ),
                          ),
                          onTap: () async {
                            setState(() {
                              _selectedIndex = index;
                              // Update selected index
                            });
                            final processId = processList[index].processId ?? 0;
                            final deptId = processList[index].deptId ?? 0;
                            try {
                              // Perform shiftStatusService first
                              // Navigator.pop(context);
                              await shiftStatusService.getShiftStatus(
                                  context: context,
                                  deptid: deptId,
                                  processid: processId);
                              final psId = Provider.of<ShiftStatusProvider>(
                                          context,
                                          listen: false)
                                      .user
                                      ?.shiftStatusdetailEntity
                                      ?.psId ??
                                  0;

                              // Perform employeeApiService next
                              await employeeApiService.employeeList(
                                  context: context,
                                  processid: processId,
                                  deptid: deptId,
                                  psid: psId);
                              await listofworkstationService
                                  .getListofWorkstation(
                                      context: context,
                                      deptid: widget.deptid ?? 1057,
                                      psid: psId ?? 0,
                                      processid: processId ?? 0);

                              // Continue with other asynchronous operations sequentially
                              await attendanceCountService.getAttCount(
                                  context: context,
                                  id: processId,
                                  deptid: deptId,
                                  psid: psId);

                              await actualQtyService.getActualQty(
                                  context: context, id: processId, psid: psId);

                              await planQtyService.getPlanQty(
                                  context: context, id: processId, psid: psId);
                            } catch (e) {
                              // Handle any errors that occur during the async operations
                              print('Error fetching data: $e');
                            }
                          },
                        )),
              ),
            ),
            SizedBox(
              height: 80.h,
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/svg/log-out.svg',
                color: Colors.red,
                width: 25.w,
              ),
              title: Text(
                'LOGOUT',
                style: TextStyle(
                    color: Colors.black, fontFamily: "Lexend", fontSize: 16.sp),
              ),
              onTap: () {
                logout.logOutUser(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
