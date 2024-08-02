import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prominous/features/presentation_layer/api_services/actual_qty_di.dart';
import 'package:prominous/features/presentation_layer/api_services/attendace_count_di.dart';
import 'package:prominous/features/presentation_layer/api_services/employee_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofworkstation_di.dart';
import 'package:prominous/features/presentation_layer/api_services/plan_qty_di.dart';
import 'package:prominous/features/presentation_layer/api_services/process_di.dart';
import 'package:prominous/features/presentation_layer/api_services/shift_status_di.dart';
import 'package:prominous/features/presentation_layer/mobile_page/mobile_home_shiftstatus_widget.dart';
import 'package:prominous/features/presentation_layer/mobile_page/mobile_mydrawer.dart';
import 'package:prominous/features/presentation_layer/mobile_page/mobile_processqty_widget.dart';
import 'package:prominous/features/presentation_layer/provider/attendance_count_provider.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
import 'package:prominous/features/presentation_layer/provider/process_provider.dart';
import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';
import 'package:prominous/features/presentation_layer/mobile_page/emp_workstation_table_mob.dart';
import 'package:provider/provider.dart';
import '../../features/presentation_layer/provider/employee_provider.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({Key? key}) : super(key: key);

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Stream<String> current;
  ProcessApiService processApiService = ProcessApiService();
  AttendanceCountService attendanceCountService = AttendanceCountService();
  ShiftStatusService shiftStatusService = ShiftStatusService();
  EmployeeApiService employeeApiService = EmployeeApiService();
  ActualQtyService actualQtyService = ActualQtyService();
  PlanQtyService planQtyService = PlanQtyService();
  ListofworkstationService listofworkstationService =
      ListofworkstationService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getProcess();
  }

  Future<void> _getProcess() async {
    try {
      final deptId = Provider.of<LoginProvider>(context, listen: false)
              .user
              ?.userLoginEntity
              ?.deptId ??
          0;
      await processApiService.getProcessdetail(
          context: context, deptid: deptId);

      final processId = Provider.of<ProcessProvider>(context, listen: false)
              .user
              ?.listofProcessEntity
              ?.first
              ?.processId ??
          0;
      await shiftStatusService.getShiftStatus(
          context: context, deptid: deptId, processid: processId);

      final psId = Provider.of<ShiftStatusProvider>(context, listen: false)
              .user
              ?.shiftStatusdetailEntity
              ?.psId ??
          0;
      await employeeApiService.employeeList(
          context: context, processid: processId, deptid: deptId, psid: psId);

      await listofworkstationService.getListofWorkstation(
          context: context, deptid: deptId, psid: psId, processid: processId);
      await attendanceCountService.getAttCount(
          context: context, id: processId, deptid: deptId, psid: psId);
      await actualQtyService.getActualQty(
          context: context, id: processId, psid: psId);
      await planQtyService.getPlanQty(
          context: context, id: processId, psid: psId);

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
    final processname = Provider.of<EmployeeProvider>(context, listen: true)
                .user
                ?.listofEmployeeEntity
                ?.isNotEmpty ??
            false
        ? Provider.of<EmployeeProvider>(context, listen: true)
                .user
                ?.listofEmployeeEntity
                ?.first
                .processName ??
            "Default"
        : "Default";

    final processId = Provider.of<EmployeeProvider>(context, listen: true)
                .user
                ?.listofEmployeeEntity
                ?.isNotEmpty ??
            false
        ? Provider.of<EmployeeProvider>(context, listen: true)
                .user
                ?.listofEmployeeEntity
                ?.first
                .processId ??
            1: 1;

   final deptid = (user?.listofProcessEntity?.isNotEmpty ?? false) ? user!.listofProcessEntity!.first.deptId : 1057;
                      
    final shiftgroupId =  user?.listofProcessEntity?.first?.shiftgroupId ?? 1;

    final totalemployee =
        Provider.of<AttendanceCountProvider>(context, listen: true)
            .user
            ?.attendanceEntity
            ?.totalEmployees;

    final presentees =
        Provider.of<AttendanceCountProvider>(context, listen: true)
            .user
            ?.attendanceEntity
            ?.presentees;

    final shiftstatus = Provider.of<ShiftStatusProvider>(context, listen: false)
            .user
            ?.shiftStatusdetailEntity
            ?.psShiftStatus ??
        0;

    final psId = Provider.of<ShiftStatusProvider>(context, listen: false)
            .user
            ?.shiftStatusdetailEntity
            ?.psId ??
        0;

    final Size size = MediaQuery.of(context).size;

    return  isLoading
                ? Scaffold(
                  backgroundColor: Colors.white,
                  body:   Center(child: CircularProgressIndicator()),
                )
                
                
                // Show loading indicator while fetching data
                :
    
    Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: MobileMyDrawer(),
      appBar: 
      AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding:
              const EdgeInsets.only(top: 40.0), // Adjust top padding as needed
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: SvgPicture.asset(
                  'assets/svg/drawer.svg',
                  color: Color.fromARGB(255, 80, 96, 203),
                  width: 36,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                processname,
                style: TextStyle(
                  color: Color.fromARGB(255, 80, 96, 203),
                  fontSize: 24.0,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                  width: 36), // Placeholder to balance the drawer icon width
            ],
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body:
      
      
       SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white
                  // image: DecorationImage(
                  //   image: AssetImage('assets/images/mobile_scaffold.jpg'),
                  //   fit: BoxFit.cover,
                  // ),
                  ),
            ),
            processname != "Default"
                ? Padding(
                    padding: EdgeInsets.only(
                      top: 10.h,
                 
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left:8.w,right: 8.w),
                          child: Material(
                          
        elevation: 3,
        borderRadius: BorderRadius.circular(5.r),
                            child: MobileShitStatusWidget(
                              deptid: deptid,
                              processid: processId,
                              shiftgroupid: shiftgroupId,
                              psid: psId,
                            ),
                          ),
                        ),
        
                        MobileProcessQtyWidget(id: processId, psid: psId),
                            ( processname != "Default" && shiftstatus != 0) ?
                        Padding(
                          padding: EdgeInsets.only(left: 8.w, right: 8.w),
                          child: Text(
                            "Employee Details",
                            style: TextStyle(
                              color: Color.fromARGB(255, 80, 96, 203),
                              fontSize: 18.0,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ) :SizedBox(),
                 
        
                        SizedBox(height: 4.h),
                        processname != "Default" && shiftstatus != 0
                            ? EmployeeWorkStationMobile(
                                deptid: deptid?? 1057, psid: psId)
                            : SizedBox(), // Or any other fallback widget
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                        " 'Start by Choosing a Process Area' ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: "Lexend"),
                      )),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
