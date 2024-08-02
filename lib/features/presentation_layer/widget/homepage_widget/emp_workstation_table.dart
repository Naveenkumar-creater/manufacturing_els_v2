import 'dart:async';
import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prominous/constant/request_data_model/workstation_change_model.dart';
import 'package:prominous/constant/utilities/customwidgets/custombutton.dart';
import 'package:prominous/features/data/model/shift_status_model.dart';
import 'package:prominous/features/presentation_layer/api_services/listofworkstation_di.dart';
import 'package:prominous/features/presentation_layer/provider/listofworkstation_provider.dart';
import 'package:prominous/features/presentation_layer/widget/emp_production_entry_widget/emp_close_shift_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/constant/request_data_model/send_attendence_model.dart';
import 'package:prominous/features/presentation_layer/api_services/attendace_count_di.dart';
import 'package:prominous/features/presentation_layer/api_services/employee_di.dart';
import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../../constant/request_model.dart';

import '../../../../constant/show_pop_error.dart';
import '../../../data/core/api_constant.dart';
import '../../api_services/process_di.dart';
import '../../provider/employee_provider.dart';
import '../emp_production_entry_widget/emp_workstation_entry.dart';
import 'employe_allocation_popup.dart';

class EmployeeWorkStation extends StatefulWidget {
  // final int id;
  // final int shiftid;
  final int deptid;
  final int? psid;

  final Function? refreshCallback;

  const EmployeeWorkStation({
    Key? key,
    // required this.id,
    // required this.shiftid,
    required this.deptid,
    this.refreshCallback,
    this.psid,
  }) : super(key: key);

  @override
  State<EmployeeWorkStation> createState() => _EmployeeWorkStationState();
}

class _EmployeeWorkStationState extends State<EmployeeWorkStation> {
  EmployeeApiService employeeApiService = EmployeeApiService();
  AttendanceCountService attendanceCountService = AttendanceCountService();

  ListofworkstationService listofworkstationService =
      ListofworkstationService();

  late int? initialindex;
  bool isLoading = true;

  // void showEmployeeAllocationPopup(
  //     {int? empPersonid,
  //     int? processId,
  //     int? deptid,
  //     int? mfgpeId,
  //     String? attId}
  //     // int? shitid
  //     ) async {
  //   // Capture the valid context before the asynchronous operation
  //   final validContext = context;

  //   showDialog(
  //     context: validContext,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: Container(
  //           padding: EdgeInsets.all(20),
  //           width: 400,
  //           height: 500,
  //           decoration: BoxDecoration(color: Colors.white),
  //           child: EmployeeAllocationPopup(
  //             empId: empPersonid,

