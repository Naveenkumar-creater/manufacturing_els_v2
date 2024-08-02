import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prominous/features/presentation_layer/api_services/actual_qty_di.dart';
import 'package:prominous/features/presentation_layer/api_services/employee_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofworkstation_di.dart';
import 'package:prominous/features/presentation_layer/api_services/plan_qty_di.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';


import 'package:provider/provider.dart';
import 'package:prominous/features/presentation_layer/api_services/attendace_count_di.dart';
import 'package:prominous/features/presentation_layer/api_services/process_di.dart';
import 'package:prominous/features/presentation_layer/api_services/shift_status_di.dart';

import 'package:prominous/features/presentation_layer/provider/attendance_count_provider.dart';
import 'package:prominous/features/presentation_layer/provider/employee_provider.dart';
import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';
import 'package:prominous/features/presentation_layer/widget/homepage_widget/process_qty_widget.dart';
import 'package:prominous/features/presentation_layer/widget/homepage_widget/shift_status_widget.dart';

import '../../features/presentation_layer/provider/process_provider.dart';
import '../../features/presentation_layer/widget/homepage_widget/emp_workstation_table.dart';
import '../../features/presentation_layer/widget/homepage_widget/mydrawer.dart';



class ResponsiveTabletHomepage extends StatefulWidget {
  const ResponsiveTabletHomepage({Key? key}) : super(key: key);

  @override
  State<ResponsiveTabletHomepage> createState() => _ResponsiveTabletHomepageState();
}

class _ResponsiveTabletHomepageState extends State<ResponsiveTabletHomepage> {
  late Stream<String> current;
  ProcessApiService processApiService = ProcessApiService();
  AttendanceCountService attendanceCountService = AttendanceCountService();
  ShiftStatusService shiftStatusService = ShiftStatusService();
  EmployeeApiService employeeApiService = EmployeeApiService();
  ActualQtyService actualQtyService = ActualQtyService();
  PlanQtyService planQtyService = PlanQtyService();
  ListofworkstationService listofworkstationService = ListofworkstationService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getProcess();
  }

  Future<void> _getProcess() async {
    try {
      final deptId = Provider.of<LoginProvider>(context, listen: false).user?.userLoginEntity?.deptId ?? 0;
      await processApiService.getProcessdetail(context: context, deptid: deptId);

      final processId = Provider.of<ProcessProvider>(context, listen: false).user?.listofProcessEntity?.first?.processId ?? 0;
      await shiftStatusService.getShiftStatus(context: context, deptid: deptId, processid: processId);

      final psId = Provider.of<ShiftStatusProvider>(context, listen: false).user?.shiftStatusdetailEntity?.psId ?? 0;
      await employeeApiService.employeeList(context: context, processid: processId, deptid: deptId, psid: psId);

      await listofworkstationService.getListofWorkstation(context: context, deptid: deptId, psid: psId, processid: processId);
      await attendanceCountService.getAttCount(context: context, id: processId, deptid: deptId, psid: psId);
      await actualQtyService.getActualQty(context: context, id: processId, psid: psId);
      await planQtyService.getPlanQty(context: context, id: processId, psid: psId);

      setState(() {
        isLoading = false; // Set isLoading to false when data is fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Set isLoading to false even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ProcessProvider>(context, listen: true).user;

    final processname = Provider.of<EmployeeProvider>(context, listen: true).user?.listofEmployeeEntity?.isNotEmpty ?? false
        ? Provider.of<EmployeeProvider>(context, listen: true).user?.listofEmployeeEntity?.first.processName ?? "Default"
        : "Default";

    final processId = Provider.of<EmployeeProvider>(context, listen: true).user?.listofEmployeeEntity?.isNotEmpty ?? false
        ? Provider.of<EmployeeProvider>(context, listen: true).user?.listofEmployeeEntity?.first.processId ?? 1
        : 1;

    // final deptid = user?.listofProcessEntity?.first.deptId ?? 1057;
    final shiftgroupId = user?.listofProcessEntity?.first.shiftgroupId ?? 1;

    final totalemployee = Provider.of<AttendanceCountProvider>(context, listen: true).user?.attendanceEntity?.totalEmployees;
    final presentees = Provider.of<AttendanceCountProvider>(context, listen: true).user?.attendanceEntity?.presentees;
    final shiftstatus = Provider.of<ShiftStatusProvider>(context, listen: false).user?.shiftStatusdetailEntity?.psShiftStatus ?? 0;
    final psId = Provider.of<ShiftStatusProvider>(context, listen: false).user?.shiftStatusdetailEntity?.psId ?? 0;
    final deptId = Provider.of<LoginProvider>(context).user?.userLoginEntity?.deptId;

    final Size size = MediaQuery.of(context).size;
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
                : Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyDrawer(deptid: deptId),
                          SizedBox(width: 8.w),
                          Container(
                            height: 758.h,
                            width: 1020.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (processname != "Default")
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [

                                                Expanded(
                                                  child:  Material(
                                                      elevation: 3,
        borderRadius: BorderRadius.circular(5.r),
                                                    child: Container(
                                                      width: 245.w,
                                                      height: 86.h,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromARGB(150, 235, 236, 255),
                                                           borderRadius: BorderRadius.circular(5.r),
                                                       
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            processname,
                                                            style: TextStyle(
                                                                fontSize: 22.sp,
                                                                fontFamily: "Lexend",
                                                                color: Color.fromARGB(255, 80, 96, 203)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                
                                                SizedBox(width: 10.w),
                                                Expanded(
                                                  child:  Material(
        
        elevation: 3,
        borderRadius: BorderRadius.circular(5.r),
                                                    child: Container(
                                                      width: 245.w,
                                                      height: 86.h,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromARGB(150, 235, 236, 255),
                                                        borderRadius: BorderRadius.circular(5.r),
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Attendance",
                                                                style: TextStyle(
                                                                    color: Colors.black87,
                                                                    fontFamily: "Lexend",
                                                                    fontSize: 22.sp),
                                                              ),
                                                              SizedBox(width: 8.w),
                                                              Text(
                                                                "${presentees == null ? 0 : presentees}",
                                                                style: TextStyle(
                                                                  fontFamily: "Lexend",
                                                                  color: Colors.deepPurple,
                                                                  fontSize: 18.sp,
                                                                ),
                                                              ),
                                                              Text(
                                                                "/",
                                                                style: TextStyle(
                                                                    fontFamily: "Lexend",
                                                                    color: Color.fromARGB(255, 179, 157, 219),
                                                                    fontSize: 18.sp),
                                                              ),
                                                              Text(
                                                                "${totalemployee == null ? 0 : totalemployee}",
                                                                style: TextStyle(
                                                                    fontFamily: "Lexend",
                                                                    color: Color.fromARGB(255, 179, 157, 219),
                                                                    fontSize: 18.sp),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                
                                                SizedBox(width: 10.w),
                                                ShitStatusWidget(deptid: deptId ?? 1057, processid: processId, shiftgroupid: shiftgroupId, psid: psId),
                                              ],
                                            ),
                                            SizedBox(height: 8.h),
                                            ProcessQtyWidget(id: processId, psid: psId),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                SizedBox(height: 8.h),
                                processname != "Default" && shiftstatus != 0
                                    ? EmployeeWorkStation(deptid: deptId ?? 1057, psid: psId)
                                    : SizedBox(), // Or any other fallback widget
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