  //             processid: processId,
  //             //  shiftid: shitid,
  //             deptid: deptid,
  //             psid: widget.psid,
  //             attid: int.tryParse(attId ?? ""),
  //             mfgpeid: mfgpeId,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void showEmployeeAllocationPopup(
      {int? empPersonid,
      int? processId,
      int? deptid,
      int? mfgpeId,
      String? attId}
      // int? shitid
      ) async {
    // Capture the valid context before the asynchronous operation
    final validContext = context;
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
              .animate(animation),
          child: FadeTransition(
            opacity: Tween(begin: 0.5, end: 1.0).animate(animation),
            child: Align(
              alignment: Alignment.centerRight, // Align the drawer to the right
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width *
                    0.4, // Set the width to half of the screen
                height: MediaQuery.of(context)
                    .size
                    .height, // Set the height to full screen height
                child: EmployeeAllocationPopup(
                  empId: empPersonid,

                  processid: processId,
                  //  shiftid: shitid,
                  deptid: deptid,
                  psid: widget.psid,
                  attid: int.tryParse(attId ?? ""),
                  mfgpeid: mfgpeId,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Load employee list initially
    // loadEmployeeList();
  }

  // Future<void> loadEmployeeList()  async{
  //   try {
  //     final int? process_id =
  //         Provider.of<ShiftStatusProvider>(context, listen: false)
  //             .user
  //             ?.shiftStatusdetailEntity
  //             ?.psMpmId;

  //     employeeApiService.employeeList(
  //         context: context,
  //         deptid: widget.deptid,
  //         processid: process_id ?? 0,
  //         psid: widget.psid ?? 0);

  //     setState(() {
  //       isLoading = true; // Set isLoading to false when data is fetched
  //     });
  //   } catch (e) {
  //     // ignore: avoid_print
  //     // print('Error fetching asset list: $e');
  //     setState(() {
  //       isLoading = false; // Set isLoading to false even if there's an error
  //     });
  //   }
  // }

  // void loadEmployeeList() {
  //   employeeApiService.employeeList(context: context, id: widget.id);
  // }
  // void handleToggleAction(int index) async {
  //   await loadEmployeeList();
  // }

  Future<void> sendAttendance(int? index, String? attendanceid,
      int? empPersonid, String? flattdate, int? pwsId) async {
    final process_id = Provider.of<EmployeeProvider>(context, listen: false)
        .user
        ?.listofEmployeeEntity
        ?.first
        .processId;
    final shitId = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftId;
    final shiftStatus = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftStatus;
    final Shiftid = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftId;

    final attdid = Provider.of<EmployeeProvider>(context, listen: false)
        .user
        ?.listofEmployeeEntity
        ?.first
        .attendanceid;
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";
    DateTime now = DateTime.now();
    //DateTime today = DateTime(now.year, now.month, now.day);;

    int dt;

    dt = int.tryParse(attendanceid ?? "") ?? 0;

    final requestBody = SendAttendencereqModel(
        apiFor: "floor_attendance_v1",
        clientAuthToken: token,
        attId: dt,
        attStatus: index,
        deptId: widget.deptid,
        empid: empPersonid,
        processId: process_id,
        psid: widget.psid,
        shiftId: Shiftid,
        shiftStatus: shiftStatus,
        pwsId: pwsId);

    final requestBodyjson = jsonEncode(requestBody.toJson());

    print(requestBodyjson);

    const timeoutDuration = Duration(seconds: 30);
    try {
      http.Response response = await http
          .post(
            Uri.parse(ApiConstant.baseUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: requestBodyjson,
          )
          .timeout(timeoutDuration);

      // ignore: avoid_print
      print(response.body);

      if (response.statusCode == 200) {
        try {
          final responseJson = jsonDecode(response.body);
          // loadEmployeeList();
          print(responseJson);
          return responseJson;
        } catch (e) {
          // Handle the case where the response body is not a valid JSON object
          throw ("Invalid JSON response from the server");
        }
      } else {
        throw ("Server responded with status code ${response.statusCode}");
      }
    } on TimeoutException {
      throw ('Connection timed out. Please check your internet connection.');
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }

  Future<void> _changeWorkstation(
      {int? pwesId,
      int? empPersonid,
      int? pwsId,
      int? attId,
      int? attstatus}) async {
    final process_id = Provider.of<EmployeeProvider>(context, listen: false)
        .user
        ?.listofEmployeeEntity
        ?.first
        .processId;
    final shitId = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftId;

    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";

    final requestBody = WorkstationChanges(
      clientAutToken: token,
      pwseempid: empPersonid,
      apiFor: "change_workstation_v1",
      pwsePwsId: pwsId,
      pwseId: pwesId,
      attid: attId,
      // flattstatus: attstatus
    );

    final requestBodyjson = jsonEncode(requestBody.toJson());

    print(requestBodyjson);

    const timeoutDuration = Duration(seconds: 30);
    try {
      http.Response response = await http
          .post(
            Uri.parse(ApiConstant.baseUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: requestBodyjson,
          )
          .timeout(timeoutDuration);

      // ignore: avoid_print
      print(response.body);

      if (response.statusCode == 200) {
        try {
          final responseJson = jsonDecode(response.body);
          // loadEmployeeList();
          print(responseJson);
          return responseJson;
        } catch (e) {
          // Handle the case where the response body is not a valid JSON object
          throw ("Invalid JSON response from the server");
        }
      } else {
        throw ("Server responded with status code ${response.statusCode}");
      }
    } on TimeoutException {
      throw ('Connection timed out. Please check your internet connection.');
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
  // void _closeShiftPop(
  //   BuildContext context,
  //   String attenceid,
  //   int attendceStatus,
  //   int empPersonid,
  //   int processid,
  // ) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           backgroundColor: Colors.white,
  //           child: WillPopScope(
  //             onWillPop: () async {
  //               return false;
  //             },
  //             child: Container(
  //               width: 200,
  //               height: 150,
  //               decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(8)),
  //               child: Padding(
  //                 padding: const EdgeInsets.only(
  //                   top: 32,
  //                 ),
  //                 child: Column(children: [
  //                   const Text("Confirm you submission"),
  //                   const SizedBox(
  //                     height: 32,
  //                   ),
  //                   Center(
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         ElevatedButton(
  //                           onPressed: () async {
  //                             try {
  //                               await employeeApiService.employeeList(
  //                                 context: context,
  //                                 processid: processid ?? 0,
  //                                 deptid: widget.deptid ?? 1,
  //                                 psid: widget.psid ?? 0,
  //                               );
  //                               await listofworkstationService
  //                                   .getListofWorkstation(
  //                                       context: context,
  //                                       deptid: widget.deptid ?? 1057,
  //                                       psid: widget.psid ?? 0,
  //                                       processid: processid);
  //                               // Call the EmpClossShift.empCloseShift method

  //                               await EmpClosesShift.empCloseShift(
  //                                   'emp_close_shift',
  //                                   widget.psid ?? 0,
  //                                   1,
  //                                   attenceid ?? " ",
  //                                   attendceStatus ?? 0);

  //                               Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                   builder: (context) =>
  //                                       EmpWorkstationProductionEntryPage(
  //                                     empid: empPersonid!,
  //                                     processid: processid ?? 1,
  //                                     deptid: widget.deptid,
  //                                     isload: true,
  //                                     attenceid: attenceid,
  //                                     attendceStatus: attendceStatus,
  //                                     // shiftId: widget.shiftid,
  //                                     psid: widget.psid,
  //                                   ),
  //                                 ),
  //                               );
  //                             } catch (error) {
  //                               // Handle and show the error message here
  //                               ScaffoldMessenger.of(context).showSnackBar(
  //                                 SnackBar(
  //                                   content: Text(error.toString()),
  //                                   backgroundColor: Colors.amber,
  //                                 ),
  //                               );
  //                             }
  //                           },
  //                           child: const Text("Submit"),
  //                         ),
  //                         const SizedBox(
  //                           width: 20,
  //                         ),
  //                         ElevatedButton(
  //                             onPressed: () {
  //                               Navigator.pop(context);
  //                             },
  //                             child: const Text("Go back")),
  //                       ],
  //                     ),
  //                   )
  //                 ]),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  void _workstationPopup(
      {int? empPersonid,
      int? pwseId,
      int? processId,
      int? attid,
      int? attStatus}) {
    final listofWorkstation =
        Provider.of<ListofworkstationProvider>(context, listen: false)
            .user
            ?.listOfWorkstation;

    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
              .animate(animation),
          child: FadeTransition(
            opacity: Tween(begin: 0.5, end: 1.0).animate(animation),
            child: Align(
              alignment: Alignment.centerRight, // Align the drawer to the right
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width *
                    0.4, // Set the width to half of the screen
                height: MediaQuery.of(context)
                    .size
                    .height, // Set the height to full screen height
                child: Drawer(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  backgroundColor: Color.fromARGB(150, 235, 236, 255),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Workstation',
                            style: TextStyle(
                                fontSize: 24.sp,
                                color: Color.fromARGB(255, 80, 96, 203),
                                fontFamily: "Lexend",
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: listofWorkstation?.length,
                              itemBuilder: (context, index) {
                                final workstation = listofWorkstation?[index];

                                return GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.h,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border(
                                      top: (index == 0)
                                          ? BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade500)
                                          : BorderSide.none,
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Colors.grey.shade500),
                                    )), // Set unique background color for selected tile
                                    child: Text(
                                      "${workstation?.pwsName} ",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: "Lexend",
                                          fontSize: 15.sp),
                                    ),
                                  ),
                                  onTap: () async {
                                    await _changeWorkstation(
                                      empPersonid: empPersonid,
                                      pwesId: pwseId,
                                      pwsId: workstation?.pwsId,
                                      attId: attid,
                                      // attstatus: attStatus ?? 0
                                    );
                                    await employeeApiService.employeeList(
                                        context: context,
                                        processid: processId ?? 0,
                                        deptid: widget.deptid ?? 1,
                                        psid: widget.psid ?? 0);

                                    await listofworkstationService
                                        .getListofWorkstation(
                                            context: context,
                                            deptid: widget.deptid ?? 1057,
                                            psid: widget.psid ?? 0,
                                            processid: processId ?? 0);

                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeeResponse =
        Provider.of<EmployeeProvider>(context, listen: true)
            .user
            ?.listofEmployeeEntity;

    final listofWorkstation =
        Provider.of<ListofworkstationProvider>(context, listen: true)
            .user
            ?.listOfWorkstation;
    print(employeeResponse);
    final empid =
        employeeResponse?.isNotEmpty == true ? employeeResponse!.indexed : null;

    final int? process_id =
        Provider.of<ShiftStatusProvider>(context, listen: false)
            .user
            ?.shiftStatusdetailEntity
            ?.psMpmId;
    final Size size = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.r),
              topRight: Radius.circular(5.r),
              bottomLeft: Radius.circular(5.r),
              bottomRight: Radius.circular(5.r)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              // color: Colors.amber,
              decoration: BoxDecoration(
                color: Color.fromARGB(150, 235, 236, 255),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.r),
                    topRight: Radius.circular(5.r),
                    bottomLeft: Radius.circular(5.r),
                    bottomRight: Radius.circular(5.r)),
              ),
              width: 498.w,
              height: 500.h,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 76.h,
                      width: 506.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.r),
                            topRight: Radius.circular(5.r)),
                        color: Color.fromARGB(255, 45, 54, 104),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.w),
                            child: Container(
                                width: 40.w,
                                child: Text('S.No',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "lexend",
                                        fontSize: 14.sp))),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 8.w),
                            child: Container(
                                alignment: Alignment.center,
                                width: 120.w,
                                child: Text('Workstation',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "lexend",
                                        fontSize: 14.sp))),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     width: 120,
                          //     alignment: Alignment.center,
                          //     child: Text('Prev Product',
                          //         style: TextStyle(color: Colors.white)),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     width: 100,
                          //     alignment: Alignment.center,
                          //     child: Text('Prev Time',
                          //         style: TextStyle(color: Colors.white)),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     width: 120,
                          //     alignment: Alignment.center,
                          //     child: Text('Production Qty',
                          //         style: TextStyle(color: Colors.white)),
                          //   ),
                          // ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 8.w),
                            child: Container(
                              width: 110.w,
                              alignment: Alignment.center,
                              child: Text('No of Staff',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "lexend",
                                      fontSize: 14.sp)),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     width: 120,
                          //     alignment: Alignment.center,
                          //     child: Text('Allocation',
                          //         style: TextStyle(color: Colors.white)),
                          //   ),
                          // ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 8.w),
                            child: Container(
                              width: 130.w,
                              alignment: Alignment.center,
                              child: Text('Production Entry',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "lexend",
                                      fontSize: 14.sp)),
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: listofWorkstation?.length ?? 0,
                      itemBuilder: (context, index) {
                        final listWorkstation = listofWorkstation![index];
                        DateTime now = DateTime.now();
                        String today = DateFormat('yyyy-MM-dd').format(now);

                        // String? dt = listWorkstation.flattdate;
                        // int? shiftstatus = employee?.flattshiftstatus;
                        // initialindex = employee.flattstatus;

                        // String? flattDate = dt; // Parse dt to DateTime if not null

                        // String attdate =
                        //     flattDate ?? ""; // Format flattDate if not null

                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Colors.grey.shade300)),
                            color: index % 2 == 0
                                ? Colors.grey.shade50
                                : Colors.grey.shade100,
                          ),
                          height: 85.h,
                          width: double.infinity,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.h, horizontal: 8.w),
                                child: Container(
                                    alignment: Alignment.center,
                                    width: 40.w,
                                    child: Text('${index + 1}',
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontFamily: "lexend",
                                            fontSize: 14.sp))),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.h, horizontal: 8.w),
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: 120.w,
                                    child: Text(
                                        "${listWorkstation.pwsName}" ?? '',
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontFamily: "lexend",
                                            fontSize: 14.sp))),
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.h, horizontal: 4.w),
                                child: Container(
                                    alignment: Alignment.center,
                                    width: 120.w,
                                    child: Text("${listWorkstation.noOfStaff}",
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontFamily: "lexend",
                                            fontSize: 14.sp))),
                              ),

                            
                              if (listWorkstation.noOfStaff != 0)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.h, horizontal: 20.w),
                                  child: Container(
                                      width: 100.w,
                                      child: CustomButton(
                                        onPressed: () {
                                          // final employeeProvider =
                                          //     Provider.of<EmployeeProvider>(
                                          //         context,
                                          //         listen: false);

                                          // // Get the employee ID of the current employee
                                          // final employeeId =
                                          //     employeeResponse[index]
                                          //         .empPersonid;

                                          // // Update the employee ID in the provider
                                          // employeeProvider
                                          //     .updateEmployeeId(employeeId!);

                                          // Navigate to the ProductionQuantityPage
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EmpWorkstationProductionEntryPage(
                                                // empid: employee.empPersonid!,
                                                processid: process_id ?? 1,
                                                deptid: widget.deptid,
                                                isload: true,
                                                pwsid: listWorkstation.pwsId,
                                                workstationName:
                                                    listWorkstation.pwsName,
                                                // attenceid:
                                                //     employee.attendanceid,
                                                // attendceStatus:
                                                //     employee.flattstatus,
                                                // shiftId: widget.shiftid,
                                                psid: widget.psid,
                                              ),
                                            ),
                                          );

                                          // Fetch employee list
                                          // employeeApiService.employeeList(
                                          //   context: context,
                                          //   processid:
                                          //       widget.processId ?? 0,
                                          //   deptid: widget.deptid ?? 1,
                                          //   psid: widget.psid ?? 0,
                                          // );
                                        },
                                        width: 70.w,
                                        height: 40.h,
                                        backgroundColor: Colors.green,
                                        borderRadius: BorderRadius.circular(50),
                                        child: Text("Add",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "lexend",
                                                fontSize: 14.sp)),
                                      )),
                                )
                          
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
                child: Container(
              width: 498.w,
              height: 758.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.r),
                    topRight: Radius.circular(5.r),
                    bottomLeft: Radius.circular(5.r),
                  
                    bottomRight: Radius.circular(5.r)),
                color: Color(0x96EBECFF),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 76.h,
                      width: 506.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.r),
                            topRight: Radius.circular(5.r)),
                        color: Color.fromARGB(255, 45, 54, 104),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.w),
                            child: Container(
                                width: 40.w,
                                child: Text('S.No',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "lexend",
                                        fontSize: 14.sp))),
                          ),
                          Container(
                              alignment: Alignment.center,
                              width: 120.w,
                              child: Text('Staff Name',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "lexend",
                                      fontSize: 14.sp))),
                          Container(
                              alignment: Alignment.center,
                              width: 120.w,
                              child: Text('Workstation',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "lexend",
                                      fontSize: 14.sp))),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     width: 120,
                          //     alignment: Alignment.center,
                          //     child: Text('Prev Product',
                          //         style: TextStyle(color: Colors.white)),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     width: 100,
                          //     alignment: Alignment.center,
                          //     child: Text('Prev Time',
                          //         style: TextStyle(color: Colors.white)),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     width: 120,
                          //     alignment: Alignment.center,
                          //     child: Text('Production Qty',
                          //         style: TextStyle(color: Colors.white)),
                          //   ),
                          // ),
                          Container(
                            width: 100.w,
                            alignment: Alignment.center,
                            child: Text('Clock In',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "lexend",
                                    fontSize: 14.sp)),
                          ),
                          Container(
                            width: 90.w,
                            alignment: Alignment.center,
                            child: Text('Reassign',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "lexend",
                                    fontSize: 14.sp)),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     width: 120,
                          //     alignment: Alignment.center,
                          //     child:
                          //         Text('Production Entry', style: TextStyle(color: Colors.white)),
                          //   ),
                          // ),
                        ],
                      )),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: employeeResponse?.length ?? 0,
                      itemBuilder: (context, index) {
                        final employee = employeeResponse![index];
                        DateTime now = DateTime.now();
                        String today = DateFormat('yyyy-MM-dd').format(now);

                        String? dt = employee.flattdate;
                        int? shiftstatus = employee?.flattshiftstatus;
                        initialindex = employee.flattstatus;

                        String? flattDate =
                            dt; // Parse dt to DateTime if not null

                        String attdate =
                            flattDate ?? ""; // Format flattDate if not null

                        return Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.grey.shade300)),
                              color: (employee.pwsName!.isEmpty)
                                  ? Colors.blue.withOpacity(0.3)
                                  : (index % 2 == 0)
                                      ? Colors.grey[50]
                                      : Colors.grey.shade100),
                          height: 85.h,
                          width: double.infinity,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.h, horizontal: 8.w),
                                child: Container(
                                    alignment: Alignment.center,
                                    width: 40.w,
                                    child: Text('${index + 1}',
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontFamily: "lexend",
                                            fontSize: 14.sp))),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.h, horizontal: 4.w),
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: 110.w,
                                    child: Text(
                                        employee!.personFname![0]
                                                    .toUpperCase() +
                                                employee!.personFname!
                                                    .substring(
                                                        1,
                                                        employee!.personFname!
                                                                .length -
                                                            1)
                                                    .toLowerCase() +
                                                employee!.personFname!
                                                    .substring(employee!
                                                            .personFname!
                                                            .length -
                                                        1)
                                                    .toUpperCase() ??
                                            '',
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontFamily: "lexend",
                                            fontSize: 14.sp))),
                              ),

                              SizedBox(
                                width: 130.w,
                                child: ElevatedButton(
                                    onPressed: () {
                                      //  showAnimatedDialog(context);

                                      _workstationPopup(
                                        empPersonid: employee.empPersonid,
                                        processId: employee.processId,
                                        pwseId: employee.pwseid,
                                        attid: int.tryParse(employee
                                                        .attendanceid
                                                        ?.isEmpty ??
                                                    true
                                                ? '0'
                                                : employee.attendanceid ??
                                                    '0') ??
                                            0,
                                        attStatus: initialindex ?? 0,
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Text(
                                        (employee?.pwsName?.isEmpty ?? true)
                                            ? "Select_WS"
                                            : employee!.pwsName!,
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 80, 96, 203),
                                          fontFamily: "lexend",
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    )),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //                                   _workstationPopup(
                              //   empPersonid: employee.empPersonid,
                              //   processId: employee.processId,
                              //   pwseId: employee.pwseid,
                              //   attid: int.tryParse(employee.attendanceid?.isEmpty ?? true ? '0' : employee.attendanceid ?? '0') ?? 0,
                              //   attStatus: initialindex ?? 0,
                              // );

                              //   },
                              //   child: Container(

                              //     alignment: Alignment.center,
                              //     width: 100.w,
                              //     child: Card(

                              //       child: Padding(
                              //         padding:  EdgeInsets.only(bottom: 6.h,top: 6.h, left: 2.w,right: 2.w),
                              //         child: Text(
                              //           employee?.pwsName ?? "",
                              //           style: TextStyle(
                              //             color: Colors.grey.shade600,
                              //            fontFamily: "lexend",fontSize: 14.sp
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Container(
                              //       alignment: Alignment.center,
                              //       width: 120,
                              //       child: Text(employee?.productName ?? '',
                              //           style: TextStyle(
                              //               color: Colors.grey.shade600,
                              //               fontSize: 12))),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Container(
                              //       alignment: Alignment.center,
                              //       width: 100,
                              //       child: Padding(
                              //         padding: const EdgeInsets.only(left: 15),
                              //         child: Text(employee.timing.toString(),
                              //             style: TextStyle(
                              //                 color: Colors.grey.shade600,
                              //                 fontSize: 12)),
                              //       )),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Container(
                              //     width: 120,
                              //     alignment: Alignment.center,
                              //     child: Text(employee.productQty.toString() ?? "",
                              //         style: TextStyle(
                              //             color: Colors.grey.shade600,
                              //             fontSize: 12)),
                              //   ),
                              // ),

                              if (initialindex == 0)
                                SizedBox(
                                  width: 90.w,
                                  child: Container(
                                      alignment: Alignment.center,
                                      width: 100.w,
                                      child: CustomButton(
                                        child: Text(
                                          "Absent",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                        height: 40.h,
                                        width: 80.w,
                                        borderRadius: BorderRadius.circular(50),
                                        onPressed: (employee
                                                    ?.pwsName?.isEmpty ??
                                                true)
                                            ? null
                                            : () async {
                                                await sendAttendance(
                                                    1,
                                                    employee?.attendanceid ??
                                                        "",
                                                    employee.empPersonid,
                                                    employee.flattdate,
                                                    employee.pwsId);

                                                await employeeApiService
                                                    .employeeList(
                                                        context: context,
                                                        processid: employee
                                                                .processId ??
                                                            0,
                                                        deptid:
                                                            widget.deptid ?? 1,
                                                        psid: widget.psid ?? 0);
                                                await listofworkstationService
                                                    .getListofWorkstation(
                                                        context: context,
                                                        deptid: widget.deptid ??
                                                            1057,
                                                        psid: widget.psid ?? 0,
                                                        processid: employee
                                                                .processId ??
                                                            0);

                                                await attendanceCountService
                                                    .getAttCount(
                                                        context: context,
                                                        id: employee
                                                                .processId ??
                                                            0,
                                                        deptid: widget.deptid,
                                                        psid: widget.psid ?? 0);
                                              },
                                      )),
                                )
                              else if (initialindex == 1)
                                SizedBox(
                                  width: 90.w,
                                  child: Container(
                                      alignment: Alignment.center,
                                      width: 100.w,
                                      child: CustomButton(
                                        child: Text(
                                          "Present",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green,
                                        height: 40.h,
                                        width: 80.w,
                                        borderRadius: BorderRadius.circular(50),
                                        onPressed: (employee
                                                    ?.pwsName?.isEmpty ??
                                                true)
                                            ? null
                                            : () async {
                                                await sendAttendance(
                                                    0,
                                                    employee?.attendanceid ??
                                                        "",
                                                    employee.empPersonid,
                                                    employee.flattdate,
                                                    employee.pwsId);

                                                await employeeApiService
                                                    .employeeList(
                                                        context: context,
                                                        processid: employee
                                                                .processId ??
                                                            0,
                                                        deptid:
                                                            widget.deptid ?? 1,
                                                        psid: widget.psid ?? 0);
                                                await listofworkstationService
                                                    .getListofWorkstation(
                                                        context: context,
                                                        deptid: widget.deptid ??
                                                            1057,
                                                        psid: widget.psid ?? 0,
                                                        processid: employee
                                                                .processId ??
                                                            0);

                                                await attendanceCountService
                                                    .getAttCount(
                                                        context: context,
                                                        id: employee
                                                                .processId ??
                                                            0,
                                                        deptid: widget.deptid,
                                                        psid: widget.psid ?? 0);
                                              },
                                      )),
                                ),

                              // Padding(
                              //   padding: EdgeInsets.symmetric(
                              //       vertical: 4.h, horizontal: 4.w),
                              //   child: Container(
                              //     alignment: Alignment.center,
                              //     width: 80.w,
                              //     child: ToggleSwitch(
                              //       minWidth: 30.0,
                              //       minHeight: 30,
                              //       cornerRadius: 20.0,
                              //       activeBgColors: [
                              //         [Colors.red[800]!],
                              //         [Colors.green[800]!]
                              //       ],
                              //       activeFgColor: Colors.white,
                              //       inactiveBgColor: Colors.grey,
                              //       initialLabelIndex: initialindex,
                              //       totalSwitches: 2,
                              //       labels: ['A', 'P'],
                              //       radiusStyle: true,
                              //       onToggle: (index) async {
                              //         await sendAttendance(
                              //             index,
                              //             employee?.attendanceid ?? "",
                              //             employee.empPersonid,
                              //             employee.flattdate,
                              //             employee.pwsId);
                              //         print('switched to: $index');

                              //         await employeeApiService.employeeList(
                              //             context: context,
                              //             processid: employee.processId ?? 0,
                              //             deptid: widget.deptid ?? 1,
                              //             psid: widget.psid ?? 0);
                              //         await listofworkstationService
                              //             .getListofWorkstation(
                              //                 context: context,
                              //                 deptid: widget.deptid ?? 1057,
                              //                 psid: widget.psid ?? 0,
                              //                 processid:
                              //                     employee.processId ?? 0);

                              //       await attendanceCountService.getAttCount(
                              //             context: context,
                              //             id: employee.processId ?? 0,
                              //             deptid: widget.deptid,
                              //             psid: widget.psid ?? 0);
                              //       },
                              //     ),
                              //   ),
                              // ),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.h, horizontal: 2.w),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 100.w,
                                  child: ElevatedButton(
                                    child: Text(
                                      "Change",
                                      style: TextStyle(fontSize: 14.w),
                                    ),
                                    onPressed: initialindex == 0
                                        ? null
                                        : () {
                                            setState(() {
                                              showEmployeeAllocationPopup(
                                                attId: employee.attendanceid,
                                                deptid: widget.deptid ?? 0,
                                                empPersonid:
                                                    employee.empPersonid,
                                                mfgpeId: employee.mfgpempid,

                                                processId: employee.processId,

                                                // widget?.shiftid ??0,
                                              );
                                              employeeApiService.employeeList(
                                                  context: context,
                                                  processid:
                                                      employee.processId ?? 0,
                                                  deptid: widget.deptid ?? 1,
                                                  psid: widget.psid ?? 0);
                                            });
                                          },
                                  ),
                                ),
                              ),
                              // if (shiftstatus == 1)
                              //   Padding(
                              //     padding: const EdgeInsets.only(left: 10,right: 10),
                              //     child: Container(
                              //         width: 120,
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: ElevatedButton(
                              //             onPressed: initialindex == 0
                              //                 ? null
                              //                 : () {
                              //                     final employeeProvider =
                              //                         Provider.of<EmployeeProvider>(
                              //                             context,
                              //                             listen: false);

                              //                     // Get the employee ID of the current employee
                              //                     final employeeId =
                              //                         employeeResponse[index]
                              //                             .empPersonid;

                              //                     // Update the employee ID in the provider
                              //                     employeeProvider
                              //                         .updateEmployeeId(employeeId!);

                              //                     // Navigate to the ProductionQuantityPage
                              //                     Navigator.push(
                              //                       context,
                              //                       MaterialPageRoute(
                              //                         builder: (context) =>
                              //                             EmpProductionEntryPage(
                              //                           empid: employee.empPersonid!,
                              //                           processid: process_id ?? 1,
                              //                           deptid: widget.deptid,
                              //                           isload: true,
                              //                           attenceid:
                              //                               employee.attendanceid,
                              //                           attendceStatus:
                              //                               employee.flattstatus,
                              //                           // shiftId: widget.shiftid,
                              //                           psid: widget.psid,
                              //                         ),
                              //                       ),
                              //                     );

                              //                     // Fetch employee list
                              //                     employeeApiService.employeeList(
                              //                       context: context,
                              //                       processid:
                              //                           employee.processId ?? 0,
                              //                       deptid: widget.deptid ?? 1,
                              //                       psid: widget.psid ?? 0,
                              //                     );
                              //                   },
                              //             child: Text("Add"),
                              //           ),
                              //         )),
                              //   )
                              // else if (shiftstatus == 2)
                              //   Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Container(
                              //        width: 120,
                              //       child: Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: ElevatedButton(
                              //           onPressed: initialindex == 0
                              //               ? null
                              //               : () {
                              //                   final employeeProvider =
                              //                       Provider.of<EmployeeProvider>(context,
                              //                           listen: false);

                              //                   // Get the employee ID of the current employee
                              //                   final employeeId =
                              //                       employeeResponse[index].empPersonid;

                              //                   // Update the employee ID in the provider
                              //                   employeeProvider
                              //                       .updateEmployeeId(employeeId!);
                              //                   print(shiftstatus);

                              //                   _closeShiftPop(
                              //                       context,
                              //                       employee.attendanceid ?? "",
                              //                       employee.flattstatus ?? 0,
                              //                       employee.empPersonid ?? 0,
                              //                       employee.processId ?? 0);

                              //                   // Navigate to the ProductionQuantityPage
                              //                 },
                              //           child: Text("Reopen",
                              //               style: TextStyle(color: Colors.red)),
                              //         ),
                              //       ),
                              //     ),
                              //   )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
